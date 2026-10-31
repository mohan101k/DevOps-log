#!/usr/bin/env bash
set -Eeuo pipefail

PROMETHEUS_VERSION="2.55.1"
ALERTMANAGER_VERSION="0.27.0"
NODE_EXPORTER_VERSION="1.8.2"

log() { echo -e "\n[INFO] $*"; }
fail() { echo "[ERROR] $*" >&2; exit 1; }

[[ "$EUID" -eq 0 ]] || fail "Run: sudo bash install-monitoring-stack.sh"
. /etc/os-release
[[ "$ID" == "ubuntu" ]] || fail "Ubuntu is required (detected: ${ID:-unknown})"

ARCH="$(dpkg --print-architecture)"
case "$ARCH" in
  amd64) GO_ARCH="amd64" ;;
  arm64) GO_ARCH="arm64" ;;
  *) fail "Unsupported architecture: $ARCH" ;;
esac

log "Installing prerequisites"
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates curl wget tar gnupg

log "Configuring official Grafana APT repository"
install -d -m 0755 /etc/apt/keyrings
curl -fsSL https://apt.grafana.com/gpg-full.key -o /etc/apt/keyrings/grafana.asc
chmod 0644 /etc/apt/keyrings/grafana.asc
cat > /etc/apt/sources.list.d/grafana.list <<'EOF'
deb [signed-by=/etc/apt/keyrings/grafana.asc] https://apt.grafana.com stable main
EOF
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y grafana

log "Creating service users and directories"
id prometheus >/dev/null 2>&1 || useradd --system --no-create-home --shell /usr/sbin/nologin prometheus
id node_exporter >/dev/null 2>&1 || useradd --system --no-create-home --shell /usr/sbin/nologin node_exporter
install -d -o prometheus -g prometheus /etc/prometheus /var/lib/prometheus
install -d -o prometheus -g prometheus /etc/alertmanager /var/lib/alertmanager

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

download_release() {
  local url="$1" archive="$2" folder="$3"
  curl -fL --retry 3 "$url" -o "$TMP_DIR/$archive"
  tar -xzf "$TMP_DIR/$archive" -C "$TMP_DIR"
}

log "Installing Prometheus ${PROMETHEUS_VERSION}"
PROM_DIR="prometheus-${PROMETHEUS_VERSION}.linux-${GO_ARCH}"
download_release \
  "https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/${PROM_DIR}.tar.gz" \
  "${PROM_DIR}.tar.gz" "$PROM_DIR"
systemctl stop prometheus 2>/dev/null || true
install -o root -g root -m 0755 "$TMP_DIR/$PROM_DIR/prometheus" /usr/local/bin/prometheus
install -o root -g root -m 0755 "$TMP_DIR/$PROM_DIR/promtool" /usr/local/bin/promtool
cp -a "$TMP_DIR/$PROM_DIR/consoles" "$TMP_DIR/$PROM_DIR/console_libraries" /etc/prometheus/
chown -R prometheus:prometheus /etc/prometheus/consoles /etc/prometheus/console_libraries

log "Installing Alertmanager ${ALERTMANAGER_VERSION}"
AM_DIR="alertmanager-${ALERTMANAGER_VERSION}.linux-${GO_ARCH}"
download_release \
  "https://github.com/prometheus/alertmanager/releases/download/v${ALERTMANAGER_VERSION}/${AM_DIR}.tar.gz" \
  "${AM_DIR}.tar.gz" "$AM_DIR"
systemctl stop alertmanager 2>/dev/null || true
install -o root -g root -m 0755 "$TMP_DIR/$AM_DIR/alertmanager" /usr/local/bin/alertmanager
install -o root -g root -m 0755 "$TMP_DIR/$AM_DIR/amtool" /usr/local/bin/amtool

log "Installing Node Exporter ${NODE_EXPORTER_VERSION}"
NE_DIR="node_exporter-${NODE_EXPORTER_VERSION}.linux-${GO_ARCH}"
download_release \
  "https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/${NE_DIR}.tar.gz" \
  "${NE_DIR}.tar.gz" "$NE_DIR"
systemctl stop node_exporter 2>/dev/null || true
install -o root -g root -m 0755 "$TMP_DIR/$NE_DIR/node_exporter" /usr/local/bin/node_exporter

log "Writing Prometheus configuration"
cat > /etc/prometheus/prometheus.yml <<'EOF'
global:
  scrape_interval: 15s
  evaluation_interval: 15s

alerting:
  alertmanagers:
    - static_configs:
        - targets: ["127.0.0.1:9093"]

rule_files:
  - "/etc/prometheus/alert.rules.yml"

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["127.0.0.1:9090"]

  - job_name: "node-exporter"
    static_configs:
      - targets: ["127.0.0.1:9100"]
EOF

cat > /etc/prometheus/alert.rules.yml <<'EOF'
groups:
  - name: host-alerts
    rules:
      - alert: InstanceDown
        expr: up == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Target {{ $labels.instance }} is down"
          description: "Prometheus cannot scrape {{ $labels.instance }}."

      - alert: HighCPUUsage
        expr: 100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High CPU usage on {{ $labels.instance }}"
          description: "CPU usage has exceeded 80% for 5 minutes."

      - alert: HighDiskUsage
        expr: (1 - (node_filesystem_avail_bytes{fstype!~"tmpfs|overlay"} / node_filesystem_size_bytes{fstype!~"tmpfs|overlay"})) * 100 > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High disk usage on {{ $labels.instance }}"
          description: "Disk usage has exceeded 80% for 5 minutes."
EOF
chown -R prometheus:prometheus /etc/prometheus
chmod 0644 /etc/prometheus/prometheus.yml /etc/prometheus/alert.rules.yml

log "Writing Alertmanager configuration (no secret embedded)"
cat > /etc/alertmanager/alertmanager.yml <<'EOF'
route:
  receiver: default
  group_wait: 10s
  group_interval: 1m
  repeat_interval: 4h

receivers:
  - name: default
EOF
chown -R prometheus:prometheus /etc/alertmanager
chmod 0644 /etc/alertmanager/alertmanager.yml

log "Creating systemd services"
cat > /etc/systemd/system/prometheus.service <<'EOF'
[Unit]
Description=Prometheus Monitoring
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

cat > /etc/systemd/system/alertmanager.service <<'EOF'
[Unit]
Description=Prometheus Alertmanager
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/alertmanager \
  --config.file=/etc/alertmanager/alertmanager.yml \
  --storage.path=/var/lib/alertmanager
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

cat > /etc/systemd/system/node_exporter.service <<'EOF'
[Unit]
Description=Prometheus Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

log "Validating configuration files"
promtool check config /etc/prometheus/prometheus.yml
amtool check-config /etc/alertmanager/alertmanager.yml

log "Starting services"
systemctl daemon-reload
systemctl enable --now prometheus
systemctl enable --now alertmanager
systemctl enable --now node_exporter
systemctl enable --now grafana-server

echo
echo "========== INSTALLATION COMPLETED =========="
echo "Prometheus:   http://EC2-PUBLIC-IP:9090"
echo "Grafana:      http://EC2-PUBLIC-IP:3000"
echo "Alertmanager: http://EC2-PUBLIC-IP:9093"
echo "Node Exporter: localhost:9100 (do not expose publicly)"
echo "Grafana initial login: admin / admin (change on first login)"
echo "Restrict web ports to your IP in the EC2 Security Group."
echo "PagerDuty is not preconfigured; rotate any previously exposed key."
echo "============================================="
