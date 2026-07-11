## 📚 Concepts Covered

- What is a Security Group (Firewall in AWS)
- Inbound vs Outbound Rules
- Ports and their importance
- Default Security Group behavior
- SSH and RDP access
- Network Protocols
- Linux Firewall & Networking Commands
- Installing and Managing Nginx

---

## 📑 Table of Contents

- [Security Group (SG)](#-security-group-sg)
- [Security Group Rules](#-security-group-rules)
- [Inbound vs Outbound](#-inbound-vs-outbound)
- [Ports](#-ports)
- [Common Ports](#-common-ports)
- [Protocols](#-protocols)
- [Firewall](#-firewall)
- [Security Group Rule Examples](#-security-group-rule-examples)
- [Security Best Practices](#-security-best-practices)
- [Linux Commands](#-linux-commands)
- [HTTP vs HTTPS](#-http-vs-https)
- [Real-Time Example](#-real-time-example)
- [Interview Questions](#-interview-questions)
- [Next Steps](#-next-steps)

---

# 🛡️ Security Group (SG)

A **Security Group (SG)** is a **virtual firewall** in AWS that controls incoming and outgoing traffic for an EC2 instance.

### Key Points

- Works at the **EC2 Instance Level**
- Stateful Firewall
- Allows only authorized traffic
- Every EC2 instance must have at least one Security Group
- Controls both Inbound and Outbound traffic

---

# 📋 Security Group Rules

Every Security Group rule consists of:

| Field | Description |
|--------|-------------|
| Source | Where traffic is coming from |
| Protocol | Type of communication (TCP, UDP, ICMP, etc.) |
| Port Range | Which application port is allowed |
| Destination | Where traffic is going |

---

# 🔄 Inbound vs Outbound

| Feature | Inbound | Outbound |
|----------|----------|-----------|
| Direction | Internet → Server | Server → Internet |
| Controls | Incoming Traffic | Outgoing Traffic |
| Default Rule | DENY ALL | ALLOW ALL |
| Purpose | Protect Server | Allow server communication |

> AWS Security Groups are **Stateful**, meaning if inbound traffic is allowed, the response traffic is automatically allowed.

---

# 🚪 Ports

A **Port** is a logical communication endpoint used by applications.

Example:

```text
Server IP : 54.201.10.20

Port 22   → SSH
Port 80   → Nginx Website
Port 443  → HTTPS Website
Port 3306 → MySQL
```

### Port Range

```
0 - 65535
```

A server can run multiple applications using different ports.

---

# 🌐 Common Ports

| Port | Protocol | Purpose |
|------|----------|----------|
| 22 | SSH | Linux Remote Login |
| 80 | HTTP | Website |
| 443 | HTTPS | Secure Website |
| 3389 | RDP | Windows Remote Desktop |
| 21 | FTP | File Transfer |
| 53 | DNS | Domain Name Resolution |
| 3306 | MySQL | Database |
| 5432 | PostgreSQL | Database |

---

# 🌍 Protocols

A **Protocol** is a set of rules that defines how data is transmitted over a network.

| Protocol | Full Form | Default Port | Usage |
|----------|-----------|-------------|-------|
| TCP | Transmission Control Protocol | Varies | Reliable communication |
| UDP | User Datagram Protocol | Varies | Fast communication |
| HTTP | HyperText Transfer Protocol | 80 | Web Browsing |
| HTTPS | HyperText Transfer Protocol Secure | 443 | Secure Web Browsing |
| SSH | Secure Shell | 22 | Secure Linux Login |
| RDP | Remote Desktop Protocol | 3389 | Windows Remote Login |
| FTP | File Transfer Protocol | 21 | File Transfer |
| DNS | Domain Name System | 53 | Domain Resolution |

---

# 🔥 Firewall

A **Firewall** protects a system by allowing or blocking network traffic based on predefined rules.

## Types

- Host Firewall
- Network Firewall
- Cloud Firewall (AWS Security Group)

AWS Security Group acts as a **Virtual Firewall**.

---

# 📌 Security Group Rule Examples

| Rule | Meaning |
|------|---------|
| 0.0.0.0/0 → Port 80 | Allow HTTP from anywhere |
| 0.0.0.0/0 → Port 443 | Allow HTTPS from anywhere |
| Your_IP/32 → Port 22 | Allow SSH only from your system |
| 0.0.0.0/0 → All Ports | Dangerous (Never use in Production) |

---

# ✅ Security Best Practices

- Never open Port 22 to everyone.
- Allow SSH only from your IP address.
- Open only required ports.
- Close unused ports.
- Use HTTPS instead of HTTP.
- Follow the Principle of Least Privilege.

---

# 💻 Linux Commands

## Install Nginx

```bash
yum install nginx -y
```

Installs the Nginx web server.

---

## Start Nginx

```bash
systemctl start nginx
```

Starts the Nginx service.

---

## Stop Nginx

```bash
systemctl stop nginx
```

Stops the service.

---

## Restart Nginx

```bash
systemctl restart nginx
```

Restarts the service.

---

## Enable Nginx on Boot

```bash
systemctl enable nginx
```

Automatically starts Nginx after every reboot.

---

## Check Nginx Status

```bash
systemctl status nginx
```

Displays the current status of Nginx.

---

## Check Running Processes

```bash
ps -ef | grep nginx
```

Example Output

```text
root      1156     1  nginx: master process
nginx     1157  1156 nginx: worker process
```

---

## Check Listening Ports

```bash
ss -tuln
```

### Options

| Option | Meaning |
|---------|----------|
| -t | TCP Connections |
| -u | UDP Connections |
| -l | Listening Ports |
| -n | Numeric Port Numbers |

Example Output

```text
Netid State  Local Address:Port

tcp   LISTEN      0.0.0.0:22
tcp   LISTEN      0.0.0.0:80
```

---

## Test Website

```bash
curl http://localhost
```

or

```bash
curl http://<Public-IP>
```

---

# 🌐 HTTP vs HTTPS

| Feature | HTTP | HTTPS |
|----------|------|--------|
| Port | 80 | 443 |
| Encryption | ❌ No | ✅ Yes |
| SSL Certificate | No | Yes |
| Secure | No | Yes |
| Used In | Testing | Production |

---

# 💡 Real-Time Example

You launch an EC2 instance.

1. Install Nginx.

```bash
yum install nginx -y
```

2. Start the service.

```bash
systemctl start nginx
```

3. Verify Nginx is running.

```bash
ps -ef | grep nginx
```

4. Check that Port 80 is listening.

```bash
ss -tuln
```

Output:

```text
tcp LISTEN 0.0.0.0:80
```

5. Open **Port 80 (HTTP)** in the AWS Security Group.

6. Visit:

```
http://<EC2-Public-IP>
```

You should now see the **Nginx Welcome Page**.

---

# 🎯 Interview Questions

### Basic

- What is a Security Group?
- Why is Security Group called a Stateful Firewall?
- What is the difference between Inbound and Outbound Rules?
- What is a Port?
- What is a Protocol?
- Difference between TCP and UDP?
- Why is Port 22 used?
- Why is Port 443 preferred over Port 80?
- What does `0.0.0.0/0` mean?
- What does `/32` represent?

### Linux Commands

- What does `ss -tuln` do?
- How do you check whether Nginx is running?
- Difference between `systemctl start` and `systemctl enable`?
- How do you restart Nginx?
- How do you check listening ports?

---

# 📚 Key Takeaways

- Security Groups are AWS Virtual Firewalls.
- Security Groups are Stateful.
- Ports identify applications.
- Protocols define communication rules.
- HTTP uses Port 80.
- HTTPS uses Port 443.
- SSH uses Port 22.
- `ss -tuln` shows listening ports.
- `ps -ef | grep nginx` checks running Nginx processes.
- Open only required ports for better security.

---

# ⏭️ Next Steps

- Learn **Network ACL (NACL)**
- Understand **Stateful vs Stateless Firewalls**
- Learn **CIDR and IP Addressing**
- Practice configuring Security Groups in AWS
