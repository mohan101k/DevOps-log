# AWS Fundamentals – Servers, Networking & IP Addressing

> **Goal:** Understand the basic networking concepts required before learning AWS networking services like VPC, EC2, Route 53, Load Balancer, NAT Gateway, and Security Groups.

---

# Table of Contents

1. AWS Pool (Resource Pool)
2. Types of Servers
3. Address Server (Addressing & Server Identification)
4. Server Use Cases
5. What is CIDR?
6. What is an IP Address?
7. Proxy Server
8. Interview Questions
9. Summary

---

# 1. AWS Pool (Resource Pool)

## Definition

AWS works on the concept of a **resource pool**.

Instead of buying your own hardware, AWS owns thousands of servers inside data centers worldwide. These servers are grouped into large pools of computing resources.

Whenever a customer launches an EC2 instance, AWS allocates resources from this pool.

Think of it as:

```
AWS Data Center

+----------------------------------------+
| CPU Pool                               |
| RAM Pool                               |
| Storage Pool                           |
| Network Pool                           |
+----------------------------------------+

          ↓

Customer launches EC2

          ↓

AWS allocates resources from the pool
```

---

## Why Resource Pooling?

Instead of every company buying:

- CPU
- RAM
- Storage
- Networking equipment

AWS shares its infrastructure among millions of customers securely.

Benefits:

- Lower cost
- Better utilization
- Easy scaling
- High availability
- Faster deployment

---

## Real-Time Example

Netflix does not own millions of physical servers worldwide.

Instead, it uses AWS resources whenever users watch movies.

AWS allocates compute, storage, and networking resources from its massive infrastructure.

---

# 2. Types of Servers

A server is a computer that provides services to other computers (clients).

```
Client

↓

Server

↓

Provides Service
```

---

## 1. Web Server

Purpose:

Hosts websites.

Examples:

- Apache
- Nginx
- IIS

Example:

```
www.amazon.com

↓

Web Server

↓

Returns HTML page
```

---

## 2. Application Server

Runs business logic.

Example:

```
Login

↓

Application Server

↓

Validate User

↓

Database
```

Examples:

- Tomcat
- JBoss
- WebLogic

---

## 3. Database Server

Stores data.

Examples:

- MySQL
- PostgreSQL
- Oracle
- SQL Server

Stores:

- Users
- Orders
- Products
- Transactions

---

## 4. File Server

Stores files.

Examples:

- Documents
- Images
- Videos
- PDFs

AWS Equivalent:

- Amazon EFS
- Amazon S3

---

## 5. Mail Server

Handles email communication.

Examples:

- Gmail
- Outlook
- Exchange Server

Protocols:

- SMTP
- POP3
- IMAP

---

## 6. DNS Server

Converts:

```
google.com

↓

142.250.xx.xx
```

Without DNS:

Users would have to remember IP addresses.

---

## 7. Proxy Server

Acts as an intermediary between client and internet.

(Explained in detail later.)

---

## 8. FTP Server

Transfers files.

Protocols:

- FTP
- SFTP

---

## 9. DHCP Server

Automatically assigns IP addresses.

Example:

When you connect to Wi-Fi,

DHCP gives your laptop an IP address.

---

## 10. Print Server

Manages printers in offices.

Multiple users

↓

Print Server

↓

Printer

---

# Server Comparison

| Server | Purpose |
|---------|----------|
| Web Server | Hosts websites |
| Application Server | Runs application logic |
| Database Server | Stores data |
| File Server | Stores files |
| Mail Server | Email services |
| DNS Server | Converts domain to IP |
| DHCP Server | Gives IP addresses |
| FTP Server | File transfer |
| Proxy Server | Security & caching |
| Print Server | Printer management |

---

# 3. Address Server (Server Addressing)

Every server needs an address so clients can communicate with it.

There are two common ways:

## Domain Name

Example

```
amazon.com
```

Easy for humans.

---

## IP Address

Example

```
52.95.110.1
```

Computers communicate using IP addresses.

---

Flow:

```
User

↓

amazon.com

↓

DNS

↓

52.95.xx.xx

↓

Server
```

---

## AWS Example

EC2 Instance

Public IP

↓

Accessible from Internet

Private IP

↓

Used inside AWS VPC

---

# 4. Server Use Cases

## Banking

Servers store:

- Accounts
- Transactions
- Customer information

---

## E-Commerce

Amazon uses servers for:

- Product catalog
- Payments
- Orders
- Inventory

---

## Social Media

Instagram stores:

- Photos
- Videos
- Likes
- Comments

---

## Streaming

Netflix

Uses servers for:

- Video streaming
- User recommendations
- Watch history

---

## Online Gaming

Game servers maintain:

- Player data
- Live matches
- Scores

---

## Cloud Storage

Google Drive

Stores:

- Files
- Images
- Videos

---

# 5. What is CIDR?

CIDR stands for:

**Classless Inter-Domain Routing**

CIDR is a method of allocating IP addresses and defining network ranges.

AWS VPC uses CIDR blocks.

---

## CIDR Format

```
192.168.1.0/24
```

Here,

```
192.168.1.0
```

Network Address

```
/24
```

Subnet Mask

---

## Common CIDR Blocks

| CIDR | Number of IPs |
|-------|---------------|
| /32 | 1 |
| /30 | 4 |
| /29 | 8 |
| /28 | 16 |
| /27 | 32 |
| /26 | 64 |
| /25 | 128 |
| /24 | 256 |
| /23 | 512 |
| /22 | 1024 |
| /16 | 65,536 |

