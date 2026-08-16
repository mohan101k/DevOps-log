
# Day 21 — Blue-Green Deployment with AWS ALB

> Hands-on DevOps Lab: Blue-Green Deployment using EC2, Target Groups and Application Load Balancer (ALB)

## 📚 Concepts Covered

- Blue-Green Deployment
- Blue and Green environments
- EC2 deployment
- Nginx
- Application Load Balancer (ALB)
- Target Groups
- Health Checks
- ALB Listeners
- Production traffic switching
- Testing Green before production
- Rollback
- ALB vs Blue-Green Deployment
- Deployment best practices

## 🏢 Company Scenario

The development team has a current production application, **Version 1**, and a new release, **Version 2**.

The requirement is to deploy Version 2 without taking Version 1 offline, test the new version first, and quickly roll back if something goes wrong.

Instead of:

```text
Stop Version 1
      ↓
Deploy Version 2
      ↓
Start Version 2
```

we use Blue-Green Deployment.

## 🎯 Objective

Create two independent environments:

```text
🔵 BLUE
Version 1
Current Production
```

```text
🟢 GREEN
Version 2
New Release / Testing
```

Use an ALB to switch production traffic between them.

## 🧠 What is Blue-Green Deployment?

Blue-Green Deployment maintains two environments:

- **Blue** — current production version
- **Green** — new version being prepared and tested

After Green is verified, production traffic is switched from Blue to Green.

If Green has a problem, traffic can quickly be switched back to Blue.

## 🔵 Blue Environment

```text
Instance: blue-server-v1
Application: Version 1
```

Example response:

```text
BLUE - VERSION 1
Old Production Application
This is the Blue environment.
```

## 🟢 Green Environment

```text
Instance: green-server-v2
Application: Version 2
```

Example response:

```text
GREEN - VERSION 2
New Production Application
This is the Green environment.
```

# 🏗️ Architecture

### Initial Production

```text
                         USER
                           │
                           ▼
                         ALB
                           │
                       HTTP :80
                           │
                           ▼
                 🔵 Blue Target Group
                           │
                           ▼
                    🔵 Blue EC2
                    Version 1
```

Green is running separately:

```text
                 🟢 Green Target Group
                           │
                           ▼
                    🟢 Green EC2
                    Version 2
```

### Green Testing

A temporary listener on port `8080` can be used:

```text
                         ALB
                      ┌────┴────┐
                      │         │
                   :80         :8080
                      │         │
                      ▼         ▼
                    BLUE      GREEN
                    V1          V2
                 Production   Testing
```

Test:

```text
http://ALB-DNS:8080
```

### Final Production State

```text
                         USER
                           │
                           ▼
                         ALB
                           │
                       HTTP :80
                           │
                           ▼
                 🟢 Green Target Group
                           │
                           ▼
                    🟢 Green EC2
                    Version 2
```

# ⚙️ Prerequisites

- AWS account / sandbox
- EC2 access
- Amazon Linux 2023
- Application Load Balancer
- Security Groups
- Two EC2 instances
- Nginx
- Basic Linux commands
- Basic AWS VPC knowledge

# 🚀 Lab Implementation

## Step 1 — Create Blue EC2

Go to:

```text
AWS Console
→ EC2
→ Instances
→ Launch Instance
```

Create:

```text
Name: blue-server-v1
AMI: Amazon Linux 2023
```

Allow:

```text
HTTP : 80
SSH  : 22
```

Launch the instance.

Wait for:

```text
Instance State: Running
Status Checks: 2/2 passed
```

## Step 2 — Deploy Version 1 on Blue

Connect using:

```text
EC2
→ Connect
→ EC2 Instance Connect
```

Update packages:

```bash
sudo dnf update -y
```

Install Nginx:

```bash
sudo dnf install nginx -y
```

Start and enable Nginx:

```bash
sudo systemctl start nginx
sudo systemctl enable nginx
```

Check:

```bash
sudo systemctl status nginx
```

Create Version 1:

```bash
sudo nano /usr/share/nginx/html/index.html
```

Use:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Blue Environment</title>
</head>
<body>
    <h1>BLUE - VERSION 1</h1>
    <h2>Old Production Application</h2>
    <p>This is the Blue environment.</p>
