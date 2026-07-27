<img width="1536" height="1024" alt="ASG" src="https://github.com/user-attachments/assets/050e2f2a-a945-417e-a1a1-1f2729602842" />

STEPS FOR ASG

1. Create VPC
        ↓
2. Create Internet Gateway (IGW)
        ↓
3. Attach IGW to VPC
        ↓
4. Create Public Subnets (2 AZs)
        ↓
5. Create Private Subnets (2 AZs)
        ↓
6. Create Route Tables
        ↓
7. Configure Routes
        ↓
8. Create NAT Gateway
        ↓
9. Associate Route Tables
        ↓
10. Create Security Groups
        ↓
11. Launch Bastion Host (Optional)
        ↓
12. Launch Application EC2
        ↓
13. Install Application (Nginx/Apache)
        ↓
14. Create Custom AMI
        ↓
15. Create Target Group
        ↓
16. Create Application Load Balancer (ALB)
        ↓
17. Test ALB
        ↓
18. Create Launch Template
        ↓
19. Create Auto Scaling Group
        ↓
20. Attach Target Group
        ↓
21. Select Private Subnets
        ↓
22. Configure Desired / Min / Max Capacity
        ↓
23. Configure Scaling Policy
        ↓
24. Create ASG
        ↓
25. Test Auto Scaling using Stress Tool
        ↓
26. Verify New EC2 Created
        ↓
27. Verify EC2 Registered in Target Group
        ↓
28. Verify Traffic Through ALB
