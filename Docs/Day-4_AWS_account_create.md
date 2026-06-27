
# DevOps Day 4 – AWS Account Creation,Plural Sight , Regions & Availability Zones 

> **Topics Covered**
>
> - AWS Account Creation
> - AWS Global Infrastructure
> - AWS Regions
> - Availability Zones (AZ)
> - Benefits of Multiple Availability Zones

---

# 📌 What is AWS?

**AWS (Amazon Web Services)** is a cloud computing platform provided by Amazon that offers services such as computing, storage, networking, databases, security, AI, and many more on a pay-as-you-go basis.

---

# 📌 AWS Account Creation

To use AWS services, you first need an AWS account.

## Steps

1. Visit **https://aws.amazon.com/**
2. Click **Create an AWS Account**
3. Enter
   - Email Address
   - Password
   - AWS Account Name
4. Verify your email.
5. Add contact information.
6. Enter payment details (Credit/Debit Card).
7. Verify your phone number using OTP.
8. Select the **Free Tier Plan**.
9. Complete registration.
10. Login to the AWS Management Console.

---

# 📌 AWS Free Tier

AWS provides a **12-month Free Tier** for new users.

It allows you to use selected services with limited usage without additional charges.

Examples:
- EC2
- S3
- RDS
- Lambda
- DynamoDB

Always monitor usage to avoid unexpected charges.

---

# 📌 AWS Global Infrastructure

AWS infrastructure is divided into:

```
Global Infrastructure
        │
        ├── Regions
        │
        ├── Availability Zones
        │
        └── Edge Locations
```

---

# 📌 AWS Region

A **Region** is a physical geographic location where AWS has one or more data centers.

Each region is completely independent.

Examples:

- Mumbai (ap-south-1)
- Hyderabad (ap-south-2)
- Singapore (ap-southeast-1)
- London (eu-west-2)
- Virginia (us-east-1)

---

# 📌 Why Multiple Regions?

- Low latency
- Disaster Recovery
- Compliance requirements
- High Availability
- Global application deployment

---

# 📌 Availability Zone (AZ)

An **Availability Zone (AZ)** is one or more isolated data centers within a region.

Each AZ has:
- Independent Power
- Independent Cooling
- Independent Networking

Example:

```
Region (Mumbai)

├── AZ-A
├── AZ-B
└── AZ-C
```

If one AZ fails, applications running in another AZ continue to work.

---

# 📌 Region vs Availability Zone

| Region | Availability Zone |
|---------|-------------------|
| Geographic Area | Data Center(s) inside a Region |
| Example: Mumbai | Mumbai AZ-1, AZ-2, AZ-3 |
| Independent Location | Connected with High-Speed Network |

---

# 📌 Benefits of Availability Zones

- High Availability
- Fault Tolerance
- Disaster Recovery
- Low Latency
- Better Reliability

---

# 📌 Example

Suppose your application is deployed:

```
Mumbai Region

AZ-1
│
├── Web Server

AZ-2
│
├── Database

AZ-3
│
└── Backup Server
```

If **AZ-1** goes down, the application can continue running from other Availability Zones.

---

# 📌 Key Points

- AWS is Amazon's cloud platform.
- Create an AWS account before using services.
- AWS provides a Free Tier for beginners.
- A Region is a geographic location.
- An Availability Zone is an isolated data center inside a Region.
- Multiple AZs improve availability and fault tolerance.

---

# 📚 Summary

- AWS Account Creation
- AWS Free Tier
- AWS Global Infrastructure
- Regions
- Availability Zones
- Region vs AZ
- High Availability Concept
- Disaster Recovery Basics

---

# 🎯 Interview Questions

### 1. What is AWS?
Amazon Web Services is a cloud computing platform that provides various cloud services.

### 2. What is an AWS Region?
A physical geographic location containing one or more Availability Zones.

### 3. What is an Availability Zone?
An isolated data center (or group of data centers) within an AWS Region.

### 4. Why are multiple Availability Zones used?
To provide high availability and fault tolerance.

### 5. What is the AWS Free Tier?
A limited free usage plan available to new AWS customers for eligible services.

# DevOps Day 4 – Pluralsight

> **Topic Covered**
>
> - Introduction to Pluralsight

---

# 📌 What is Pluralsight?

**Pluralsight** is an online learning platform that provides professional courses in:

- Cloud Computing
- DevOps
- AWS
- Azure
- Docker
- Kubernetes
- Linux
- Python
- Java
- Cybersecurity
- AI & Machine Learning

It is widely used by students, professionals, and companies to improve technical skills.

---

# 📌 Why Use Pluralsight?

- High-quality video courses
- Hands-on learning
- Skill assessments
- Learning paths
- Expert instructors
- Certification preparation

---

# 📌 Benefits

- Learn at your own pace
- Industry-relevant content
- Regularly updated courses
- Beginner to advanced learning paths
- Practical demonstrations and labs

---

# 📚 Summary

- Pluralsight is an online technical learning platform.
- It offers courses on Cloud, DevOps, Programming, and IT.
- It helps learners prepare for certifications and improve practical skills.
