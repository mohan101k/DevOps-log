# 🚀 Task 3: Common Problems When Deploying Multiple Applications

## 🌍 Real-Time Scenario

Suppose your company has **4 applications** running on AWS.

- **Application 1 → E-Commerce**
- **Application 2 → HR Portal**
- **Application 3 → Banking API**
- **Application 4 → Admin Dashboard**

Initially, the company has only **one EC2 server**.

Everything works fine.

As users increase, problems start appearing.

---

# Problem 1 — Port Conflict (Most Common)

## Situation

**App-1** uses:

- Port **8080**

**App-2** also tries to use:

- Port **8080**

### Result

```
Address already in use
```

One application starts.

The other fails.

### ✅ Solution

- Use different ports
- Docker Containers
- Reverse Proxy (Nginx)
- Load Balancer

---

# Problem 2 — Resource Sharing

All applications share:

- CPU
- RAM
- Disk
- Network

Suppose:

**App-1**

- CPU = **95%**

Remaining applications become slow.

Sometimes they crash.

### ✅ Solution

- Auto Scaling
- Docker
- Kubernetes
- Separate EC2
- Monitoring

---

# Problem 3 — One Application Crash

Suppose:

**Application-2** crashes.

Sometimes it consumes:

- **100% RAM**

Entire server hangs.

Now:

- Application-1
- Application-3
- Application-4

also become unavailable.

### ✅ Solution

**Containerization**

Each application runs independently.

---

# Problem 4 — Dependency Conflict

**App-1** needs:

- Java 8

**App-2** needs:

- Java 17

**App-3** needs:

- Python 3.12

Installing everything on one server becomes difficult.

### ✅ Solution

Docker

Every container has its own dependencies.

---

# Problem 5 — Different Operating Systems

**Application-1**

- Ubuntu

**Application-2**

- Amazon Linux

**Application-3**

- CentOS

One EC2 cannot run multiple operating systems.

### ✅ Solution

- Containers
- Separate EC2

---

# Problem 6 — Storage Problem

Users upload:

- Images
- Videos
- PDFs
- Logs

Soon:

```
Disk = 100%
```

Application stops.

### ✅ Solution

- Amazon S3
- EBS
- EFS
- Lifecycle Policies

---

# Problem 7 — Database Bottleneck

Four applications use one database.

Thousands of users login.

Database CPU becomes:

```
100%
```

Application becomes slow.

### ✅ Solution

- Amazon RDS
- Read Replica
- Database Scaling
- Connection Pooling

---

# Problem 8 — Single Point of Failure

Only:

- 1 EC2

If EC2 stops:

- Website Down
- API Down
- Admin Down

### ✅ Solution

- Application Load Balancer
- Auto Scaling
- Multi-AZ Deployment

---

# Problem 9 — High Traffic

Suppose:

IPL Final starts.

Traffic becomes:

```
10x
```

One server cannot handle it.

### ✅ Solution

- Auto Scaling Group
- Load Balancer
- CloudFront

---

# Problem 10 — Deployment Downtime

Developer deploys:

Version 2

Application stops for **5 minutes.**

Users cannot access the website.

### ✅ Solution

- Rolling Deployment
- Blue-Green Deployment
- Canary Deployment

---

# Problem 11 — Security

One application gets hacked.

Attacker reaches the entire server.

### ✅ Solution

- Security Groups
- IAM
- WAF
- Private Subnets
- Least Privilege

---

# Problem 12 — Logs Everywhere

Each application writes logs.

Soon:

```
500 GB Logs
```

Finding errors becomes difficult.

### ✅ Solution

- CloudWatch
- ELK Stack
- Grafana
- Prometheus

---

# Problem 13 — SSL Certificate

Suppose **4 applications**

- app.company.com
- hr.company.com
- bank.company.com
- admin.company.com

Managing certificates manually becomes difficult.

### ✅ Solution

- AWS Certificate Manager (ACM)
- Application Load Balancer

---

# Problem 14 — URL Routing

```
company.com/hr
company.com/admin
company.com/shop
```

How will AWS know where to send requests?

### ✅ Solution

- Path-Based Routing
- Application Load Balancer

---

# Problem 15 — Cost

Every application has:

- 2 EC2

Now:

```
4 Applications
×
2 EC2
=
8 EC2
```

Huge AWS bill.

### ✅ Solution

- Auto Scaling
- Schedule Scaling
- Reserved Instances
- Spot Instances

---

# Problem 16 — Backup

Server crashes.

Everything lost.

### ✅ Solution

- AMI
- Snapshots
- Amazon S3
- AWS Backup

---

# Problem 17 — Monitoring

Server is slow.

Question:

**Which application is causing the problem?**

### ✅ Solution

- CloudWatch
- Prometheus
- Grafana

---

# Problem 18 — Manual Deployment

Developer manually copies code.

Mistakes happen.

### ✅ Solution

- CI/CD Pipeline
- GitHub
- Jenkins
- GitHub Actions

---

# Problem 19 — Configuration Difference

Development:

- Java 17

Production:

- Java 11

Application works in Dev but fails in Production.

### ✅ Solution

- Docker
- Infrastructure as Code
- Terraform
- Ansible

---

# Problem 20 — Disaster Recovery

Mumbai Region goes down.

Everything becomes unavailable.

### ✅ Solution

- Multi-Region Deployment
- Cross-Region Replication
- Route 53 Failover Routing

---

# 🏆 Complete Production Architecture

```text
                    Users
                      │
                 Route 53 (DNS)
                      │
              AWS WAF + Shield
                      │
        Application Load Balancer
                      │
        ┌─────────────┼─────────────┐
        │             │             │
      App-1         App-2         App-3
      Target        Target        Target
      Group         Group         Group
        │             │             │
   Auto Scaling  Auto Scaling  Auto Scaling
      Group         Group         Group
        │             │             │
     Docker       Docker        Docker
    Container    Container     Container
        │             │             │
        └─────────────┼─────────────┘
                      │
                  Amazon RDS
                      │
                  Amazon S3
                      │
              CloudWatch Logs
                      │
            Prometheus + Grafana
```

---

# 🎯 Interview Answer

## Q: What are the common challenges when deploying multiple applications?

### Answer:

- Port conflicts
- Resource contention (CPU/RAM)
- Dependency conflicts
- Application crashes affecting others
- Single point of failure
- High traffic handling
- Deployment downtime
- Security risks
- Storage limitations
- Database bottlenecks
- Monitoring and logging challenges
- SSL certificate management
- URL routing
- Cost optimization
- Backup and disaster recovery

---

## How do we solve them?

- Docker
- Kubernetes
- Application Load Balancer
- Target Groups
- Auto Scaling Group
- Amazon S3
- Amazon RDS
- CloudWatch
- Route 53
- AWS WAF
- CI/CD (Jenkins/GitHub Actions)
- Terraform
- Ansible

---

# 💡 Tip for Interviews

If an interviewer asks:

> **"Why do we use Docker and Kubernetes?"**

A strong answer is:

> **"When multiple applications run on the same infrastructure, we face challenges like dependency conflicts, resource sharing, port conflicts, inconsistent environments, and scaling issues. Docker isolates each application with its own runtime and dependencies, while Kubernetes manages those containers by handling deployment, scaling, self-healing, service discovery, and rolling updates automatically."**
