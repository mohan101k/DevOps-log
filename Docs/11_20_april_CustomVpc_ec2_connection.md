
# Day 7 — Custom VPC Networking & EC2 Connection
**Date:** April 20, 2026  
**Course:** DevOps Bootcamp  
**Instructor:** Mr. Veerababu

---

# 📚 Concepts Covered

- Creating a Custom VPC
- Default VPC vs Custom VPC
- Public and Private Subnets
- Internet Gateway (IGW)
- Route Tables
- Security Groups
- Launching EC2 in a Custom VPC
- Connecting to EC2 using SSH
- Fixing common SSH connection problems

---

# 📑 Contents

- [📚 Concepts Covered](#-concepts-covered)
- [🧠 Theory Notes](#-theory-notes)
  - [Default VPC vs Custom VPC](#default-vpc-vs-custom-vpc)
  - [Public vs Private Subnet](#public-vs-private-subnet)
  - [VPC CIDR & Subnet CIDR](#vpc-cidr--subnet-cidr)
  - [Internet Gateway (IGW)](#internet-gateway-igw)
  - [Route Table](#route-table)
  - [Security Group](#security-group)
  - [Public IP vs Private IP](#public-ip-vs-private-ip)
- [🏗️ Architecture Diagram](#️-architecture-diagram)
- [💻 Commands](#-commands)
- [🛠️ SSH Tools Comparison](#️-ssh-tools-comparison)
- [🐛 Troubleshooting SSH](#-troubleshooting-ssh)
- [✅ What I Practiced](#-what-i-practiced)
- [❌ Mistakes & Fixes](#-mistakes--fixes)
- [❓ Questions I Still Have](#-questions-i-still-have)
- [⏭️ Next Steps](#️-next-steps)

---

# 🧠 Theory Notes

## Default VPC vs Custom VPC

When you create an AWS account, AWS gives you a **Default VPC**. It is already configured, so you can launch EC2 instances immediately.

A **Custom VPC** is created by you. You decide:

- CIDR range
- Number of subnets
- Route Tables
- Internet Gateway
- Security settings

In real companies, engineers usually create **Custom VPCs** because they have full control over the network.

---

## Public vs Private Subnet

AWS does not automatically call a subnet **Public** or **Private**.

A subnet becomes **Public** only if:

- It has a route to an Internet Gateway.
- The EC2 instance has a Public IP.

Otherwise, it is a **Private Subnet**.

| Feature | Public Subnet | Private Subnet |
|----------|---------------|----------------|
| Internet Access | ✅ Yes | ❌ No |
| Route to IGW | ✅ Yes | ❌ No |
| Public IP | ✅ Yes | ❌ No |
| Used For | Web Servers | Databases, Application Servers |

**Remember:**

Both conditions are required for internet access:

- Route to IGW
- Public IP

---

## VPC CIDR & Subnet CIDR

Example:

```text
VPC
10.0.0.0/16

Public Subnet
10.0.0.0/24

Private Subnet
10.0.1.0/24
```

Meaning:

- `/16` → 65,536 IP addresses
- `/24` → 256 IP addresses

AWS keeps **5 IP addresses** for its own use.

So a `/24` subnet gives **251 usable IP addresses**.

---

## Internet Gateway (IGW)

An **Internet Gateway (IGW)** allows your VPC to communicate with the internet.

Important points:

- Attached to a VPC
- Not attached to EC2
- Not attached to a subnet
- One IGW can be attached to one VPC

Without an IGW, your instances cannot access the internet.

---

## Route Table

A Route Table decides where network traffic should go.

Example:

| Destination | Target |
|-------------|--------|
| 10.0.0.0/16 | Local |
| 0.0.0.0/0 | Internet Gateway |

To make a subnet public:

1. Create an Internet Gateway.
2. Attach it to the VPC.
3. Add route `0.0.0.0/0 → IGW`.
4. Associate the Route Table with the subnet.

Now the subnet becomes public.

---

## Security Group

A Security Group works like a firewall for an EC2 instance.

It controls which traffic is allowed.

Example:

| Rule | Port | Source |
|------|------|--------|
| SSH | 22 | 0.0.0.0/0 |
| HTTP | 80 | 0.0.0.0/0 |
| HTTPS | 443 | 0.0.0.0/0 |

Security Groups are **Stateful**.

If incoming traffic is allowed, the reply is automatically allowed.

Remember:

- Security Group checks network traffic.
- It does **not** check your SSH key.

---

## Public IP vs Private IP

| Public IP | Private IP |
|------------|------------|
| Given by AWS | Comes from your VPC CIDR |
| Used from the Internet | Used inside the VPC |
| Needed for SSH from your laptop | Used for internal communication |

To connect from your computer to EC2:

- EC2 must have a Public IP.
- EC2 must be inside a Public Subnet.

Both are required.

---

# 🏗️ Architecture Diagram

```text
                    Internet
                        │
                Internet Gateway
                        │
          ┌────────────────────────┐
          │        VPC             │
          │     10.0.0.0/16        │
          │                        │
          │     Route Table        │
          │ 0.0.0.0/0 → IGW        │
          │                        │
     ┌──────────────┐      ┌──────────────┐
     │ PublicSubnet │      │ PrivateSubnet│
     │10.0.0.0/24   │      │10.0.1.0/24   │
     │              │      │              │
     │ EC2          │      │ EC2          │
     │Public IP     │      │Private IP    │
     └──────────────┘      └──────────────┘
```

---

# 💻 Commands

## Connect from Linux / macOS

```bash
ssh -i /path/to/key.pem ec2-user@<public-ip>
```

---

## Connect from Windows

```bash
ssh -i "C:\Users\YourName\Downloads\key.pem" ec2-user@<public-ip>
```

---

## Verify Login

```bash
whoami
hostname
pwd
ls
```

Expected output:

```text
ec2-user
```

---

# 🛠️ SSH Tools Comparison

| Tool | Key Format | Notes |
|------|------------|------|
| MobaXterm | .pem / .ppk | Easy to use |
| PuTTY | .ppk | Convert .pem using PuTTYgen |
| VS Code | .pem | Uses Remote SSH Extension |
| Windows/Linux Terminal | .pem | Built-in SSH |
| EC2 Instance Connect | No key | Browser-based login |

---

# 🐛 Troubleshooting SSH

## Error: Connection Timed Out

This means the connection never reached the EC2 instance.

Check these:

- Is EC2 running?
- Is the subnet public?
- Is Route Table connected to IGW?
- Is IGW attached to the VPC?
- Is port 22 allowed in the Security Group?
- Does EC2 have a Public IP?

---

## Error: Permission Denied

This means the connection reached the server, but login failed.

Check:

- Are you using the correct `.pem` file?
- Are you using the correct username?
  - Amazon Linux → `ec2-user`
  - Ubuntu → `ubuntu`
- Don't use the wrong key.

Remember:

**Connection Timed Out = Network Problem**

**Permission Denied = Authentication Problem**

---

# ✅ What I Practiced

- Created a Custom VPC
- Created Public and Private Subnets
- Attached an Internet Gateway
- Created a Route Table
- Added route `0.0.0.0/0 → IGW`
- Associated the Route Table with the Public Subnet
- Created a Security Group
- Allowed SSH on Port 22
- Launched an EC2 instance
- Connected to EC2 using SSH
- Practiced the complete setup from beginning

---

# ❌ Mistakes & Fixes

> *(Add your mistakes here after practice.)*

Example:

- Forgot to attach the Internet Gateway.
- Forgot to enable Public IP.
- Selected the wrong key pair.
- Used the wrong username.

---

# ❓ Questions I Still Have

- Why do private subnets need a NAT Gateway?
- Can one Route Table be used for multiple subnets?
- What happens if we remove the Internet Gateway?

---

# ⏭️ Next Steps

- Remove the Internet Gateway and see what happens.
- Remove the Route Table association and test again.
- Build the whole VPC without looking at notes.
- Learn about NAT Gateway, Bastion Host, and Jump Server.
