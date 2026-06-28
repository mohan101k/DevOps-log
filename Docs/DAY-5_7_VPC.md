
# 📚 DAY-4 (AWS Fundamentals)

## 📌 Topics Covered

- What Does a DevOps Engineer Own?
- AWS Regions & Availability Zones (AZ)
- DNS
- Amazon Route 53
- VPC (Virtual Private Cloud)

---

# 📘 1. What Does a DevOps Engineer Own?

## 📖 Concept

A DevOps Engineer is responsible for automating the software delivery process and maintaining the infrastructure where applications run. They bridge the gap between Development and Operations by ensuring applications are deployed, monitored, secured, and scaled efficiently.

---

## 🌍 Real-Time Example

A developer pushes code to GitHub.

The DevOps Engineer ensures that:

- Jenkins automatically builds the application.
- Test cases execute successfully.
- Docker image is created.
- Application is deployed to AWS.
- Monitoring tools check the application's health.
- If the application crashes, it is automatically restarted.

---

## 🎯 Interview Point

A DevOps Engineer usually owns:

- CI/CD Pipeline
- Cloud Infrastructure
- Deployment
- Docker & Kubernetes
- Monitoring
- Logging
- Automation
- Infrastructure as Code (Terraform)
- Server Management
- Security & Secrets Management

---

## 🛠 Common Tools

- Git
- Jenkins
- Docker
- Kubernetes
- AWS
- Terraform
- Ansible
- Prometheus
- Grafana

---

> 💡 **Remember**
>
> Developer writes code.
>
> DevOps Engineer automates everything after the code is written.

---

# 📘 2. AWS Region & Availability Zone (AZ)

## 📖 Concept

### Region

A Region is a geographical location where AWS has one or more data centers.

Examples:

- Mumbai
- Singapore
- London
- Tokyo
- Virginia

Each Region is completely independent.

---

### Availability Zone (AZ)

An Availability Zone is an isolated data center inside a Region.

Every Region contains multiple AZs.

Example:

Mumbai Region

- ap-south-1a
- ap-south-1b
- ap-south-1c

---

## 🌍 Real-Time Example

Suppose your application is deployed in Mumbai Region.

If **AZ-1** goes down due to a power failure, AWS automatically serves users from **AZ-2**.

Users don't notice any downtime.

---

## 🎯 Interview Point

| Region | Availability Zone |
|---------|-------------------|
| Geographic Location | Data Center |
| Multiple AZs | Multiple Servers |
| Independent | Connected with High-Speed Network |

---

## 🛠 AWS Example

Mumbai Region

```
ap-south-1
```

Availability Zones

```
ap-south-1a
ap-south-1b
ap-south-1c
```

---

> 💡 **Remember**

Region = City

Availability Zone = Building inside that city

---

# 📘 3. DNS (Domain Name System)

## 📖 Concept

DNS converts a human-readable domain name into an IP Address.

Instead of remembering:

```
142.250.183.78
```

We simply type:

```
google.com
```

DNS finds the correct IP Address.

---

## 🌍 Real-Time Example

When you visit:

```
amazon.in
```

DNS translates the domain name into the IP Address of Amazon's server and connects your browser.

---

## 🎯 Interview Point

Without DNS, users would have to remember IP Addresses instead of website names.

---

## 🛠 Common DNS Records

- A Record
- AAAA Record
- CNAME
- MX
- TXT
- NS

---

> 💡 **Remember**

DNS = Internet Phone Book

---

# 📘 4. Amazon Route 53

## 📖 Concept

Amazon Route 53 is AWS's managed DNS service.

It registers domain names and routes user requests to AWS resources such as EC2, Load Balancers, and S3.

---

## 🌍 Real-Time Example

Suppose you own:

```
myshop.com
```

Route 53 points users to:

- EC2 Instance
- Load Balancer
- CloudFront
- S3 Website

without users knowing the server's IP Address.

---

## 🎯 Interview Point

Why use Route 53?

- Highly Available
- Highly Scalable
- Domain Registration
- Health Checks
- Traffic Routing
- Load Balancing

---

## 🛠 Common Routing Policies

- Simple Routing
- Weighted Routing
- Latency Routing
- Geolocation Routing
- Failover Routing

---

> 💡 **Remember**

DNS is the concept.

Route 53 is AWS's DNS service.

---

# 📘 5. VPC (Virtual Private Cloud)

## 📖 Concept

A VPC is your own private network inside AWS.

You decide:

- IP Address Range
- Subnets
- Routing
- Internet Access
- Security Rules

---

## 🌍 Real-Time Example

A company creates one VPC for its application.

Inside that VPC:

- Public Subnet → Web Server
- Private Subnet → Database Server

Users can access the Web Server, but the Database remains private.

---

## 🎯 Interview Point

VPC provides:

- Network Isolation
- Better Security
- Custom Networking
- Public & Private Subnets
- Route Tables
- Internet Gateway

---

## 🛠 Important Components

- CIDR Block
- Subnet
- Route Table
- Internet Gateway (IGW)
- NAT Gateway
- Security Group
- Network ACL

---

> 💡 **Remember**

VPC = Your Private Data Center inside AWS.

---

# 🎯 Quick Revision

| Topic | Key Point |
|--------|-----------|
| DevOps Engineer | Automates software delivery and manages infrastructure |
| AWS Region | Geographical location |
| Availability Zone | Data Center inside a Region |
| DNS | Converts Domain Name → IP Address |
| Route 53 | AWS Managed DNS Service |
| VPC | Private Network inside AWS |

---

# 📝 Summary

- DevOps Engineers automate deployment, infrastructure, monitoring, and scaling.
- AWS Regions contain multiple Availability Zones for high availability.
- DNS converts domain names into IP addresses.
- Route 53 is AWS's managed DNS service.
- VPC provides an isolated and secure network inside AWS.
