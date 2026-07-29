# ⚡ AWS Network Load Balancer (NLB)

## 📌 Overview

Network Load Balancer (NLB) is a Layer 4 Load Balancer that routes traffic based on TCP, UDP, and TLS protocols.

It is designed for extremely high performance, ultra-low latency, and millions of requests per second.

---

# 🏗️ Architecture

```text
Client
   │
   ▼
Network Load Balancer
   │
Target Group
   │
EC2 Instances
```

---

# 📚 OSI Layer

```
Layer 7 → Application
Layer 6 → Presentation
Layer 5 → Session
Layer 4 → Transport  ← NLB
Layer 3 → Network
Layer 2 → Data Link
Layer 1 → Physical
```

---

# 🔹 Supported Protocols

- TCP
- UDP
- TLS

---

# 🚀 Features

- Layer 4 Load Balancer
- Static IP Support
- Elastic IP Support
- Ultra Low Latency
- High Throughput
- Millions of Requests per Second
- Preserves Client Source IP
- TLS Termination
- Supports Cross-Zone Load Balancing

---

# 🎯 Use Cases

NLB is suitable for:

- Gaming Servers
- Financial Applications
- Messaging Systems
- IoT Applications
- Database Connections
- SMTP Servers
- FTP Servers
- Real-Time Applications

---

# 🔄 Traffic Flow

```
Client
   │
TCP / UDP / TLS
   │
Network Load Balancer
   │
Target Group
   │
EC2 Instances
```

---

# ⚙️ Target Group

The Target Group contains backend servers.

Responsibilities:

- Register EC2 Instances
- Health Checks
- Route Traffic
- Remove Unhealthy Instances

---

# 📈 Advantages

- Extremely Fast
- Low Latency
- High Availability
- High Throughput
- Static IP
- Elastic IP Support
- Millions of Connections
- Source IP Preservation

---

# ❌ Limitations

NLB does NOT support:

- Path-Based Routing
- Host-Based Routing
- Header-Based Routing
- AWS WAF Integration
- URL Redirects
- Cookie-Based Routing

---

# 🆚 NLB vs ALB

| Feature | NLB | ALB |
|----------|-----|-----|
| Layer | Layer 4 | Layer 7 |
| Protocol | TCP, UDP, TLS | HTTP, HTTPS |
| Static/elastic IP | ✅ | ❌ |
| Path Routing | ❌ | ✅ |
| Host Routing | ❌ | ✅ |
| WAF Support | ❌ | ✅ |
| Source IP | Preserved | Not Preserved |
| Performance | Very High | High |
| Latency | Very Low | Low |

---

# 🔥 NLB + ALB Integration

Sometimes both Load Balancers are used together.

## Architecture

```text
                Client
                  │
                  ▼
       Network Load Balancer
        (Static IP / Layer 4)
                  │
                  ▼
    Application Load Balancer
      (Layer 7 Routing Rules)
                  │
          ┌───────┴────────┐
          ▼                ▼
      Target Group     Target Group
          │                │
         EC2              EC2
```

---

# Why Combine NLB and ALB?

NLB provides:

- Static IP
- High Performance
- Low Latency

ALB provides:

- Path-Based Routing
- Host-Based Routing
- SSL Termination
- Authentication
- Advanced HTTP Features

Together they provide the benefits of both.

---

# 📌 Traffic Flow

```
Client
   │
TCP / TLS
   │
NLB
   │
TCP / TLS
   │
ALB
   │
HTTP / HTTPS
   │
Target Group
   │
EC2
```

---

# 📊 Benefits

- High Performance
- Static IP Support
- Millions of Requests
- Low Latency
- Advanced Routing
- High Availability
- Fault Tolerance
- Easy Scaling

---

# 🎯 Learning Outcome

After completing this project, you will understand:

- Network Load Balancer
- Layer 4 Routing
- TCP, UDP, TLS
- Static IP
- Source IP Preservation
- Target Groups
- Health Checks
- NLB + ALB Architecture
