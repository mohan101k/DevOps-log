
# 🚀 AWS Auto Scaling Group (ASG)

## 📌 Overview

Amazon EC2 Auto Scaling helps automatically launch and terminate EC2 instances based on application demand. It ensures high availability, fault tolerance, and cost optimization by maintaining the desired number of healthy instances.

---

# 🏗️ Architecture

```text
                    Users
                      │
                      ▼
            Application Load Balancer
                      │
               Target Group (TG)
                      │
        ┌─────────────┴─────────────┐
        ▼                           ▼
     EC2 Instance              EC2 Instance
          ▲                           ▲
          └─────────────┬─────────────┘
                        │
              Auto Scaling Group (ASG)
                        │
                Launch Template (LT)
                        │
                        ▼
                    Amazon AMI
```

---

# 📚 Components

## 1️⃣ Availability Zones (AZ)

- Physical data centers inside an AWS Region.
- ASG can launch instances across multiple AZs.
- Provides High Availability and Fault Tolerance.

### Example

```
us-east-1a
us-east-1b
us-east-1c
```

---

## 2️⃣ Subnets

Subnets belong to a VPC and are mapped to Availability Zones.

Example:

```
VPC
├── Public Subnet (AZ-1)
├── Public Subnet (AZ-2)
├── Private Subnet (AZ-1)
└── Private Subnet (AZ-2)
```

ASG launches instances only inside the selected subnets.

---

## 3️⃣ Amazon Machine Image (AMI)

An AMI is a template used to launch EC2 instances.

It contains:

- Operating System
- Installed Software
- Application Code
- Required Packages
- Configurations

Every EC2 instance launched by ASG uses the same AMI, ensuring application consistency.

---

## 4️⃣ Launch Template (LT)

A Launch Template defines how EC2 instances should be launched.

It includes:

- AMI ID
- Instance Type
- Key Pair
- Security Groups
- IAM Role
- Storage (EBS)
- User Data Script
- Network Configuration

Using a Launch Template ensures every instance is identical.

---

## 5️⃣ Application Consistency

Since every EC2 instance uses:

- Same AMI
- Same Launch Template

All servers have:

- Same OS
- Same Application
- Same Packages
- Same Configuration

This guarantees consistency across all instances.

---

## 6️⃣ Target Group (TG)

The Target Group contains all EC2 instances serving the application.

Responsibilities:

- Registers EC2 instances
- Performs Health Checks
- Removes unhealthy instances
- Sends only healthy instances to the Load Balancer

---

## 7️⃣ Load Balancer (ALB)

Application Load Balancer distributes incoming traffic.

Functions:

- Evenly distributes requests
- Supports Path-Based Routing
- Supports Host-Based Routing
- Sends traffic only to healthy instances

---

# ⚙️ ASG Workflow

## Step 1

Create an EC2 instance.

---

## Step 2

Install your application.

Example:

- Nginx
- Apache
- Node.js
- Java Application

---

## Step 3

Create an AMI.

```
EC2
   │
Create Image
   │
   ▼
AMI
```

---

## Step 4

Create a Launch Template using the AMI.

Configure:

- Instance Type
- Security Group
- IAM Role
- Key Pair
- User Data

---

## Step 5

Create a Target Group.

Choose:

- Protocol
- Port
- Health Check

---

## Step 6

Create an Application Load Balancer.

Attach the Target Group.

---

## Step 7

Create the Auto Scaling Group.

Configure:

- Launch Template
- VPC
- Subnets
- Minimum Capacity
- Desired Capacity
- Maximum Capacity
- Scaling Policy

---

## Step 8

Traffic Flow

```
Users
   │
   ▼
Application Load Balancer
   │
Target Group
   │
Auto Scaling Group
   │
EC2 Instances
```

---

# 📈 Scaling Types

## Dynamic Scaling

Automatically adds or removes EC2 instances based on:

- CPU Utilization
- Memory
- Network Traffic
- CloudWatch Alarms

---

## Scheduled Scaling

Launches or terminates instances at specific times.

Example:

Increase servers every morning at 9 AM.

---

## Predictive Scaling

Uses machine learning to predict future traffic and launches instances before demand increases.

---

# 📊 Benefits

- High Availability
- Fault Tolerance
- Automatic Scaling
- Cost Optimization
- Improved Performance
- Health Monitoring
- Easy Management

---

# 📝 Summary

| Component | Purpose |
|-----------|----------|
| AZ | High Availability |
| Subnet | Network placement |
| AMI | Application Image |
| Launch Template | EC2 Configuration |
| ASG | Automatic Scaling |
| Target Group | Health Check & Registration |
| ALB | Traffic Distribution |

---

# 🎯 Learning Outcome

After completing this project, you will understand:

- Amazon AMI
- Launch Templates
- Auto Scaling Groups
- Application Load Balancer
- Target Groups
- High Availability
- Fault Tolerance
- Automatic Scaling in AWS
