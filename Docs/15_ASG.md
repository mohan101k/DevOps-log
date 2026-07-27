# Day 14 — Auto Scaling Group (ASG)
**Date:** May 2, 2026
**Course:** DevOps Bootcamp

---

## 📚 Concepts Covered
- Why manual server scaling fails
- Dynamic vs schedule-based scaling
- Vertical scaling vs horizontal scaling
- Auto Scaling Group (ASG) overview
- AMI (Amazon Machine Image) — what it is, what it captures
- Launch Template (LT) — what it is, what it adds beyond AMI
- The 4 ASG challenges and how to solve each
- Stress testing to trigger ASG scale-out



---

## 🧠 Theory Notes

### Why We Need Auto Scaling

You can't predict traffic. Expected 1,000 requests — what if 100,000 hit at once? Server crashes. Managing this manually (someone monitoring 24/7 and spinning up servers on demand) is not sustainable.

The solution: **dynamic scaling** — servers automatically scale up when load increases, scale down when load drops.

---

### Types of Scaling

| Type | How it works | Recommended? |
|---|---|---|
| **Vertical Scaling** | Increase the capacity of the *same* server (e.g., t2.micro → t2.large) | ❌ Not for 24/7 apps |
| **Horizontal Scaling** | Add or remove *additional* servers | ✅ Highly recommended |
| **Schedule-Based (Static ASG)** | Scale based on time (e.g., 10 AM–6 PM → 20 servers), regardless of actual load | Situational |
| **Dynamic ASG** | Scale based on actual server load | ✅ Standard approach |

**Why vertical scaling is not recommended for 24/7 apps:**
To change an instance type (e.g., t2.micro → t2.large), you must **stop the instance first**. That means downtime. For 24/7 applications, downtime is not acceptable.

**AWS Auto Scaling follows horizontal scaling** — it adds or removes servers automatically based on load.

---

### Auto Scaling Group (ASG)

ASG is an AWS service that automatically adds or removes EC2 instances based on defined policies.

**How it works:**
- Define a **setpoint** (e.g., if average CPU > 70%)
- Define **min** and **max** instance counts (e.g., min: 2, max: 10)
- If load exceeds the threshold → ASG adds servers (up to max)
- If load drops below threshold → ASG removes servers (down to min)
- ASG is **independent** from the Load Balancer — they work together but are separate services:
  - LB routes traffic → it doesn't create servers
  - ASG creates/removes servers → it doesn't route traffic

---

### The 4 ASG Challenges

When ASG creates a new server, it must meet 4 requirements:

| # | Challenge | Solution |
|---|---|---|
| 1 | Server must have the **same application** | Create an **AMI** from the existing app server |
| 2 | Server must have the **same configurations** (instance type, key, SG, etc.) | Create a **Launch Template (LT)** |
| 3 | Server must be in the **same AZs where the LB is configured** | Specify subnets in ASG config (not in LT) |
| 4 | Server must be registered in the **same Target Group the LB uses** | Configure TG attachment in ASG settings |

---

### Challenge 1 — Same Application: AMI

**AMI (Amazon Machine Image)** = a complete snapshot/backup of a running server.

**What AMI captures (server internals):**
- OS
- Application
- Disk contents

**What AMI does NOT capture (external config):**
- VPC
- Subnet
- Security Group
- Key pair

When ASG launches a new instance from your custom AMI, the new server has the same OS + application already installed. You still need to provide the external config separately.

> Key distinction: Use **your custom AMI** (created from your app server), NOT the default AWS AMIs (which only have a bare OS, no app).

---

### Challenge 2 — Same Configurations: Launch Template

**Launch Template (LT)** = a blueprint for launching EC2 instances. Contains everything needed to create a server.

**What LT contains:**
- Custom AMI (your app AMI → covers OS + app)
- Instance type (e.g., t2.micro)
- Key pair
- Security Group
- Tags
- *(Subnet is listed but intentionally ignored by ASG — see below)*

