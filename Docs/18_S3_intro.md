# Day X — Amazon S3 (Simple Storage Service)
**Date:** DD Month YYYY  
**Course:** DevOps with AWS

---

## 📚 Concepts Covered

- Introduction to Amazon S3
- Object Storage
- Buckets & Objects
- S3 Architecture
- Bucket Naming Rules
- Object Keys
- S3 Storage Classes
- Versioning
- Lifecycle Rules
- Static Website Hosting
- Bucket Policies
- IAM & Access Control
- Encryption
- Replication (CRR & SRR)
- Event Notifications
- Transfer Acceleration
- Real-Time Use Cases

---

## 📑 Contents

- [📚 Concepts Covered](#-concepts-covered)
- [🧠 Theory Notes](#-theory-notes)
  - [What is Amazon S3?](#what-is-amazon-s3)
  - [Why Do We Need S3?](#why-do-we-need-s3)
  - [S3 Components](#s3-components)
  - [Bucket](#bucket)
  - [Object](#object)
  - [Object Key](#object-key)
  - [Storage Classes](#storage-classes)
  - [Versioning](#versioning)
  - [Lifecycle Rules](#lifecycle-rules)
  - [Bucket Policies & IAM](#bucket-policies--iam)
  - [Encryption](#encryption)
  - [Static Website Hosting](#static-website-hosting)
  - [Replication](#replication)
  - [Transfer Acceleration](#transfer-acceleration)
  - [Event Notifications](#event-notifications)
- [🏗️ Architecture](#️-architecture)
- [🌍 Real-Time Examples](#-real-time-examples)
- [🎯 Interview Questions](#-interview-questions)
- [📝 Quick Revision](#-quick-revision)
- [📸 Screenshots](#-screenshots)
- [⏭️ Next Topic](#️-next-topic)

---

# 🧠 Theory Notes

## What is Amazon S3?

Amazon S3 (Simple Storage Service) is AWS's Object Storage service used to store and retrieve any amount of data from anywhere over the internet.

Unlike EC2, S3 is designed only for storing files such as images, videos, PDFs, backups, logs, and application assets.

S3 provides:

- Highly Durable
- Highly Available
- Secure
- Infinitely Scalable
- Cost Effective

---

## Why Do We Need S3?

Instead of storing uploaded files inside an EC2 instance, companies store them in S3 because:

- Unlimited storage
- Lower cost
- Better durability
- Easy backup
- High availability
- Easy integration with AWS services

---

## S3 Components

```
Bucket
    │
    ▼
Object
    │
    ▼
Metadata
```

---

## Bucket

A Bucket is the top-level container used to store objects.

Example:

```
company-data

portfolio-images

application-backups
```

### Bucket Naming Rules

- Bucket name must be globally unique.
- Only lowercase letters allowed.
- Numbers are allowed.
- Hyphen (-) allowed.
- No uppercase letters.
- No spaces.

Example:

```
mohan-devops-bucket
```

---

## Object

Every file stored inside S3 is called an Object.

Examples:

```
resume.pdf

profile.jpg

video.mp4

backup.zip
```

---

## Object Key

Every object has a unique path called the Key.

Example:

```
images/profile.jpg

documents/resume.pdf

videos/demo.mp4
```

---

# Storage Classes

AWS provides multiple storage classes based on access frequency.

| Storage Class | Best For |
|--------------|----------|
| Standard | Frequently accessed files |
| Intelligent-Tiering | Automatic cost optimization |
| Standard-IA | Rarely accessed files |
| One Zone-IA | Low-cost storage in one AZ |
| Glacier Instant Retrieval | Archive with seconds retrieval |
| Glacier Flexible Retrieval | Archive with minutes to hours retrieval |
| Glacier Deep Archive | Cheapest long-term storage |

---

## Versioning

Versioning keeps multiple versions of the same object.

Example:

```
resume_v1.pdf

↓

resume_v2.pdf

↓

resume_v3.pdf
```

If someone accidentally deletes or overwrites a file, it can be restored.

---

## Lifecycle Rules

Lifecycle Rules automatically move or delete objects after a certain period.

Example:

```
30 Days

↓

Move to Standard IA

↓

90 Days

↓

Move to Glacier

↓

365 Days

↓

Delete Automatically
```

This helps reduce storage costs.

---

## Bucket Policies & IAM

Access to an S3 bucket can be controlled using:

- IAM Policies
- Bucket Policies
- ACL (Access Control List)

Examples:

Private Bucket

```
Only company employees
```

Public Bucket

```
Static Website
```

---

## Encryption

Amazon S3 supports encryption to protect stored data.

Types:

- SSE-S3
- SSE-KMS
- SSE-C

Encryption protects data at rest.

---

## Static Website Hosting

Amazon S3 can host static websites built with:

- HTML
- CSS
- JavaScript

Example:

```
Portfolio Website

Company Landing Page

Documentation Website
```

No EC2 server is required.

---

## Replication

Replication automatically copies objects.

### Cross Region Replication (CRR)

```
Mumbai

↓

Singapore
```

Used for Disaster Recovery.

### Same Region Replication (SRR)

```
Mumbai Bucket

↓

Another Bucket

Same Region
```

Used for Backup.

---

## Transfer Acceleration

Transfer Acceleration uploads files faster using AWS Edge Locations.

Useful for global users uploading large files.

---

## Event Notifications

S3 can trigger other AWS services whenever an object is uploaded.

Example:

```
User Uploads Image

↓

S3

↓

Lambda Trigger

↓

Resize Image

↓

Store Again
```

---

# 🏗️ Architecture

```
                 Internet
                     │
                     ▼
                 Users
                     │
                     ▼
           Application Load Balancer
                     │
                     ▼
                 EC2 Application
                     │
                     ▼
                Amazon S3 Bucket
                     │
        ┌────────────┴────────────┐
        ▼                         ▼
   Images & Videos           Documents
                     │
                     ▼
                CloudFront CDN
                     │
                     ▼
                  End Users
```

---

# 🌍 Real-Time Examples

### Instagram

```
User Uploads Photo

↓

EC2

↓

Amazon S3
```

---

### Netflix

```
Movies

↓

Amazon S3

↓

CloudFront

↓

Users
```

---

### WhatsApp

```
Images

Videos

Voice Notes

Documents

↓

Amazon S3
```

---

### Company Backup

```
Production Database Backup

↓

Amazon S3

↓

Glacier
```

---

# 🎯 Interview Questions

### Q1. What is Amazon S3?

Amazon S3 is AWS's highly scalable Object Storage service used to store and retrieve data.

---

### Q2. Difference between EC2 and S3?

| EC2 | S3 |
|------|----|
| Compute | Storage |
| Runs Applications | Stores Files |
| Needs Operating System | No OS |
| Limited Storage | Unlimited Storage |

---

### Q3. What is a Bucket?

A logical container used to store objects.

---

### Q4. What is an Object?

A file stored inside an S3 bucket.

---

### Q5. Can we host a website on S3?

Yes.

Only Static Websites.

---

### Q6. Why Versioning?

To recover deleted or overwritten files.

---

### Q7. What is Lifecycle Policy?

Automatically moves or deletes files based on time.

---

### Q8. What is Glacier?

Low-cost archive storage.

---

### Q9. Can S3 execute code?

No.

Only stores objects.

---

# 📝 Quick Revision

| Topic | Key Point |
|--------|-----------|
| Amazon S3 | Object Storage Service |
| Bucket | Stores Objects |
| Object | File |
| Key | Object Path |
| Versioning | Multiple Versions |
| Lifecycle | Automatic File Movement |
| Storage Classes | Cost Optimization |
| Encryption | Data Security |
| Static Website | HTML/CSS/JS Hosting |
| CRR | Cross Region Backup |
| SRR | Same Region Backup |
| CloudFront | Faster Content Delivery |

---

# 📸 Screenshots

- Bucket Creation
- Upload Object
- Versioning Enabled
- Lifecycle Rule
- Static Website Hosting
- Bucket Policy
- CloudFront Integration

---

# ⏭️ Next Topic

- AWS EBS (Elastic Block Store)
- AWS EFS (Elastic File System)
- AWS FSx
- Difference Between S3, EBS & EFS
