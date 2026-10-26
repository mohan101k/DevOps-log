# Session 45 — Monitoring, Prometheus, Grafana, Node Exporter & PagerDuty

> **Language:** Hinglish (Hindi + English)  
> **Purpose:** Session revision, hands-on reference, troubleshooting, and interview preparation.  
> **Core monitoring stack:** Node Exporter + Prometheus + Grafana  
> **Optional alerting extension:** Prometheus alert rules + Alertmanager + PagerDuty  
> **Infrastructure activity seen:** Terraform `apply` for AWS resources

---

## Table of Contents

1. [Session Overview](#1-session-overview)
2. [Architecture](#2-architecture)
3. [Each Component Explained](#3-each-component-explained)
4. [Monitoring Data Flow](#4-monitoring-data-flow)
5. [AWS EC2 Environment](#5-aws-ec2-environment)
6. [Git Basics Seen in the Terminal](#6-git-basics-seen-in-the-terminal)
7. [What Does `sh node.sh` Do?](#7-what-does-sh-nodesh-do)
8. [Prometheus Configuration](#8-prometheus-configuration)
9. [Prometheus Alert Rules — Optional Section](#9-prometheus-alert-rules--optional-section)
10. [Understanding Alert States](#10-understanding-alert-states)
11. [PagerDuty Integration and Incident](#11-pagerduty-integration-and-incident)
12. [Terraform Activity](#12-terraform-activity)
13. [Ports and Network Access](#13-ports-and-network-access)
14. [Verification Checklist](#14-verification-checklist)
15. [Troubleshooting Guide](#15-troubleshooting-guide)
16. [Security Best Practices](#16-security-best-practices)
17. [Quick Revision Notes](#17-quick-revision-notes)
18. [Interview Questions and Answers](#18-interview-questions-and-answers)
19. [Glossary](#19-glossary)
20. [Session Evidence and Known Details](#20-session-evidence-and-known-details)

---

## 1. Session Overview

Is session mein Linux/EC2 server monitoring ka flow dekha gaya:

- **Node Exporter** server ke system metrics expose karta hai.
- **Prometheus** Node Exporter se metrics scrape karke time-series database mein store karta hai.
- **Grafana** Prometheus ko data source bana kar graphs aur dashboards display karta hai.
- **Prometheus alert rules** optional taur par CPU, disk, aur target availability jaise conditions evaluate kar sakte hain.
- **Alertmanager** Prometheus ke alerts ko group, route, silence aur manage karta hai.
- **PagerDuty** configured integration ke through alert receive karke incident create kar sakta hai.
- **Terraform** AWS infrastructure ko code ke through provision/manage karne ke liye use hua.
- **Git/GitHub** script changes aur Pull Request (PR) workflow ke context mein discuss hua.

### Core vs optional components

| Component | Core monitoring ke liye? | Role |
|---|---:|---|
| Node Exporter | Yes | Host metrics expose karna |
| Prometheus | Yes | Metrics scrape aur store karna |
| Grafana | Yes | Metrics visualize karna |
| Prometheus alert rules | Optional | Conditions par alerts evaluate karna |
| Alertmanager | Optional | Prometheus alerts route/manage karna |
| PagerDuty | Optional | Incident management and notification |

**Important:** Instructor ne ek point par kaha tha ki agar alerting nahi chahiye, toh Alertmanager/PagerDuty install karna zaroori nahi. Baad ke screenshots mein alert rules aur PagerDuty incident bhi dikhaye gaye. Is README mein isliye core monitoring aur optional alerting ko separate rakha hai.

---

## 2. Architecture

### 2.1 Core monitoring architecture

```text
                  Linux / Amazon EC2 server
                            |
                            v
                      Node Exporter
                (CPU, memory, disk metrics)
                            |
                   Prometheus scrapes
                            |
                            v
                       Prometheus
                 (scrape + time-series store)
                            |
                   Prometheus data source
                            |
                            v
                         Grafana
                  (dashboards and graphs)
```

### 2.2 Optional alerting architecture

```text
Node Exporter
     |
     v
Prometheus
     |
     | evaluates alert rules
     v
Alertmanager
     |
     | configured receiver/integration
     v
PagerDuty
     |
     v
Incident / on-call notification
```

**Terminology note:** Prometheus alert rules evaluate the conditions. Alertmanager commonly handles routing and grouping. Grafana also has its own alerting features, but the alert-rule screen in this session was Prometheus's `/etc/prometheus/alert.rules.yml` rule group.

---

## 3. Each Component Explained

### 3.1 Node Exporter

**Kya hai?**  
Node Exporter ek Prometheus exporter hai jo Linux/Unix host ke hardware aur OS-level metrics HTTP endpoint par expose karta hai.

**Examples of metrics:**
- CPU time and utilization (utilization usually derived from CPU time metrics)
- Memory statistics
- Filesystem capacity and availability
- Network statistics
- System load

**Important distinction:** Node Exporter khud Prometheus jaisa metrics database nahi hai. Ye metrics expose karta hai; Prometheus unhe scrape karta hai.

### 3.2 Prometheus

**Kya hai?**  
Prometheus monitoring and alerting toolkit hai jo time-series metrics collect aur store karta hai.

**Key terms:**
- **Scrape:** Configured target ke metrics endpoint se metrics collect karna.
- **Target:** Monitoring ke liye configured endpoint, jaise Node Exporter.
- **Time series:** Timestamp ke saath metric samples ka sequence.
- **Labels:** Metric ke saath attached key-value dimensions, jaise `instance` aur `job`.
- **PromQL:** Prometheus Query Language, metrics query/analysis ke liye.

### 3.3 Grafana

**Kya hai?**  
Grafana metrics ko dashboards, panels, graphs aur tables mein visualize karta hai.

**Workflow:** Grafana mein Prometheus ko data source add karo, phir PromQL queries use karke panels banao.

**Difference:** Prometheus metrics store/query karta hai; Grafana primarily visualization layer hai.

### 3.4 Alertmanager

Prometheus ke alerting system se bheje gaye alerts ko:
- Group kar sakta hai
- Route kar sakta hai
- Duplicate notifications reduce karne ke liye deduplicate kar sakta hai
- Silence ya inhibition rules apply kar sakta hai
- Configured receivers ko forward kar sakta hai

Alertmanager metrics database ya dashboard tool nahi hai.

### 3.5 PagerDuty

PagerDuty incident-management/on-call platform hai. Supported integration configure hone par monitoring alert PagerDuty tak ja sakta hai, incident trigger ho sakta hai aur notification workflow start ho sakta hai.

**Sirf integration list dekhne se setup complete prove nahi hota.** Session ke later screenshot mein PagerDuty incident `HighCPUUsage` triggered dikh raha tha, jo alert delivery ka evidence hai.

### 3.6 Terraform

Terraform Infrastructure as Code (IaC) tool hai. Configuration files se cloud resources provision aur manage karne ke liye use hota hai.

Session screenshot mein `terraform apply` output ke andar security group, route table association aur EC2 instance creation dikh rahe the.

---

## 4. Monitoring Data Flow

1. Linux/EC2 machine par Node Exporter run hota hai.
2. Node Exporter metrics endpoint expose karta hai (commonly port `9100`).
3. Prometheus configuration mein target define hota hai.
4. Prometheus interval ke according target ko scrape karta hai (commonly port `9090` par Prometheus UI/API).
5. Metrics Prometheus ke time-series storage mein save hote hain.
6. Grafana mein Prometheus data source configure hota hai.
7. Grafana panels PromQL queries se metrics display karte hain.
8. **Optional:** Prometheus alert rule condition true hone par alert pending/firing state mein ja sakta hai.
9. **Optional:** Alertmanager alert ko configured receiver, jaise PagerDuty integration, tak route karta hai.

---

## 5. AWS EC2 Environment

Screenshot mein AWS console ke context mein ye details visible thi:

| Item | Screenshot se visible detail |
|---|---|
| EC2 instance name | `GRAFANA-PROMETHEUS` |
| AWS region | `US East (N. Virginia)` |
| Public IP shown | `3.81.60.210` |
| Instance ID shown in a separate Terraform terminal screenshot | `i-047f0872c954834bd1` |

**Caution:** Ye details alag screenshots/activities se li gayi hain. Inhe same instance maana nahi jaana chahiye jab tak AWS console se verify na ho. Public IP dynamic ho sakta hai aur future mein change ho sakta hai. Public IP ko permanently README mein rakhne ke bajaye apne live environment se check karna better hai.

AWS console screenshot mein browser URL `3.81.60.210:9090/alerts?search=` dikh raha tha, jo Prometheus alerts page ko indicate karta hai.

### 5.1 Prometheus UI open karna

Agar port `9090` ka access allowed hai aur Prometheus us interface par listen kar raha hai, toh browser mein:

```text
http://<EC2-PUBLIC-IP>:9090
```

Alerts page:

```text
http://<EC2-PUBLIC-IP>:9090/alerts
```

**Security note:** Public internet par Prometheus/Grafana ko unrestricted expose mat karo. IP-restricted inbound rules, VPN, bastion, reverse proxy with authentication, ya private access prefer karo.

---

## 6. Git Basics Seen in the Terminal

Screenshot mein Git help output ke kuch common commands visible the.

| Command | Meaning |
|---|---|
| `git status` | Working tree aur staging status dikhata hai |
| `git branch` | Branches list/create/delete kar sakta hai |
| `git commit` | Staged changes ko local repository history mein record karta hai |
| `git merge` | Do development histories ko integrate karta hai |
| `git rebase` | Commits ko doosre base commit ke upar replay karta hai |
| `git reset` | HEAD/index ko specified state par move/reset karta hai; use carefully |
| `git switch` | Branch switch/create karne ke liye |
| `git tag` | Release/version tags create/list/delete/verify karta hai |
| `git fetch` | Remote repository se objects/refs download karta hai, current branch ko automatically merge nahi karta |
| `git pull` | Fetch ke baad current branch mein integrate karta hai |
| `git push` | Local commits/refs ko remote repository par publish karta hai |

### 6.1 `sh node.sh` ka meaning

```bash
sh node.sh
```

- `sh` shell interpreter ko invoke karta hai.
- `node.sh` script file ka naam hai.
- Command script ke andar likhe shell commands execute karne ki koshish karta hai.

**Important:** File name se exact function confirm nahi hota. `node.sh` Node Exporter setup script ho sakti hai, lekin exact work jaanne ke liye contents inspect karna zaroori hai:

```bash
cat node.sh
```

Long file ke liye:

```bash
less node.sh
```

Script run karne se pehle review karo. Unknown script ko root privileges ke saath blindly execute mat karo. `sh node.sh` aur `./node.sh` mein execution method alag ho sakta hai; `./node.sh` ke liye executable permission aur valid shebang commonly required hote hain.

---

## 7. What Does `sh node.sh` Do?

Session mein user ne specifically poochha tha: "`sh node.sh` kya karta hai?"

Example:

```bash
sh node.sh
```

Agar script Node Exporter install/setup karne ke liye likhi gayi hai, toh usmein download, extraction, user/service creation ya service start karne ke commands ho sakte hain. **Ye possibilities hain, screenshot se confirmed actions nahi.**

Script inspect karne ke commands:

```bash
pwd
ls -l node.sh
cat node.sh
```

Agar file current directory mein nahi hai, toh correct directory mein jao ya actual path provide karo.

---

## 8. Prometheus Configuration

Prometheus ko targets aur rule files ke baare mein configuration chahiye hoti hai. Session screenshots mein `rules.yml` aur Prometheus page par `/etc/prometheus/alert.rules.yml` ka reference dikh raha tha.

### 8.1 `prometheus.yml`

Usually is file mein scrape configuration aur optional rule files ka path hota hai. Exact config screenshot mein visible nahi thi, isliye neeche sirf **illustrative example** hai, session ka exact original config nahi.

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]

  - job_name: "node_exporter"
    static_configs:
      - targets: ["localhost:9100"]
```

**Note:** Agar Prometheus aur Node Exporter separate EC2 instances par hain, toh `localhost` ki jagah Node Exporter host ka reachable private IP/DNS use karna hoga. Actual setup ke network design ke mutabik values change karo.

### 8.2 Rule file include karna

Prometheus main configuration mein rule file include karne ka illustrative example:

```yaml
rule_files:
  - "/etc/prometheus/alert.rules.yml"
```

Rule file tabhi load hogi jab:
1. Main configuration mein correct path referenced ho.
2. File valid YAML aur valid Prometheus rule syntax mein ho.
3. Prometheus configuration reload/restart successful ho.

---

## 9. Prometheus Alert Rules — Optional Section

**This section is optional.** Core monitoring ke liye alerts configure karna compulsory nahi hai. Lekin session screenshots mein alert rules aur PagerDuty incident dikhaye gaye, isliye revision ke liye yahan explain kiya hai.

Screenshot mein rule group `system-alerts` aur ye rule names visible the:

- `InstanceDown`
- `HighCPUUsage`
- `HighDiskUsage`

### 9.1 `InstanceDown`

Purpose: Target unavailable/unreachable hone par alert condition detect karna.

Typical Prometheus expression:

```promql
up == 0
```

Ye sirf illustrative expression hai. Exact rule screenshot mein fully readable nahi tha. Alert ko fire hone se pehle `for` duration configure ki ja sakti hai.

### 9.2 `HighCPUUsage`

Screenshot mein visible expression:

```promql
100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 40
```

Aur:

```yaml
for: 2m
```

**Step-by-step meaning:**

- `node_cpu_seconds_total` — Node Exporter ka cumulative CPU-time metric.
- `{mode="idle"}` — idle CPU time select karta hai.
- `[5m]` — five-minute range window.
- `irate(...[5m])` — range ke latest samples se per-second rate estimate karta hai; CPU utilization ke liye `rate` bhi commonly use hota hai.
- `avg by(instance)(...)` — har instance ke liye CPU time rates average karta hai.
- `100 - idle percentage` — approximate CPU busy percentage calculate karta hai.
- `> 40` — threshold 40% hai.
- `for: 2m` — condition 2 minutes tak continuously true rahe toh alert firing state mein ja sakta hai.

**Screenshot discrepancy:** Rule expression `> 40` dikhata hai, lekin annotation description mein `CPU usage > 20%` likha tha. Description aur expression inconsistent hain. Real config mein dono ko same threshold ke saath update karo.

Illustrative, consistent rule:

```yaml
- alert: HighCPUUsage
  expr: 100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 40
  for: 2m
  labels:
    severity: critical
  annotations:
    summary: "High CPU usage detected on {{ $labels.instance }}"
    description: "CPU usage is above 40% for more than 2 minutes. VALUE = {{ $value }}%"
```

Ye clean example hai; ise apply karne se pehle apne metric labels, CPU model, alert policy aur Prometheus version ke hisaab se validate karo.

### 9.3 `HighDiskUsage`

Screenshot mein visible expression ka structure:

```promql
(1 - (node_filesystem_avail_bytes{fstype!~"tmpfs|overlay"}
      / node_filesystem_size_bytes{fstype!~"tmpfs|overlay"})) * 100 > 80
```

Meaning:
- `node_filesystem_avail_bytes` available filesystem bytes batata hai.
- `node_filesystem_size_bytes` total filesystem size batata hai.
- Available/total ratio nikal kar `1 - ratio` karne se used fraction milta hai.
- `* 100` percentage banata hai.
- `> 80` ka matlab filesystem usage 80% se zyada hai.

**Caution:** Production rule mein `fstype` filter ke alawa mount point/device filters bhi useful hote hain, taaki irrelevant/duplicate filesystems se false alerts na aayein.

### 9.4 Rule labels and annotations

- `labels`: Alert ki classification/metadata, jaise `severity: critical`.
- `annotations`: Human-readable details, jaise `summary` aur `description`.
- `{{ $labels.instance }}`: Alert label value template mein insert karta hai.
- `{{ $value }}`: Expression ka evaluated numeric value insert karta hai.

---

## 10. Understanding Alert States

Prometheus Alerts page screenshot mein counters ye the:

- `Inactive (3)`
- `Pending (0)`
- `Firing (0)`

Aur rule group path:

```text
/etc/prometheus/alert.rules.yml > system-alerts
```

### State meanings

| State | Hinglish explanation |
|---|---|
| Inactive | Abhi rule ki condition true nahi hai |
| Pending | Condition true hui hai, lekin configured `for` duration abhi complete nahi hui |
| Firing | Condition configured duration tak true rahi aur alert fire ho gaya |

Screenshot mein teeno rules inactive the aur koi pending/firing alert nahi tha. Iska matlab rules page par loaded/display ho rahe the, lekin us waqt unki conditions firing tak nahi pahunchi thi. Inactive state apne aap mein configuration error nahi hoti.

Later PagerDuty screenshot mein `HighCPUUsage` incident triggered dikh raha tha. Ye different time/state ka evidence ho sakta hai; monitoring state time ke saath change hoti hai.

---

## 11. PagerDuty Integration and Incident

### 11.1 Integration page

PagerDuty integration page par available options visible the:
- Events API V2
- Prometheus
- Amazon CloudWatch
- Splunk
- Nagios
- Zabbix
- Datadog
- SolarWinds Orion
- New Relic
- Microsoft SCOM Email
- Microsoft Azure
- AlertSite UXM
- Pingdom
- SignalFx
- Email

Screenshot mein integrations choose karne ki list dikh rahi thi. Sirf list dikhne se kisi integration ka active/configured hona prove nahi hota.

### 11.2 Alert-to-incident flow

```text
Prometheus alert rule
        |
        v
Prometheus alert becomes firing
        |
        v
Alertmanager / configured integration path
        |
        v
PagerDuty receives event
        |
        v
PagerDuty incident is created
```

### 11.3 PagerDuty incident screenshot

Later screenshot mein ye details visible thi:

| Field | Observed value |
|---|---|
| Incident status | Triggered |
| Alert title | `[FIRING:1] (HighCPUUsage node_server critical)` |
| Urgency | High |
| Acknowledged | 0 acknowledged |
| Service | `abnormality` |
| Assigned to | `veera narni` |

**Interpretation:** PagerDuty UI mein `HighCPUUsage` se related triggered incident visible tha. Screenshot incident creation ka evidence deta hai; notification delivery channel (email/SMS/mobile push) separately verify karna padega.

### 11.4 Alerting vs monitoring

- Monitoring = metrics collect, store, query aur visualize karna.
- Alerting = configured condition ke true hone par event/notification workflow start karna.
- Incident management = PagerDuty jaise tool mein alert ko track, assign, acknowledge aur resolve karna.

Agar alerting scope mein nahi hai, toh PagerDuty integration ko optional hi rakho.

---

## 12. Terraform Activity

Screenshot mein terminal prompt ke andar project path tha:

```text
/terraform-practice/terraform0900am/Day-6-custom-nw
```

Command run ki gayi:

```bash
terraform apply
```

Visible output se:
- Security group creation completed.
- Route table association creation completed.
- EC2 instance creation completed.
- Instance ID: `i-047f0872c954834bd1`.

### Terraform commands — revision

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform destroy
```

| Command | Purpose |
|---|---|
| `terraform init` | Working directory initialize aur providers/modules download |
| `terraform fmt` | Terraform files ko standard format mein format karna |
| `terraform validate` | Configuration syntax/internal consistency validate karna |
| `terraform plan` | Proposed infrastructure changes preview karna |
| `terraform apply` | Plan confirm karne ke baad changes apply/provision karna |
| `terraform destroy` | Managed resources destroy karne ka plan/apply karna |

**Safety:** `terraform apply` aur `terraform destroy` real cloud resources/costs affect kar sakte hain. Apply se pehle plan review karo. Destroy command sirf tab run karo jab resources delete karne ka intent aur permission ho.

---

## 13. Ports and Network Access

Common default ports (deployment configuration se change ho sakte hain):

| Component | Common port | Purpose |
|---|---:|---|
| Prometheus | `9090` | Prometheus UI/API |
| Node Exporter | `9100` | Host metrics endpoint |
| Grafana | `3000` | Grafana web UI |
| Alertmanager | `9093` | Alertmanager UI/API |
| HTTP | `80` | Web traffic |
| HTTPS | `443` | Encrypted web traffic |
| SSH | `22` | Linux remote administration |

### AWS Security Group reminders

- Prometheus ko Node Exporter ke port `9100` tak network access chahiye.
- Grafana ko Prometheus endpoint tak access chahiye.
- Alertmanager ko Prometheus se alerts receive karne aur configured receiver tak send karne ki connectivity chahiye.
- SSH port `22` ko ideally apne trusted IP/CIDR tak restrict karo.
- `9090`, `3000`, `9100` ko `0.0.0.0/0` par public expose karna avoid karo.

**Important:** Ye common defaults hain, screenshot-confirmed security-group rules nahi.

---

## 14. Verification Checklist

Environment ke according commands run karo. Ye general verification checklist hai; har command ka output screenshot mein nahi dikhaya gaya tha.

### 14.1 Services

```bash
sudo systemctl status prometheus
sudo systemctl status grafana-server
sudo systemctl status node_exporter
sudo systemctl status alertmanager
```

Service names installation method ke according differ kar sakte hain. Optional components install nahi kiye hon toh unki service missing hona expected hai.

### 14.2 Listening ports

```bash
sudo ss -tuln
```

Isse listening TCP/UDP sockets inspect kar sakte ho. Expected ports actual configuration par depend karte hain.

### 14.3 Node Exporter endpoint

```bash
curl http://localhost:9100/metrics
```

Agar Node Exporter same machine par nahi hai, toh `localhost` ke bajaye correct host use karo.

### 14.4 Prometheus targets

Browser mein:

```text
http://<PROMETHEUS-HOST>:9090/targets
```

Target ke `UP` hone ka matlab scrape successful hai. `DOWN` hone par endpoint, routing, security group, service status aur logs check karo.

### 14.5 Prometheus alerts

```text
http://<PROMETHEUS-HOST>:9090/alerts
```

Rule states, labels, expression aur alert details check karo.

### 14.6 Grafana

```text
http://<GRAFANA-HOST>:3000
```

Prometheus data source configured hai ya nahi, uska connection test karo aur dashboard panels mein data verify karo.

---

## 15. Troubleshooting Guide

| Symptom | Possible cause | What to check |
|---|---|---|
| Prometheus target `DOWN` | Exporter stopped, wrong address/port, SG/firewall block | Service, endpoint, network rules, `/targets` |
| Grafana panel has no data | Wrong data source, query, labels, target down | Data source connection, PromQL, Prometheus targets |
| Prometheus rule absent | Wrong rule path, invalid YAML, config not reloaded | Main config, rule file, service logs |
| Alert remains inactive | Condition currently false | PromQL query, metric availability, threshold |
| Alert remains pending | `for` duration not yet met, condition resets | Expression result over time, `for` setting |
| PagerDuty incident not created | Integration/receiver/configuration issue | Prometheus firing state, Alertmanager status/logs, PagerDuty integration key and event delivery |
| SSH connection fails | Wrong key/user/IP or security group | EC2 state, SSH username/key, inbound rule |
| Terraform fails | Invalid configuration, provider/permissions/quota issue | `terraform validate`, `terraform plan`, error output and IAM permissions |

### Session-specific consistency issue

`HighCPUUsage` expression mein threshold `> 40` tha, jabki description mein `> 20%` likha tha. Production ya practice config mein threshold aur description ko match karna chahiye.

---

## 16. Security Best Practices

1. Monitoring UIs ko public internet par unrestricted expose mat karo.
2. SSH inbound source ko trusted IP/CIDR tak restrict karo.
3. AWS IAM least-privilege principle follow karo.
4. PagerDuty integration keys/tokens ko GitHub par commit mat karo.
5. `prometheus.yml`, alert rules aur service config mein credentials hardcode mat karo.
6. GitHub PR mein friend/owner ke repository ko target karne se pehle base aur head repository carefully verify karo.
7. Terraform apply/destroy se pehle plan aur target account/region verify karo.
8. Public IPs, account IDs, secrets aur personal incident details ko public README se redact karo.
9. Shell scripts run karne se pehle inspect karo, especially root permissions ke saath.

---

## 17. Quick Revision Notes

- **Node Exporter = Metrics expose**
- **Prometheus = Scrape + Store + Query + Alert rule evaluation**
- **Grafana = Visualize**
- **Alertmanager = Route/group/manage Prometheus alerts**
- **PagerDuty = Incident/on-call workflow**
- **Terraform = Infrastructure as Code**
- **Git fetch = Download remote refs/objects**
- **Git pull = Fetch + integrate**
- **Git push = Publish local commits**
- **`sh node.sh` = Shell se script run; exact behavior file ke content par depend**
- **Prometheus `Inactive` = Condition currently firing nahi hai**
- **Prometheus `Pending` = Condition true, `for` duration complete nahi hui**
- **Prometheus `Firing` = Condition configured duration tak true rahi**
- **PagerDuty Triggered = Incident create/trigger hua; acknowledgement/resolution separate steps hain**
- **PR create karna = Proposed change; merge hone par hi target repo branch mein changes integrate hote hain**

---

## 18. Interview Questions and Answers

### Q1. Node Exporter kya karta hai?
Node Exporter Linux host metrics expose karta hai. Prometheus in metrics ko scrape karta hai.

### Q2. Prometheus aur Grafana mein difference?
Prometheus metrics collect/store/query karta hai. Grafana data ko dashboards aur graphs mein visualize karta hai.

### Q3. Prometheus scrape kya hota hai?
Prometheus configured target ke metrics HTTP endpoint ko periodically request karke samples collect karta hai.

### Q4. Prometheus target `UP` aur `DOWN` ka kya meaning hai?
`UP` generally successful scrape show karta hai; `DOWN` scrape fail hua. Detailed reason target error se pata chalta hai.

### Q5. Alert rule mein `for: 2m` ka meaning?
Condition 2 minutes tak continuously true rehni chahiye before alert firing. Evaluation interval aur rule behavior bhi matter karte hain.

### Q6. Inactive alert ka matlab configuration wrong hai?
Nahi. Inactive ka matlab current evaluation mein condition true nahi hai. Syntax/configuration errors ko separately validate karna chahiye.

### Q7. Alertmanager aur PagerDuty mein difference?
Alertmanager Prometheus alerts ko group/route/manage karta hai. PagerDuty incident-management aur on-call notification workflows provide karta hai.

### Q8. Grafana alerting aur Prometheus alerting same hain?
Nahi. Dono alerting support kar sakte hain, lekin configuration, evaluation path aur notification workflow alag ho sakte hain.

### Q9. Terraform `apply` kya karta hai?
Terraform plan ko execute karke configured infrastructure create/update/delete karta hai, approval workflow aur flags ke according.

### Q10. `git fetch` aur `git pull` mein difference?
`fetch` remote data download karta hai without automatically integrating into current branch. `pull` fetch ke baad configured strategy se integrate karta hai.

### Q11. Pull Request create karne se owner repository turant change hoti hai?
Nahi. PR proposed changes review ke liye deta hai. Target branch change tab hoti hai jab PR merge hota hai.

### Q12. Monitoring stack ke common ports?
Prometheus `9090`, Node Exporter `9100`, Grafana `3000`, Alertmanager `9093` — assuming defaults.

### Q13. High CPU expression mein `100 - idle percentage` kyun?
CPU time ka idle portion estimate karke 100 se subtract karne par approximate non-idle CPU percentage milta hai.

### Q14. PagerDuty mein `Triggered` incident ka matlab?
PagerDuty ne incident trigger/create kiya. Acknowledgement aur resolution alag incident states/actions hain.

---

## 19. Glossary

| Term | Simple meaning |
|---|---|
| Monitoring | System health/performance observe karna |
| Metric | Numeric measurement, jaise CPU time |
| Exporter | System/application metrics expose karne wala component |
| Scrape | Metrics endpoint se samples collect karna |
| Target | Configured scrape endpoint |
| Time series | Timestamped metric values |
| Label | Metric/alert ko categorize karne wali key-value metadata |
| PromQL | Prometheus query language |
| Dashboard | Metrics ka visual overview |
| Alert rule | Condition-based alert definition |
| Threshold | Trigger karne ke liye configured limit |
| Inactive | Alert condition currently active nahi |
| Pending | Alert condition true hai, waiting period chal rahi hai |
| Firing | Alert condition required duration tak true rahi |
| Receiver | Alert bhejne ka destination |
| Integration | Do tools ke beech configured connection/workflow |
| Incident | Issue/event ko manage karne ka record |
| IaC | Infrastructure as Code |
| EC2 | AWS virtual server service |
| Security Group | AWS resource-level virtual firewall |
| PR | Pull Request — proposed repository changes for review |
| Base repository | PR ka target repository |
| Head repository | PR changes ka source repository |
| Merge | Branch changes integrate karna |

---

## 20. Session Evidence and Known Details

Ye details provided screenshots/notes se captured hain:

- AWS EC2 instance name screenshot: `GRAFANA-PROMETHEUS`
- Region screenshot: `US East (N. Virginia)`
- Public IP shown in screenshots: `3.81.60.210`
- Prometheus alerts URL path: `/alerts?search=`
- Rule group path shown: `/etc/prometheus/alert.rules.yml > system-alerts`
- Rule names: `InstanceDown`, `HighCPUUsage`, `HighDiskUsage`
- CPU expression threshold: `> 40`; duration: `2m`
- CPU description text screenshot: `CPU usage > 20% for more than 2 minutes` — expression se inconsistent
- Disk expression threshold: `> 80`
- Terraform command shown: `terraform apply`
- Terraform-created instance ID shown in terminal: `i-047f0872c954834bd1`
- PagerDuty incident title: `[FIRING:1] (HighCPUUsage node_server critical)`
- PagerDuty service shown: `abnormality`
- PagerDuty assignee shown: `veera narni`
- Script command discussed: `sh node.sh`
- GitHub PR title shown: `Update grafna-promethous.sh`

**Accuracy note:** Screenshots mein kuch commands/configurations partially cropped the. Jahan exact contents confirm nahi hue, wahan README illustrative examples ko original session config se clearly separate karta hai.

---

## Final Revision Summary

Is session ka main learning flow hai:

1. AWS EC2 par monitoring environment ko samajhna.
2. Node Exporter se Linux metrics expose karna.
3. Prometheus se metrics scrape/store karna.
4. Grafana se metrics visualize karna.
5. Optional Prometheus rules se CPU/disk/instance conditions detect karna.
6. Optional Alertmanager/PagerDuty integration se incident workflow samajhna.
7. Terraform aur Git ke related workflows revise karna.
8. Targets, alert states, configuration consistency, connectivity aur security ko verify karna.

**Revision tip:** Pehle core monitoring architecture bina dekhe draw karo. Phir `node_exporter` → Prometheus scrape target → Grafana data source → optional alert rule → Alertmanager → PagerDuty ka flow explain karne ki practice karo.