**Why LT ignores the subnet:**
If ASG always used the subnet defined in the LT, it would only ever launch in one AZ. ASG needs to spread servers across multiple AZs — so the subnet is configured directly in the ASG, not in the LT.

**Relationship between AMI and LT:**

| Component | Responsible For |
|---|---|
| AMI | OS + Application |
| Launch Template | All configurations (key, SG, instance type, custom AMI, etc.) |

LT contains AMI. Give LT to ASG → ASG can create correctly configured servers with the right application.

---

### Challenge 3 — Same AZs: Subnet Config in ASG

During ASG setup, you manually select the **private subnets** across your AZs (e.g., private-subnet-1a + private-subnet-1b).

ASG uses **balanced best effort** — if it needs to create 2 servers, it will put one in 1a and one in 1b automatically.

> Important: The LB must also be configured across the same AZs. If the LB runs in 1a + 1b, your ASG servers must also land in 1a + 1b — otherwise the LB can't route traffic to them (AZ mismatch = unused/unhealthy targets).

---

### Challenge 4 — Same Target Group

During ASG setup, you attach it to an **existing Load Balancer / Target Group**. When ASG creates a new server, it automatically registers it into that TG, so the LB starts routing traffic to it immediately.

---

### Full Architecture Flow

```
Users
  ↓
Load Balancer (public subnets: 1a, 1b)
  ↓
Target Group
  ↓
EC2 App Servers (private subnets: 1a, 1b)  ← created & managed by ASG
  ↑
Auto Scaling Group
  - uses Launch Template (custom AMI + config)
  - monitors CPU load
  - adds servers when load > setpoint
  - removes servers when load < threshold
```

---

### Launch Template Versioning

You can create multiple versions of a Launch Template. For example:
- v1: t2.small + AZ hardcoded (bad)
- v2: t2.medium + AZ removed (correct)

When configuring ASG, you specify which LT version to use. ASG picks up all config from that version.

---

### Desired, Min, Max

When creating an ASG, you set three capacity values:

| Setting | Meaning |
|---|---|
| **Desired** | How many instances to create immediately on ASG creation |
| **Min** | Never go below this count, even at zero load |
| **Max** | Never exceed this count, even at max load |

Example: Desired=1, Min=1, Max=2 → starts with 1 server, can scale up to 2.

---

### Scaling Policy: Target Tracking

The most common policy. You define a target metric and ASG tries to maintain it.

Example: "Keep average CPU utilization at 70%"
- Load spikes above 70% → ASG adds servers
- Load drops well below 70% → ASG removes servers (down to min)

---

## 💻 Commands & Code

```bash
# Install stress testing tool (Amazon Linux / RHEL-based)
sudo dnf install -y stress

# Run stress test to artificially spike CPU (for testing ASG scale-out)
# NOT for use in interviews or production — testing only
stress --cpu 4
```

> `stress` is only for verifying that ASG triggers correctly in a lab environment. Real-world scaling is triggered by actual user traffic.

---

## 🏗️ Architecture / Diagrams

```
VPC
├── Public Subnet 1a          Public Subnet 1b
│   └── Bastion Host          └── (no app servers here)
│   └── ALB node              └── ALB node
│
├── Private Subnet 1a         Private Subnet 1b
│   └── EC2 (App)             └── EC2 (App)
│       ← ASG managed →           ← ASG managed →
│
└── Auto Scaling Group
    ├── Launch Template (AMI + instance type + key + SG)
    ├── Subnets: private-1a, private-1b
    ├── Target Group: existing TG attached to ALB
    └── Scaling Policy: CPU > setpoint → add server
```

---

## 🔗 GitHub
Commit to `devops-log`:
```
docs: add day 14 notes - auto scaling group, AMI, launch template
```

---

## ⏭️ Next Steps
- Monday: End-to-end project — full private network setup with LB + ASG
- After that: Network Load Balancer and advanced LB options
- Practice: Try creating your own AMI from an NGINX server, build a Launch Template, configure ASG, verify scale-out with stress command