</body>
</html>
```

Test:

```bash
curl http://localhost
```

Also test:

```text
http://BLUE-PUBLIC-IP
```

## Step 3 — Create Green EC2

Create another EC2 instance:

```text
Name: green-server-v2
AMI: Amazon Linux 2023
```

Use the same basic configuration.

If possible, place Blue and Green in different Availability Zones.

Example:

```text
Blue  → us-east-1a
Green → us-east-1b
```

Allow:

```text
HTTP :80
```

Wait for:

```text
Running
2/2 Status Checks Passed
```

## Step 4 — Deploy Version 2 on Green

Connect to `green-server-v2`.

Install Nginx:

```bash
sudo dnf update -y
sudo dnf install nginx -y
```

Start and enable:

```bash
sudo systemctl start nginx
sudo systemctl enable nginx
```

Check:

```bash
sudo systemctl status nginx
```

Create Version 2:

```bash
sudo nano /usr/share/nginx/html/index.html
```

Use:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Green Environment</title>
</head>
<body>
    <h1>GREEN - VERSION 2</h1>
    <h2>New Production Application</h2>
    <p>This is the Green environment.</p>
</body>
</html>
```

Test:

```bash
curl http://localhost
```

Also test:

```text
http://GREEN-PUBLIC-IP
```

## Step 5 — Create Blue Target Group

Go to:

```text
EC2
→ Target Groups
→ Create target group
```

Choose:

```text
Target type: Instances
```

Configuration:

```text
Name: blue-target-group
Protocol: HTTP
Port: 80
IP address type: IPv4
VPC: Same VPC as EC2
```

Health check:

```text
Protocol: HTTP
Path: /
```

Register:

```text
blue-server-v1
Port: 80
```

Expected:

```text
blue-target-group
       │
       ▼
blue-server-v1
       │
       ▼
Healthy
```

## Step 6 — Create Green Target Group

Create:

```text
Name: green-target-group
Protocol: HTTP
Port: 80
IP address type: IPv4
```

Health check:

```text
Protocol: HTTP
Path: /
```

Register:

```text
green-server-v2
Port: 80
```

If the target initially shows:

```text
Unused
```

this can simply mean the target group is not currently configured to receive traffic from an ALB listener/rule.

Once associated with the ALB, target health is evaluated in that traffic context.

## Step 7 — Create Application Load Balancer

Go to:

```text
EC2
→ Load Balancers
→ Create Load Balancer
```

Choose:

```text
Application Load Balancer
```

Configuration:

```text
Name: blue-green-alb
Scheme: Internet-facing
IP address type: IPv4
```

Choose the same VPC and suitable subnets in at least two Availability Zones where possible.

### ALB Security Group

Allow:

```text
HTTP
Port: 80
Source: 0.0.0.0/0
```

For temporary Green testing:

```text
TCP
Port: 8080
Source: 0.0.0.0/0
```

For real production environments, restrict access wherever possible.

## Step 8 — Configure Production Listener

Create:

```text
HTTP :80
```

Default action:

```text
Forward to:
blue-target-group
```

Production flow:

```text
User
 ↓
ALB :80
 ↓
blue-target-group
 ↓
blue-server-v1
 ↓
Version 1
```

## Step 9 — Test Green Environment

Create an additional listener:

```text
HTTP :8080
```

Default action:

```text
green-target-group
```

Flow:

```text
ALB :8080
     ↓
green-target-group
     ↓
green-server-v2
     ↓
Version 2
```

Test:

```text
http://ALB-DNS:8080
```

Expected:

```text
GREEN - VERSION 2
New Production Application
```

This tests Green through the ALB before making it production.

## Step 10 — Switch Production Traffic to Green

Go to:

```text
ALB
→ Listeners and rules
→ HTTP :80
→ Edit
```

Change:

```text
blue-target-group
```

to:

```text
green-target-group
```

Save.

### Before

```text
USER
 ↓
ALB :80
 ↓
🔵 BLUE
 ↓
Version 1
```

### After

```text
USER
 ↓
ALB :80
 ↓
🟢 GREEN
 ↓
Version 2
```

Open:

```text
http://ALB-DNS
```

Expected:

```text
GREEN - VERSION 2
```

**Blue-Green deployment completed.**

## Step 11 — Roll Back to Blue

If Version 2 has a critical problem:

```text
ALB
→ Listeners and rules
→ HTTP :80
→ Edit
```

Change:

```text
green-target-group
```

back to:

```text
blue-target-group
```

Save and refresh:

```text
http://ALB-DNS
```

