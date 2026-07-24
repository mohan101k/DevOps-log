<img width="1536" height="1024" alt="ChatGPT Image Jul 24, 2026, 12_45_07 PM" src="https://github.com/user-attachments/assets/ae002e02-73ca-4268-a640-311906de0a17" />

<img width="596" height="432" alt="image" src="https://github.com/user-attachments/assets/66bd5650-02fc-4c89-9fa0-61e04104a755" />


# AWS Path-Based Routing - End-to-End Steps

1. Create VPC
2. Create Internet Gateway (IGW)
3. Attach IGW to VPC
4. Create 2 Public Subnets (Different AZs)
5. Enable Auto Assign Public IP
6. Create Route Table
7. Add Route: 0.0.0.0/0 → Internet Gateway
8. Associate Route Table with Public Subnets
9. Create Security Group (22, 80, 443)
10. Launch 4 EC2 Instances
    - Home
    - AWS
    - Azure
    - GCP
11. Install Nginx on all EC2 instances
12. Change `index.html` on each server
13. Test using `curl http://localhost`
14. Create 4 Target Groups
    - home-tg
    - aws-tg
    - azure-tg
    - gcp-tg
15. Register EC2 Instances in their Target Groups
16. Verify all Targets are Healthy
17. Create Application Load Balancer (ALB)
18. Select VPC and Public Subnets
19. Attach Security Group
20. Create HTTP Listener (Port 80)
21. Set Default Action → home-tg
22. Open **Listeners → Manage Rules**
23. Add Path Rules
    - `/aws/*` → aws-tg
    - `/azure/*` → azure-tg
    - `/gcp/*` → gcp-tg
24. Save Rules
25. Copy ALB DNS Name
26. Test
    - `http://ALB-DNS/`
    - `http://ALB-DNS/aws`
    - `http://ALB-DNS/azure`
    - `http://ALB-DNS/gcp`

## Architecture

Internet
↓
Application Load Balancer
↓
Listener (HTTP:80)
↓
Listener Rules
↓
Target Groups
↓
EC2 Instances (Nginx)
