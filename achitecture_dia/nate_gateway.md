<img width="881" height="615" alt="image" src="https://github.com/user-attachments/assets/84e3e556-338a-4473-a13f-3a09060a3e38" />

1. Create VPC
        ↓
2. Create Public Subnet
        ↓
3. Create Private Subnet
        ↓
4. Create Internet Gateway
        ↓
5. Attach Internet Gateway to VPC
        ↓
6. Create Elastic IP
        ↓
7. Create NAT Gateway (Public Subnet)
        ↓
8. Create Public Route Table
        ↓
9. Add Route (0.0.0.0/0 → Internet Gateway)
        ↓
10. Associate Public Route Table with Public Subnet
        ↓
11. Create Private Route Table
        ↓
12. Add Route (0.0.0.0/0 → NAT Gateway)
        ↓
13. Associate Private Route Table with Private Subnet
        ↓
14. Create Security Groups
        ↓
15. Launch Bastion EC2 (Public)
        ↓
16. Launch App EC2 (Private)
        ↓
17. SSH → Bastion
        ↓
18. SSH → Private EC2
        ↓
19. Install Application
        ↓
20. Create Target Group
        ↓
21. Create Load Balancer
        ↓
22. Test Application
