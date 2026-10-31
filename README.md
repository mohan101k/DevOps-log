# Prometheus + Grafana + Alertmanager on AWS EC2

A single-host monitoring lab for Ubuntu EC2.

## Components
- Prometheus 2.55.1: metrics collection and alert-rule evaluation
- Grafana: dashboards and visualization
- Alertmanager 0.27.0: alert grouping and routing
- Node Exporter 1.8.2: Linux host metrics

Supports Ubuntu EC2 with amd64 or arm64 architecture.

## Install

```bash
sudo apt-get update
sudo apt-get install -y git
git clone https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
cd YOUR_REPOSITORY
chmod +x install-monitoring-stack.sh
sudo bash install-monitoring-stack.sh
```

The installer uses the official Grafana APT repository and keyring. It does not run a full OS upgrade or reboot the instance. It stops each service before replacing its executable to avoid `Text file busy`.

## EC2 Security Group

| Port | Service | Recommended source |
|---|---|---|
| 22 | SSH | Your IP only |
| 3000 | Grafana | Your IP only |
| 9090 | Prometheus | Your IP only or SSH tunnel |
| 9093 | Alertmanager | Your IP only or SSH tunnel |
| 9100 | Node Exporter | Do not expose publicly |

Do not use `0.0.0.0/0` for monitoring ports. For stronger security, access the web interfaces through SSH tunnels.

## URLs

Replace `EC2_PUBLIC_IP` with your instance public IPv4:

- Prometheus: `http://EC2_PUBLIC_IP:9090`
- Grafana: `http://EC2_PUBLIC_IP:3000`
- Alertmanager: `http://EC2_PUBLIC_IP:9093`

Grafana initial login: `admin` / `admin`. Change the password at first login.

## Configure Grafana

1. Sign in to Grafana.
2. Open **Connections → Data sources → Add data source**.
3. Select **Prometheus**.
4. Set URL to `http://localhost:9090`.
5. Click **Save & test**.
6. Open **Dashboards → New → Import**.
7. Enter dashboard ID `1860` (Node Exporter Full).
8. Select the Prometheus data source and import.

## Verify services

```bash
sudo systemctl is-active prometheus
sudo systemctl is-active grafana-server
sudo systemctl is-active alertmanager
sudo systemctl is-active node_exporter
```

Check targets and metrics:

```bash
curl -s http://localhost:9090/api/v1/targets
curl -s http://localhost:9100/metrics | head
```

View logs:

```bash
sudo journalctl -u prometheus -n 80 --no-pager
sudo journalctl -u grafana-server -n 80 --no-pager
sudo journalctl -u alertmanager -n 80 --no-pager
sudo journalctl -u node_exporter -n 80 --no-pager
```

## PagerDuty (optional)

PagerDuty is intentionally not configured by default. A routing key was previously included in a shared script/chat; revoke or rotate that key before configuring notifications. Never commit a routing key to GitHub. Add the newly rotated key securely to `/etc/alertmanager/alertmanager.yml`, restrict file permissions, then restart Alertmanager.

## Notes

- This is a single-EC2 learning setup, not a highly available production architecture.
- Prometheus scrapes Prometheus itself on port 9090 and Node Exporter on port 9100.
- Alertmanager is configured at localhost:9093.
- EC2 service discovery is intentionally omitted. Add it only after attaching an IAM role with least-privilege `ec2:DescribeInstances` permissions and configuring private network access.
- Review existing service/data state before using the installer on a production monitoring host.