---

## AWS Example

When creating a VPC:

```
10.0.0.0/16
```

AWS creates a network capable of supporting thousands of private IP addresses.

---

## Example

```
VPC

10.0.0.0/16

↓

Subnet 1

10.0.1.0/24

↓

Subnet 2

10.0.2.0/24
```

---

## Why CIDR?

Without CIDR:

IP allocation becomes inefficient.

With CIDR:

- Better IP management
- Easy subnet creation
- Flexible networking
- Reduced IP wastage

---

# 6. What is an IP Address?

IP stands for

**Internet Protocol**

An IP Address is a unique identifier assigned to every device connected to a network.

Example:

```
Laptop

↓

192.168.1.5
```

---

## Why IP?

Without IP:

Computers cannot communicate.

IP acts like a house address.

Just as a courier needs your home address,

the internet needs your IP address to send and receive data.

---

## Types of IP Address

### Public IP

Accessible from the internet.

Example:

```
8.8.8.8
```

Used for:

- Websites
- Public servers

---

### Private IP

Used inside private networks.

Examples:

```
10.x.x.x

172.16.x.x

192.168.x.x
```

Not directly accessible from the internet.

---

## IPv4

Example:

```
192.168.1.20
```

32-bit

Around 4.3 billion addresses.

---

## IPv6

Example:

```
2405:201:800::1
```

128-bit

Provides an almost unlimited number of addresses.

---

## AWS Example

An EC2 instance can have:

- Public IP
- Private IP

Public IP

↓

Internet Access

Private IP

↓

Communication inside the VPC

---

# 7. Proxy Server

## Definition

A Proxy Server is an intermediary server that sits between a client and the destination server.

Instead of directly accessing a website,

the request first goes to the proxy server.

```
Client

↓

Proxy Server

↓

Internet

↓

Website
```

---

## Without Proxy

```
Laptop

↓

Website
```

Direct communication.

---

## With Proxy

```
Laptop

↓

Proxy

↓

Website
```

---

## Why Use a Proxy Server?

### Security

Hides the client's IP address.

---

### Privacy

The destination website sees the proxy's IP instead of the user's real IP.

---

### Caching

Frequently accessed web pages are stored in the proxy cache.

This reduces loading time and saves bandwidth.

---

### Content Filtering

Organizations block:

- Facebook
- YouTube
- Gaming websites

using proxy servers.

---

### Monitoring

Companies monitor employee internet usage through proxy servers.

---

## Real-Time Example

Many schools and corporate offices use proxy servers to:

- Restrict access to social media.
- Monitor internet usage.
- Improve browsing speed using cached content.

---

## Advantages

- Improved security
- Faster browsing (cache)
- IP hiding
- Internet monitoring
- Website blocking
- Reduced bandwidth usage

---

## Disadvantages

- Single point of failure
- Additional configuration
- Can become a performance bottleneck
- Some websites may block proxy IPs

---

# Real-Time AWS Networking Example

A user opens:

```
www.amazon.com
```

Flow:

```
User

↓

DNS Server

↓

Public IP

↓

AWS Load Balancer

↓

EC2 Web Server

↓

Application Server

↓

Database Server

↓

Response

↓

User
```

Networking Concepts Used:

- IP Address
- DNS
- Server
- CIDR
- Public Network
- Private Network

---

# Interview Questions

### Basic

1. What is a server?
2. What are the different types of servers?
3. What is an IP address?
4. What is the difference between Public IP and Private IP?
5. What is CIDR?
6. Why do we use CIDR in AWS?
7. What is IPv4?
8. What is IPv6?
9. What is a proxy server?
10. Why do companies use proxy servers?

---

### Intermediate

11. Explain the request flow from a browser to a web server.
12. What is the difference between a Web Server and an Application Server?
13. Why is DNS required?
14. Explain the CIDR block `10.0.0.0/16`.
15. Can one EC2 instance have both a Public IP and a Private IP?
16. What happens if two devices have the same IP address?
17. What are the benefits of private IP addresses?
18. What is resource pooling in AWS?
19. How does AWS allocate resources to EC2 instances?
20. What is the role of a proxy server in an enterprise network?

---

# Summary

| Topic | Key Point |
|--------|-----------|
| AWS Resource Pool | AWS shares compute, storage, and networking resources among customers. |
| Server | A computer that provides services to clients. |
| Types of Servers | Web, Application, Database, File, Mail, DNS, DHCP, FTP, Proxy, Print. |
| Server Addressing | Servers are identified using domain names and IP addresses. |
| CIDR | Defines network ranges and IP allocation using prefix notation (e.g., `/24`). |
| IP Address | A unique address used for communication between devices. |
| Public IP | Accessible from the internet. |
| Private IP | Used within private networks such as an AWS VPC. |
| Proxy Server | An intermediary server that improves security, privacy, caching, and access control. |

---

# Key Takeaways

- Every device on a network requires a unique IP address.
- CIDR determines the size of a network and how IP addresses are allocated.
- AWS uses resource pooling to provide scalable cloud infrastructure.
- Different server types perform specialized functions in modern applications.
- Proxy servers enhance security, privacy, and performance by acting as intermediaries.
- Understanding these networking fundamentals is essential before learning AWS VPC, Subnets, Route Tables, NAT Gateways, and Security Groups.
