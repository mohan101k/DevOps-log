

---

# 📌 Topics Covered

- Client to Server Communication
- TCP vs UDP
- Virtual Private Cloud (VPC)
- Private IP Address Ranges
- CIDR (Classless Inter-Domain Routing)
- AWS Reserved IP Addresses
- Subnet Sizing
- Best Practice VPC Design

---

# 🧠 Theory Notes

## 🌐 Client → Server Communication

For a client (browser/mobile app) to connect to a server, four things are required.

| Requirement | Description |
|-------------|-------------|
| Internet | Provides network connectivity |
| IP Address | Identifies the server |
| Protocol | Rules for communication (HTTP, HTTPS, SSH, FTP) |
| Connection | TCP or UDP transfers the data |

### Real-Time Example

When you open **amazon.in**:

```
Browser
    ↓
Internet
    ↓
DNS finds IP
    ↓
TCP Connection
    ↓
Amazon Server
    ↓
Website Opens
```

> 💡 **Remember:** Without an IP address and protocol, the client cannot communicate with the server.

---

# 🌐 TCP vs UDP

TCP and UDP are transport layer protocols used for communication.

| Feature | TCP | UDP |
|----------|-----|-----|
| Connection | Connection-oriented | Connectionless |
| Reliability | Reliable | Not Reliable |
| Speed | Slower | Faster |
| Packet Loss | No | Possible |
| Use Cases | HTTP, HTTPS, SSH, FTP | Gaming, Video Calls, Live Streaming, DNS |

### TCP Working

1. Client sends a connection request.
2. Server accepts the request.
3. Connection is established.
4. Data is transferred safely.

This process is called the **TCP Three-Way Handshake**.

### Real-Time Example

- Online Banking → TCP
- WhatsApp Call → UDP
- YouTube Live Stream → UDP
- Website Browsing → TCP

> 💡 **Remember:** TCP = Accuracy, UDP = Speed.

---

# ☁️ Virtual Private Cloud (VPC)

A **VPC (Virtual Private Cloud)** is your own private network inside AWS.

Before launching EC2 instances or databases, you first create a VPC.

Inside the VPC, you create:
- Public Subnets
- Private Subnets
- Route Tables
- Internet Gateway
- Security Groups

A VPC belongs to one AWS Region.

### Real-Time Example

Suppose a company creates a VPC for its e-commerce application.

- Public Subnet → Web Server
- Private Subnet → Database

Users can access the website, but the database remains private.

> 💡 **Remember:** VPC = Your own private network inside AWS.

---

# 🌐 Private IP Address Ranges

AWS recommends using private IP ranges while creating a VPC.

| Private IP Range | Purpose |
|------------------|---------|
| 10.0.0.0/8 | Large Networks |
| 172.16.0.0/12 | Medium Networks |
| 192.168.0.0/16 | Small Networks |

These IP addresses are not directly accessible from the Internet.

---

# 📘 CIDR (Classless Inter-Domain Routing)

CIDR defines the size of a network.

Example:

```
10.0.0.0/24
```

- `10.0.0.0` → Network Address
- `/24` → Network Mask

### CIDR Formula

```
Total IPs = 2^(32 - CIDR)
```

### Common CIDR Blocks

| CIDR | Total IPs | Usable IPs (AWS) |
|------|-----------|------------------|
| /16 | 65,536 | 65,531 |
| /24 | 256 | 251 |
| /26 | 64 | 59 |
| /28 | 16 | 11 |

> AWS reserves **5 IP addresses** in every subnet.

---

# 🌐 AWS Reserved IP Addresses

AWS automatically reserves five IP addresses in every subnet.

| Reserved IP | Purpose |
|-------------|---------|
| .0 | Network Address |
| .1 | VPC Router |
| .2 | DNS Server |
| .3 | Reserved by AWS |
| Last IP | Broadcast (Reserved) |

Example:

```
10.0.0.0/24

Total IPs = 256

Usable = 251
```

---

# 📘 Subnet Sizing

Subnets divide a VPC into smaller networks.

| CIDR | Number of Subnets | IPs per Subnet |
|------|-------------------|----------------|
| /25 | 2 | 128 |
| /26 | 4 | 64 |
| /27 | 8 | 32 |

### Important Rule

Subnet CIDR must always be inside the VPC CIDR.

Example:

| VPC | Valid Subnet | Invalid Subnet |
|-----|--------------|----------------|
| 10.0.0.0/24 | 10.0.0.0/26 ✅ | 10.0.0.0/23 ❌ |

Subnets inside the same VPC communicate through the **Local Route** automatically.

---

# 🏗️ Best Practice VPC Design

```
VPC
10.0.0.0/16
│
├── Public Subnet (10.0.0.0/24)
│      ├── EC2
│      └── Load Balancer
│
└── Private Subnet (10.0.1.0/24)
       ├── Database
       └── Backend Servers
```

This design provides better security and is commonly used in production environments.

---

# ✅ What I Practiced

- Created a VPC using CIDR `10.0.0.0/16`
- Created a Public Subnet `10.0.0.0/24`
- Created a Private Subnet `10.0.1.0/24`
- Configured Security Group Rules
  - SSH (22)
  - HTTP (80)
  - HTTPS (443)

---

# 🎯 Interview Questions

### What is a VPC?

A private virtual network inside AWS used to securely host cloud resources.

### Why do we use CIDR?

To define the IP address range of a network.

### Why are 5 IP addresses reserved in AWS?

AWS reserves them for networking purposes such as the router, DNS, and future services.

### Difference between TCP and UDP?

TCP is reliable and connection-oriented, while UDP is faster but connectionless.

### Why should databases be placed in a Private Subnet?

To prevent direct access from the Internet and improve security.

---

# 📋 Quick Revision

| Topic | Key Point |
|--------|-----------|
| Client → Server | Internet + IP + Protocol + TCP/UDP |
| TCP | Reliable communication |
| UDP | Fast communication |
| VPC | Private network inside AWS |
| Private IP | Used inside VPC |
| CIDR | Defines IP address range |
| AWS Reserved IPs | 5 IPs reserved per subnet |
| Public Subnet | Internet accessible |
| Private Subnet | No direct Internet access |

---

# 📝 Summary

- Every client needs an Internet connection, an IP address, a protocol, and TCP/UDP to communicate with a server.
- TCP is reliable and used for websites, banking, and SSH. UDP is faster and used for streaming, gaming, and DNS.
- A VPC is a private network in AWS where cloud resources are deployed securely.
- Private IP ranges are recommended when creating VPCs.
- CIDR defines the network size and the number of available IP addresses.
- AWS reserves 5 IP addresses in every subnet.
- Public subnets host internet-facing resources, while private subnets are used for databases and backend servers.
- A well-designed VPC improves security, scalability, and high availability.
