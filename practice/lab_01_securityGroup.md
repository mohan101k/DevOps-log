# 🌐 AWS EC2 ──▶ Security Groups ──▶ Inbound/Outbound Rules ──▶ Terminal Connectivity & Nginx Testing
### *A Comprehensive Guide to Building, Isolating, and Troubleshooting a Secure Web Server in AWS*

---

## 🎯 Project Overview & Purpose
Jab hum Cloud Computing ya DevOps seekhna shuru karte hain, toh theory aur actual AWS infrastructure par hands-on deployment karna bilkul alag baat hai. 

**Is project ka main purpose yeh hai:**
1. Ek real-world cloud architecture par **hands-on practical exposure** mil sake.
2. **AWS EC2 (Elastic Compute Cloud)** ka network configurations ke sath initialization seekhna.
3. **Security Groups (Firewalls)** ke Inbound aur Outbound rules ke logical behavior ko practically test aur crack karna.
4. Cloud infrastructure mein aane wale regular real-time errors (jaise **SSH connection failures** aur **HTTP Connection Timeouts**) ko systematic tarike se troubleshoot karna seekhna.

Agar aap ya aapka koi bhi dost cloud engineering zero se shuru kar raha hai, toh yeh step-by-step document aapko basic EC2 setup se lekar advanced "Stateful" firewall properties tak sab kuch perfectly clear kar dega!

---

## 🏗️ Technical Architecture Diagram

```text
[ INTERNET (Public Traffic) ] ──▶ Port 80 (HTTP Allowed) ──▶ [ AWS Cloud Firewall ]
                                                             │ (Security Group)
[ YOUR LAPTOP / AWS SERVICE ] ──▶ Port 22 (SSH Allowed) ───▶ │ 
                                                             ▼
                                                    ┌─────────────────┐
                                                    │   EC2 Instance  │
                                                    │  (Ubuntu OS +   │
                                                    │  Nginx Server)  │
                                                    └─────────────────┘