Expected:

```text
BLUE - VERSION 1
```

This demonstrates fast rollback.

# 🔄 Complete Deployment Flow

```text
             🔵 BLUE
             Version 1
                 │
                 ▼
             Production
                 │
                 ▼
                ALB
                 │
       ┌─────────┴─────────┐
       │                   │
       ▼                   ▼
     BLUE                 GREEN
     V1                    V2
 Production              Testing
```

Deployment:

```text
Deploy Version 2
       ↓
Create Green
       ↓
Test Green
       ↓
Health Check
       ↓
Switch ALB
       ↓
Green becomes Production
```

Rollback:

```text
Green fails
    ↓
Change ALB listener
    ↓
Blue Target Group
    ↓
Version 1
    ↓
Production restored
```

# 🆚 ALB vs Blue-Green Deployment

### Normal ALB Load Balancing

Purpose:

> Route requests among available healthy servers.

```text
ALB
 ├── EC2-1
 └── EC2-2
```

Both can run the same application version.

### Blue-Green Deployment

Purpose:

> Safely deploy a new application version and quickly switch or roll back production traffic.

```text
ALB
 ├── 🔵 Blue → Version 1
 └── 🟢 Green → Version 2
```

Key difference:

```text
ALB = Traffic distribution

Blue-Green = Deployment strategy
```

ALB can be the traffic-management mechanism used to implement Blue-Green, but ALB itself is not Blue-Green Deployment.

# 🚨 Troubleshooting

## Target shows `Unused`

Possible reason:

```text
Target Group
     ↓
No ALB listener/rule using it
```

Associate the target group with the appropriate ALB listener/rule.

## Target shows `Unhealthy`

Check:

```bash
sudo systemctl status nginx
curl http://localhost
sudo ss -tulpn | grep :80
```

Also verify:

- Correct target instance
- Correct target port
- Correct health-check path
- Nginx is running
- EC2 Security Group allows traffic from the ALB Security Group

## ALB DNS does not open

Check:

- ALB state is `Active`
- ALB is Internet-facing
- ALB Security Group allows port 80
- Listener exists on port 80
- Target Group is associated
- Target is healthy
- Nginx is running

## Green works directly but not through ALB

Test:

```bash
curl http://localhost
```

Then verify:

```text
Green Target Group
        ↓
green-server-v2
        ↓
Port 80
```

Check the ALB listener and Security Groups.

## Browser still shows Blue after switching

Possible causes:

- Browser cache
- Existing connection
- ALB configuration propagation
- Listener still points to Blue
- Green target is not healthy

Try:

```text
Ctrl + F5
```

Then verify the ALB listener configuration.

# 🔐 Best Practices

### 1. Don't expose EC2 directly in production

Preferred:

```text
Internet
   ↓
ALB
   ↓
EC2
```

EC2 should ideally allow HTTP only from the ALB Security Group rather than:

```text
0.0.0.0/0 → EC2 :80
```

### 2. Always test Green before switching

```text
Deploy
 ↓
Test
 ↓
Health Check
 ↓
Switch
```

### 3. Keep Blue available during deployment

Don't immediately terminate Blue after switching to Green. Keep it available until the new version is confirmed stable.

### 4. Always have a rollback plan

Ask:

> How do I go back?

In this lab:

```text
Green → Blue
```

was an ALB listener change.

### 5. Automate production deployments

Manual Blue-Green is excellent for learning.

In real environments, AWS CodeDeploy or CI/CD tooling can automate Blue-Green deployments.

# 🧹 Cleanup

AWS resources can incur charges depending on your account or sandbox.

Recommended cleanup:

```text
1. Delete ALB
2. Delete Target Groups
3. Terminate Blue EC2
4. Terminate Green EC2
5. Remove unused Security Groups
```

Follow your sandbox's own cleanup rules.

# 🎤 Interview Questions

### 1. What is Blue-Green Deployment?

Blue-Green Deployment maintains two environments: Blue is the current production version and Green contains the new version. Traffic is switched to Green after testing.

### 2. Why use Blue-Green Deployment?

To reduce downtime and make rollback fast and simple.

### 3. What is Blue?

The currently active production environment.

### 4. What is Green?

The new version being deployed and tested before becoming production.

### 5. Is ALB itself Blue-Green Deployment?

No. ALB is a load-balancing service. Blue-Green is a deployment strategy.

### 6. How did we implement Blue-Green in this lab?

