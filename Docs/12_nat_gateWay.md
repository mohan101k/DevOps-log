# Day 8 — NAT Gateway in AWS
**Date:** April 22, 2026  
**Course:** DevOps with Multicloud  
**Instructor:** Mr. Veerababu

---

# 📖 Introduction

When learning AWS networking, one common question is:

> **"If Internet Gateway (IGW) already provides internet access, why do we need a NAT Gateway?"**

The answer is simple:

- **Internet Gateway** is used for **Public Subnets**.
- **NAT Gateway** is used for **Private Subnets**.

Both provide internet connectivity, but they solve different problems.

---

# 🏗 AWS Network Architecture

```text
                    Internet
                        │
                Internet Gateway
                        │
         ┌──────────────┴──────────────┐
         │                             │
    Public Subnet                 Private Subnet
         │                             │
      EC2 (Public)                 EC2 (Private)
         │                             │
         │                      NAT Gateway
         │                             │
         └──────────────►──────────────┘
```

---

# 🌐 What is an Internet Gateway (IGW)?

An **Internet Gateway (IGW)** is a service that allows communication between your **VPC** and the **Internet**.

Without an IGW:

- Your VPC cannot access the Internet.
- Users on the Internet cannot access your public servers.

---

## Purpose of Internet Gateway

- Connects VPC to the Internet
- Enables inbound and outbound traffic
- Used by Public Subnets
- Required for public EC2 instances

---

## Example

Suppose you launch a web server.

```
Internet
     │
Internet Gateway
     │
Public EC2
```

Users can access your website because the server is in a **Public Subnet**.

---

# 🔒 What is a NAT Gateway?

A **NAT (Network Address Translation) Gateway** allows resources inside a **Private Subnet** to access the Internet **without allowing the Internet to initiate connections back to them.**

---

## Purpose of NAT Gateway

Private servers often need internet access for:

- Software updates
- Installing packages
- Downloading dependencies
- Security patches
- Accessing AWS APIs

But they should **NOT** be publicly accessible.

This is where NAT Gateway is used.

---

# Real-Time Example

Imagine:

### Public EC2

- Hosts your website
- Users access it from anywhere

Needs:

- Internet Gateway

---

### Private EC2

Runs:

- Database
- Backend
- Internal Application

Needs internet only for:

- apt update
- yum update
- Download Docker
- Install Java

It **does NOT** need incoming internet traffic.

So it uses:

- NAT Gateway

---

# Why Can't Private EC2 Use Internet Gateway Directly?

Because:

A Private EC2 **does not have a Public IP**.

Internet Gateway only works with instances that have:

- Public IP
- Elastic IP

Private EC2 has neither.

Therefore:

```
Private EC2
      ❌
Cannot directly use Internet Gateway
```

---

# How NAT Gateway Works

```
Private EC2
      │
      ▼
NAT Gateway
      │
      ▼
Internet Gateway
      │
      ▼
Internet
```

Response returns through the same path.

```
Internet
     │
Internet Gateway
     │
NAT Gateway
     │
Private EC2
```

---

# Important Rule

Internet **cannot** start communication with Private EC2.

Only Private EC2 can initiate the request.

Example:

```
Private EC2
     │
Request Google
     ▼
Google replies
```

Allowed ✅

But

```
Google
    │
Trying to SSH into Private EC2
```

Blocked ❌

---

# NAT Gateway Requirements

Before creating a NAT Gateway, you need:

- VPC
- Public Subnet
- Internet Gateway attached
- Elastic IP
- Route Table

---

# Why Elastic IP?

A NAT Gateway needs a **Public IP** to communicate with the Internet.

AWS provides this using an **Elastic IP**.

---

# Route Table Configuration

## Public Subnet

```
Destination       Target

0.0.0.0/0      Internet Gateway
```

---

## Private Subnet

```
Destination       Target

0.0.0.0/0      NAT Gateway
```

This means:

Private subnet sends all internet traffic to the NAT Gateway.

---

# Complete Flow

```
Private EC2

      │

Private Route Table

      │

NAT Gateway

      │

Public Route Table

      │

Internet Gateway

      │

Internet
```

---

# Example

Suppose your private EC2 runs Ubuntu.

You execute:

```bash
sudo apt update
```

Flow:

```
Private EC2

↓

NAT Gateway

↓

Internet Gateway

↓

Ubuntu Repository

↓

Downloads Packages

↓

Back to EC2
```

Works successfully.

---

# Another Example

Installing Docker:

```bash
sudo apt install docker.io
```

Docker packages are downloaded through:

```
Private EC2

↓

NAT Gateway

↓

Internet
```

---

# Real-Time Company Example

Imagine Amazon has:

```
Frontend Servers
```

These must be public.

```
Internet

↓

IGW

↓

Public EC2
```

Backend services:

```
Database

Payment Service

Authentication Service
```

These are private.

They need updates but should never be exposed.

So:

```
Private EC2

↓

NAT Gateway

↓

Internet
```

---

# Internet Gateway vs NAT Gateway

| Feature | Internet Gateway | NAT Gateway |
|----------|-----------------|-------------|
| Used with | Public Subnet | Private Subnet |
| Allows Internet Access | Yes | Yes (Outbound Only) |
| Allows Incoming Connections | Yes | No |
| Requires Public IP | Yes | NAT Gateway has Elastic IP |
| Used for Web Servers | Yes | No |
| Used for Databases | No | Yes |

---

# Advantages of NAT Gateway

- Improves security
- Keeps servers private
- Allows software updates
- Managed by AWS
- Highly available within an Availability Zone
- Easy to configure

---

# Limitations

- Paid AWS service
- Created in only one Availability Zone (create one per AZ for high availability)
- Cannot accept incoming internet traffic

---

# Common Interview Questions

### 1. Why do we need a NAT Gateway?

To allow private subnet resources to access the Internet without exposing them to inbound internet traffic.

---

### 2. Can a Private EC2 access the Internet without a NAT Gateway?

No. Unless another outbound solution (like a NAT Instance) is configured.

---

### 3. Can Internet users connect directly to a Private EC2 through a NAT Gateway?

No.

---

### 4. Does NAT Gateway require an Elastic IP?

Yes.

---

### 5. In which subnet should a NAT Gateway be created?

A **Public Subnet**.

---

### 6. Which route table points to the NAT Gateway?

The **Private Subnet Route Table**.

---

### 7. Can a NAT Gateway receive incoming SSH requests?

No.

---

### 8. Which AWS service translates private IP addresses to a public IP for outbound internet access?

NAT Gateway.

---

# Key Points to Remember

- **Internet Gateway** provides internet connectivity for **public subnets**.
- **NAT Gateway** provides **outbound-only internet access** for **private subnets**.
- A NAT Gateway must be placed in a **Public Subnet**.
- A NAT Gateway requires an **Elastic IP**.
- Private subnet route tables should point `0.0.0.0/0` to the NAT Gateway.
- Internet traffic for private instances flows through: **Private EC2 → NAT Gateway → Internet Gateway → Internet**.
- Internet users cannot directly access private EC2 instances through a NAT Gateway.

---

# Summary

An **Internet Gateway (IGW)** makes resources in a **Public Subnet** reachable from the Internet, making it ideal for web servers, load balancers, and bastion hosts.

A **NAT Gateway** enables resources in a **Private Subnet** to access the Internet for updates and downloads while keeping them hidden from inbound internet traffic. This improves security and follows AWS networking best practices.

Together, **Internet Gateway + NAT Gateway** provide a secure and scalable architecture where public-facing services remain accessible, while sensitive backend resources stay protected.
