
# AWS EC2 Monitoring Stack with Prometheus, Node Exporter, Grafana, Alertmanager, PagerDuty & ServiceNow

> **Project type:** DevOps / Cloud Monitoring POC\
> **Platform:** AWS EC2 · Amazon Linux 2023\
> **Monitoring stack:** Prometheus · Node Exporter · Grafana ·
> Alertmanager\
> **Incident integrations:** PagerDuty and ServiceNow (integration
> configuration required)

This project demonstrates how to collect infrastructure metrics from
multiple EC2 instances, store and query those metrics with Prometheus,
visualize them in Grafana, and route alerts to incident-management
tools.

------------------------------------------------------------------------

## Table of Contents

-   [1. Architecture](#1-architecture)
-   [2. Components and
    Responsibilities](#2-components-and-responsibilities)
-   [3. Prerequisites](#3-prerequisites)
-   [4. Recommended EC2 Layout](#4-recommended-ec2-layout)
-   [5. Install Node Exporter on Each Monitored
    Server](#5-install-node-exporter-on-each-monitored-server)
-   [6. Install Prometheus](#6-install-prometheus)
-   [7. Configure Prometheus Targets](#7-configure-prometheus-targets)
-   [8. Run Prometheus with systemd](#8-run-prometheus-with-systemd)
-   [9. Verify Prometheus and Node
    Exporter](#9-verify-prometheus-and-node-exporter)
-   [10. Configure Grafana](#10-configure-grafana)
-   [11. Alerting with Alertmanager](#11-alerting-with-alertmanager)
-   [12. PagerDuty and ServiceNow](#12-pagerduty-and-servicenow)
-   [13. AWS Security Group Rules](#13-aws-security-group-rules)
-   [14. Troubleshooting](#14-troubleshooting)
-   [15. Operational and Security
    Notes](#15-operational-and-security-notes)
-   [16. Final Validation Checklist](#16-final-validation-checklist)

------------------------------------------------------------------------

## 1. Architecture

``` mermaid
flowchart TD
    A[EC2 Server 1<br/>Node Exporter :9100]
    B[EC2 Server 2<br/>Node Exporter :9100]
    C[Additional EC2 Servers<br/>Node Exporter :9100]
    P[Prometheus<br/>:9090<br/>Scrape, store and evaluate rules]
    G[Grafana<br/>:3000<br/>Dashboards]
    AM[Alertmanager<br/>:9093<br/>Alert routing]
    PD[PagerDuty<br/>On-call notifications]
    SN[ServiceNow<br/>Incident ticketing]

    A -->|Metrics scrape| P
    B -->|Metrics scrape| P
    C -->|Metrics scrape| P
    P --> G
    P -->|Firing alerts| AM
    AM --> PD
    AM --> SN
```

**Data flow**

1.  Node Exporter runs on each Linux server and exposes host metrics on
    TCP port `9100`.
2.  Prometheus periodically scrapes the Node Exporter endpoints and
    stores metrics in its time-series database.
3.  Grafana queries Prometheus and displays dashboards.
4.  Prometheus evaluates alerting rules and sends firing alerts to
    Alertmanager.
5.  Alertmanager routes notifications to configured receivers, such as
    PagerDuty or a ServiceNow integration endpoint.

> The diagram describes the intended architecture. PagerDuty and
> ServiceNow will not receive alerts until their integrations,
> credentials, and routing rules have been configured and tested.

------------------------------------------------------------------------

## 2. Components and Responsibilities

  ------------------------------------------------------------------------
  Component             Purpose                               Default port
  --------------------- --------------------- ----------------------------
  Node Exporter         Exposes Linux CPU,                          `9100`
                        memory, filesystem,   
                        and network metrics   

  Prometheus            Scrapes, stores, and                        `9090`
                        queries time-series   
                        metrics; evaluates    
                        alert rules           

  Grafana               Dashboards and                              `3000`
                        visualization using   
                        Prometheus as a data  
                        source                

  Alertmanager          Groups, deduplicates,                       `9093`
                        silences, and routes  
                        alerts                

  SSH                   Secure administration                         `22`
                        of EC2 Linux          
                        instances             
  ------------------------------------------------------------------------

PagerDuty and ServiceNow are external services; their connectivity and
integration requirements depend on the chosen integration method.

------------------------------------------------------------------------

## 3. Prerequisites

-   An AWS account with permission to create and manage EC2 instances
    and security groups.
-   Amazon Linux 2023 EC2 instances.
-   SSH or EC2 Instance Connect access.
-   `curl`, `tar`, and `systemd` (available on standard Amazon Linux
    2023 instances).
-   Private IP addresses of all monitored instances.
-   A Prometheus server that can reach Node Exporter on each target.
-   A Grafana installation for dashboards (covered conceptually below).
-   PagerDuty and/or ServiceNow integration credentials only if those
    integrations are being implemented.

Check the operating system and CPU architecture:

``` bash
cat /etc/os-release
uname -m
```

The Node Exporter commands below use the `linux-amd64` build and assume
`x86_64`. For Graviton/ARM instances (`aarch64`), download the matching
`linux-arm64` archive and adjust the extracted directory name.

------------------------------------------------------------------------

## 4. Recommended EC2 Layout

For a learning POC, one EC2 instance can run Prometheus and Grafana,
while other EC2 instances run Node Exporter. Alertmanager may also run
on the monitoring instance for a small setup.

Example layout (replace all example values with your actual private
IPs):

  -----------------------------------------------------------------------
  Role                    Example private IP      Service
  ----------------------- ----------------------- -----------------------
  Monitoring server       `10.0.1.10`             Prometheus, Grafana,
                                                  optionally Alertmanager

  Application server 1    `10.0.2.11`             Node Exporter

  Application server 2    `10.0.3.12`             Node Exporter
  -----------------------------------------------------------------------

Use private IP addresses for communication inside the VPC. Do not copy
the example IPs into your configuration unless they match your own
instances.

------------------------------------------------------------------------

## 5. Install Node Exporter on Each Monitored Server

Run this section on **each EC2 instance that should be monitored**.

### 5.1 Create a dedicated service user

``` bash
id node_exporter || sudo useradd --system --no-create-home --shell /sbin/nologin node_exporter
```

### 5.2 Download and install Node Exporter

This example uses version `1.9.1`. If you choose another release, change
the version consistently in the URL and directory names.

``` bash
cd /tmp

curl -fLO https://github.com/prometheus/node_exporter/releases/download/v1.9.1/node_exporter-1.9.1.linux-amd64.tar.gz

tar -xzf node_exporter-1.9.1.linux-amd64.tar.gz

sudo install -o node_exporter -g node_exporter -m 0755 \
  node_exporter-1.9.1.linux-amd64/node_exporter \
  /usr/local/bin/node_exporter
```

### 5.3 Create a systemd service

``` bash
sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<'EOF'
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

[Install]
WantedBy=multi-user.target
EOF
```

### 5.4 Enable and start Node Exporter

``` bash
sudo systemctl daemon-reload
sudo systemctl enable --now node_exporter
sudo systemctl status node_exporter --no-pager
```

### 5.5 Verify the endpoint locally

``` bash
curl -s http://localhost:9100/metrics | head
```

You should see Prometheus-formatted metrics, such as
`node_cpu_seconds_total` and `node_memory_MemAvailable_bytes`.

Check that port `9100` is listening:

``` bash
sudo ss -tulnp | grep ':9100'
```

Repeat the installation only on servers where Node Exporter is not
installed or running.

------------------------------------------------------------------------

## 6. Install Prometheus

Run this section on the designated **monitoring EC2 instance**. This
example uses Prometheus `3.4.2`, matching the version used during the
POC setup. For a new deployment, check the official Prometheus releases
and use a currently supported release.

### 6.1 Create the service user

``` bash
id prometheus || sudo useradd --system --no-create-home --shell /sbin/nologin prometheus
```

### 6.2 Download and extract Prometheus

The following commands assume an `x86_64` instance:

``` bash
cd /tmp

curl -fLO https://github.com/prometheus/prometheus/releases/download/v3.4.2/prometheus-3.4.2.linux-amd64.tar.gz

tar -xzf prometheus-3.4.2.linux-amd64.tar.gz
```

### 6.3 Install binaries and supporting files

``` bash
sudo install -m 0755 \
  prometheus-3.4.2.linux-amd64/prometheus \
  /usr/local/bin/prometheus

sudo install -m 0755 \
  prometheus-3.4.2.linux-amd64/promtool \
  /usr/local/bin/promtool

sudo mkdir -p /etc/prometheus /var/lib/prometheus

sudo cp -r prometheus-3.4.2.linux-amd64/consoles /etc/prometheus/
sudo cp -r prometheus-3.4.2.linux-amd64/console_libraries /etc/prometheus/
```

Create ownership and permissions:

``` bash
sudo chown prometheus:prometheus /usr/local/bin/prometheus /usr/local/bin/promtool
sudo chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus
```

------------------------------------------------------------------------

## 7. Configure Prometheus Targets

Create `/etc/prometheus/prometheus.yml`. Replace the sample private IP
addresses with the private IP addresses of your actual Node Exporter
instances.

``` bash
sudo tee /etc/prometheus/prometheus.yml > /dev/null <<'EOF'
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets: ['localhost:9090']

  - job_name: node_exporter
    static_configs:
      - targets:
          - '10.0.2.11:9100'
          - '10.0.3.12:9100'
EOF
```

Set file ownership:

``` bash
sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml
```

Validate the configuration:

``` bash
sudo -u prometheus /usr/local/bin/promtool check config /etc/prometheus/prometheus.yml
```

A successful validation reports that the configuration file is valid.

> **Important:** The `10.0.2.11` and `10.0.3.12` addresses are examples
> only. Replace them with your monitored EC2 instances' actual private
> IP addresses. Do not use public IPs for internal scraping when private
> connectivity is available.

------------------------------------------------------------------------

## 8. Run Prometheus with systemd

### 8.1 Create the service file

``` bash
sudo tee /etc/systemd/system/prometheus.service > /dev/null <<'EOF'
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
  --web.listen-address=0.0.0.0:9090
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
```

The `0.0.0.0:9090` listener makes Prometheus reachable on the instance's
network interfaces. Security Group restrictions are therefore important.
In production, prefer private-only access or a protected reverse
proxy/VPN rather than exposing the Prometheus UI publicly.

### 8.2 Reload systemd and start Prometheus

``` bash
sudo systemctl daemon-reload
sudo systemctl enable --now prometheus
sudo systemctl status prometheus --no-pager
```

### 8.3 Check health

``` bash
curl http://localhost:9090/-/healthy
```

Expected response:

``` text
Prometheus Server is Healthy.
```

Check readiness as well:

``` bash
curl http://localhost:9090/-/ready
```

### 8.4 Check logs if it fails

``` bash
sudo journalctl -u prometheus -n 50 --no-pager
```

------------------------------------------------------------------------

## 9. Verify Prometheus and Node Exporter

### 9.1 Check listening ports

``` bash
sudo ss -tulnp
```

Useful ports:

-   `9100`: Node Exporter
-   `9090`: Prometheus
-   `3000`: Grafana
-   `9093`: Alertmanager

A port appears only when the corresponding service is running and
listening.

### 9.2 Check metrics from the Prometheus server

From the monitoring EC2 instance, test each target:

``` bash
curl http://NODE_EXPORTER_PRIVATE_IP:9100/metrics
```

Replace `NODE_EXPORTER_PRIVATE_IP` with the actual private IP address.

### 9.3 Open the Prometheus UI

Open this URL using the **monitoring server's public IP or DNS name**,
if your security policy permits browser access:

``` text
http://PROMETHEUS_PUBLIC_IP:9090
```

Then navigate to **Status → Targets**. The Prometheus and Node Exporter
targets should show `UP` when scraping is successful.

You can also query these metrics in Prometheus:

``` promql
up
```

``` promql
node_cpu_seconds_total
```

``` promql
node_memory_MemAvailable_bytes
```

``` promql
node_filesystem_avail_bytes
```

------------------------------------------------------------------------

## 10. Configure Grafana

Grafana is the visualization layer. Install Grafana on the monitoring
instance or on a separate host using the official Grafana installation
instructions for Amazon Linux/RPM-based systems.

After Grafana is running:

1.  Open `http://GRAFANA_PUBLIC_IP:3000` only from an approved source.
2.  Sign in and change any default credentials immediately.
3.  Open **Connections → Data sources** (the exact menu label may vary
    by version).
4.  Add **Prometheus** as the data source.
5.  If Grafana and Prometheus are on the same host, use
    `http://localhost:9090` as the Prometheus URL. If they are on
    separate hosts, use the monitoring server's private address and
    port.
6.  Select **Save & test**.
7.  Create or import a Node Exporter dashboard and verify that CPU,
    memory, filesystem, and network panels return data.

Grafana queries Prometheus; it does not normally scrape Node Exporter
directly.

------------------------------------------------------------------------

## 11. Alerting with Alertmanager

Prometheus evaluates alert rules. When an alert is firing, Prometheus
sends it to Alertmanager, which handles grouping, deduplication,
silencing, and routing.

### 11.1 Example Prometheus alert rules

Create `/etc/prometheus/alert_rules.yml`:

``` bash
sudo tee /etc/prometheus/alert_rules.yml > /dev/null <<'EOF'
groups:
  - name: host-alerts
    rules:
      - alert: HighCPUUsage
        expr: |
          100 * (1 - avg by (instance) (
            rate(node_cpu_seconds_total{mode="idle"}[5m])
          )) > 75
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High CPU usage on {{ $labels.instance }}"
          description: "CPU usage has been above 75% for 5 minutes."

      - alert: HighDiskUsage
        expr: |
          100 * (1 -
            node_filesystem_avail_bytes{fstype!~"tmpfs|overlay"}
            /
            node_filesystem_size_bytes{fstype!~"tmpfs|overlay"}
          ) > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High disk usage on {{ $labels.instance }}"
          description: "Filesystem usage has exceeded 80% for 5 minutes."
EOF

sudo chown prometheus:prometheus /etc/prometheus/alert_rules.yml
```

Add the following `rule_files` entry to the top level of
`/etc/prometheus/prometheus.yml` (at the same indentation as `global`
and `scrape_configs`):

``` yaml
rule_files:
  - /etc/prometheus/alert_rules.yml
```

Validate the configuration:

``` bash
sudo -u prometheus /usr/local/bin/promtool check config /etc/prometheus/prometheus.yml
```

Restart Prometheus to load the rule file:

``` bash
sudo systemctl restart prometheus
sudo systemctl status prometheus --no-pager
```

> These are example rules. Review filesystem labels and exclusions for
> your environment before relying on disk alerts in production.

### 11.2 Install and configure Alertmanager

Alertmanager must be installed and configured separately. The intended
flow is:

1.  Download the appropriate Alertmanager release for your CPU
    architecture from the official Prometheus project releases.
2.  Install the Alertmanager binary.
3.  Create an Alertmanager configuration with the intended receivers and
    routing rules.
4.  Run it as a `systemd` service.
5.  Configure Prometheus with `alerting.alertmanagers` pointing to the
    Alertmanager host and port `9093`.
6.  Validate the Prometheus configuration and verify the Alertmanager
    UI/health endpoint.

Example Prometheus configuration section (use the correct private
address if Alertmanager runs on a different host):

``` yaml
alerting:
  alertmanagers:
    - static_configs:
        - targets: ['localhost:9093']
```

This is a configuration example, not a complete Alertmanager
installation. Do not add real PagerDuty keys, ServiceNow credentials, or
other secrets to a public repository.

------------------------------------------------------------------------

## 12. PagerDuty and ServiceNow

These integrations are intended to turn monitoring alerts into
actionable incidents. They require separate setup and testing.

### PagerDuty

-   Create or select the appropriate PagerDuty service/integration.
-   Configure Alertmanager's PagerDuty receiver using the current
    official integration instructions.
-   Store integration credentials securely and restrict access to the
    configuration file.
-   Route the desired alert severities to the PagerDuty receiver.
-   Trigger a safe test alert and confirm that the expected on-call user
    receives it.

### ServiceNow

-   Choose a supported integration path, such as an approved ServiceNow
    integration, webhook, or an intermediary incident-management
    integration.
-   Configure authentication, endpoint, field mapping, assignment group,
    and incident priority.
-   Define how duplicate alerts, recoveries, and resolved incidents
    should be handled.
-   Test ticket creation and assignment with a non-production/test
    incident before enabling production routing.

**Do not assume that Alertmanager sends ServiceNow tickets
automatically.** The integration method and configuration depend on the
ServiceNow instance and chosen connector.

------------------------------------------------------------------------

## 13. AWS Security Group Rules

Use the least-privilege principle. Restrict source addresses to the
monitoring host's Security Group or approved administrator IPs.

  ---------------------------------------------------------------------------------
  Destination service                           Port Recommended source
  --------------------- ---------------------------- ------------------------------
  SSH                                           `22` Administrator's public IP or
                                                     approved access path

  Node Exporter                               `9100` Prometheus server's Security
                                                     Group

  Prometheus UI/API                           `9090` Approved
                                                     administrator/VPN/monitoring
                                                     network

  Grafana                                     `3000` Approved
                                                     administrator/VPN/network

  Alertmanager UI/API                         `9093` Monitoring network or approved
                                                     administrators
  ---------------------------------------------------------------------------------

For internal metrics scraping, keep EC2 instances in a reachable
VPC/network path and use their private IPs. Security Groups are
stateful; ensure the required inbound rules exist on the destination
instances.

Avoid opening monitoring ports to `0.0.0.0/0`. Prometheus, Node
Exporter, and Alertmanager endpoints can expose operational information
and generally do not provide full authentication by default.

------------------------------------------------------------------------

## 14. Troubleshooting

### Prometheus service fails with `status=217/USER`

This commonly means systemd cannot resolve the configured service user
or group.

``` bash
id prometheus
```

If the account is missing:

``` bash
sudo useradd --system --no-create-home --shell /sbin/nologin prometheus
```

Then check ownership and restart:

``` bash
sudo chown prometheus:prometheus /usr/local/bin/prometheus /usr/local/bin/promtool
sudo chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus
sudo systemctl daemon-reload
sudo systemctl restart prometheus
sudo systemctl status prometheus --no-pager
```

### Error: `prometheus.yml: no such file or directory`

Prometheus was likely started from a directory where `prometheus.yml`
does not exist. Use the full configuration path:

``` bash
/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus
```

For the normal service-managed run, verify `ExecStart` in
`/etc/systemd/system/prometheus.service` uses this same path.

### Port 9090 is not reachable

``` bash
sudo systemctl status prometheus --no-pager
sudo ss -tulnp | grep ':9090'
curl http://localhost:9090/-/healthy
sudo journalctl -u prometheus -n 50 --no-pager
```

If the local health check works but the browser cannot connect, review
the EC2 Security Group, network ACLs, route table, and the URL/IP used.

### Node Exporter target is `DOWN`

From the Prometheus instance:

``` bash
curl -v http://NODE_EXPORTER_PRIVATE_IP:9100/metrics
```

On the target instance:

``` bash
sudo systemctl status node_exporter --no-pager
sudo ss -tulnp | grep ':9100'
sudo journalctl -u node_exporter -n 50 --no-pager
```

Check the target IP in `prometheus.yml`, VPC connectivity, and the Node
Exporter inbound Security Group rule.

### Validate configuration and reload/restart

``` bash
sudo -u prometheus /usr/local/bin/promtool check config /etc/prometheus/prometheus.yml
sudo systemctl restart prometheus
sudo systemctl status prometheus --no-pager
```

------------------------------------------------------------------------

## 15. Operational and Security Notes

-   Use private IPs for server-to-server scraping within the VPC.
-   Keep Prometheus data in `/var/lib/prometheus` on persistent storage
    and monitor disk capacity.
-   Back up important configuration files before changing them.
-   Pin versions for reproducible learning environments, but review
    official releases and security advisories before production
    deployment.
-   Use least-privilege service accounts rather than running services as
    root.
-   Protect credentials and tokens; do not commit them to GitHub.
-   Restrict access to Prometheus, Grafana, Node Exporter, and
    Alertmanager.
-   Consider TLS, authentication, centralized logging, backups, and high
    availability before production use.
-   A single monitoring EC2 instance is suitable for a POC but can
    become a single point of failure.

------------------------------------------------------------------------

## 16. Final Validation Checklist

-   [ ] Node Exporter is installed on every intended Linux target.
-   [ ] `node_exporter` service is enabled and running.
-   [ ] `curl http://localhost:9100/metrics` returns metrics on each
    target.
-   [ ] Prometheus configuration passes `promtool check config`.
-   [ ] Prometheus service is enabled and healthy.
-   [ ] Prometheus **Status → Targets** shows the expected targets as
    `UP`.
-   [ ] Grafana can connect to Prometheus and display host metrics.
-   [ ] CPU and disk alert rules are loaded and visible in Prometheus.
-   [ ] Alertmanager is running and receives firing alerts.
-   [ ] PagerDuty and/or ServiceNow integrations have been configured
    and tested, if included in the POC.
-   [ ] Security Groups restrict monitoring ports to approved sources.
-   [ ] No secrets or tokens are committed to the repository.

------------------------------------------------------------------------

## Useful Commands Quick Reference

``` bash
# Check services
sudo systemctl status node_exporter --no-pager
sudo systemctl status prometheus --no-pager

# Start/restart services
sudo systemctl enable --now node_exporter
sudo systemctl enable --now prometheus
sudo systemctl restart prometheus

# Check listening ports
sudo ss -tulnp

# Check endpoints
curl -s http://localhost:9100/metrics | head
curl http://localhost:9090/-/healthy
curl http://localhost:9090/-/ready

# Check logs
sudo journalctl -u node_exporter -n 50 --no-pager
sudo journalctl -u prometheus -n 50 --no-pager

# Validate Prometheus configuration
sudo -u prometheus /usr/local/bin/promtool check config /etc/prometheus/prometheus.yml
```

## References

-   [Prometheus documentation](https://prometheus.io/docs/)
-   [Prometheus downloads and releases](https://prometheus.io/download/)
-   [Node Exporter](https://github.com/prometheus/node_exporter)
-   [Alertmanager
    documentation](https://prometheus.io/docs/alerting/latest/alertmanager/)
-   [Grafana documentation](https://grafana.com/docs/)
-   [AWS EC2 Security
    Groups](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-security-groups.html)

------------------------------------------------------------------------

**Project status note:** Update this README with the actual EC2 instance
roles, private IPs, screenshots, Grafana dashboards, alert test results,
and PagerDuty/ServiceNow integration status before presenting it as a
completed implementation.