```text
2 EC2 instances
2 Target Groups
1 Application Load Balancer
```

Blue contained Version 1 and Green contained Version 2.

### 7. Why two Target Groups?

To keep the Blue and Green environments separate.

```text
Blue Target Group → Version 1
Green Target Group → Version 2
```

### 8. Why port 8080?

It was used as a temporary testing listener so Green could be tested without changing production traffic on port 80.

### 9. What was production initially pointing to?

```text
ALB :80
   ↓
Blue Target Group
```

### 10. How did we deploy Green?

We created a separate EC2 instance and deployed Version 2 on it.

### 11. How did we switch Blue to Green?

Changed the ALB HTTP :80 listener's default action from Blue Target Group to Green Target Group.

### 12. How do you rollback?

Change the ALB listener back to the Blue Target Group.

### 13. Biggest advantage?

Fast rollback with minimal downtime.

### 14. Disadvantage?

Two environments may run simultaneously, increasing infrastructure cost.

### 15. What if Green is unhealthy?

Keep production traffic on Blue until Green is fixed.

### 16. Can Blue and Green run in different Availability Zones?

Yes. This can improve availability and resilience.

### 17. What is a Target Group?

A Target Group contains backend targets to which the ALB routes traffic and performs health checks.

### 18. What is an ALB listener?

A listener accepts incoming connections on a configured protocol and port and determines how requests are routed.

Example:

```text
HTTP :80
```

### 19. What is a health check?

A health check allows the load balancer to determine whether a registered target can successfully respond to requests.

### 20. Blue-Green vs Rolling Deployment?

Blue-Green:

```text
Version 1 → Version 2
Two environments
Fast rollback
```

Rolling:

```text
EC2-1 → Version 2
EC2-2 → Version 2
EC2-3 → Version 2
```

Instances are updated gradually.

### 21. Blue-Green vs Canary Deployment?

Blue-Green generally switches traffic between two environments.

Canary sends a small percentage of traffic to the new version first.

Example:

```text
Blue: 90%
Green: 10%
```

Then Green traffic can be increased gradually.

# 📝 Summary

Infrastructure:

```text
2 EC2
   ↓
2 Target Groups
   ↓
1 Application Load Balancer
```

Blue:

```text
blue-server-v1
      ↓
Version 1
```

Green:

```text
green-server-v2
      ↓
Version 2
```

Deployment:

```text
Blue
 ↓
Deploy Green
 ↓
Test Green
 ↓
Switch ALB
 ↓
Green becomes Production
```

Rollback:

```text
Green
 ↓
Problem
 ↓
ALB listener change
 ↓
Blue
 ↓
Production restored
```

## 🏆 What I Learned

```text
Blue-Green Deployment
        ↓
Two independent environments
        ↓
Separate application versions
        ↓
Separate Target Groups
        ↓
ALB controls production traffic
        ↓
Test Green before deployment
        ↓
Switch traffic
        ↓
Fast rollback
```

### Most Important Takeaway

> **Blue-Green Deployment is not simply routing traffic to a healthy server. It is a deployment strategy where a new application version is prepared separately, tested, and then promoted to production while the old version remains available for rollback.**

# ⏭️ Next Steps

Automate the manual process:

```text
Developer
    ↓
GitHub
    ↓
CI/CD
    ↓
CodeDeploy
    ↓
Green Environment
    ↓
Testing
    ↓
Traffic Switch
    ↓
Production
```

Recommended future labs:

- AWS CodeDeploy Blue-Green Deployment
- Canary Deployment
- Rolling Deployment
- Docker Blue-Green Deployment
- CI/CD with GitHub Actions
- Docker + ECR + EC2
- Complete CI/CD production architecture

# 📦 GitHub

Suggested repository/folder:

```text
aws-blue-green-deployment
```

Suggested README:

```text
README.md
```

Git commands:

```bash
git add .
git commit -m "docs: add day 21 blue-green deployment lab"
git push
```

# 🏁 Lab Status

```text
✅ Blue EC2 created
✅ Green EC2 created
✅ Blue application deployed
✅ Green application deployed
✅ Blue Target Group created
✅ Green Target Group created
✅ ALB created
✅ Health checks configured
✅ Green tested through ALB
✅ Production traffic switched Blue → Green
✅ Rollback tested Green → Blue
```

**Day 21 — Blue-Green Deployment: Completed ✅**
