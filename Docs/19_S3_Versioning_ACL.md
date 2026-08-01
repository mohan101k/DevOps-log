# Day 19 — Amazon S3 Deep Dive
**Date:** May 8, 2026  
**Course:** DevOps with AWS

---

# 📚 Concepts Covered

- Introduction to Amazon S3
- Object Storage
- Bucket Naming Rules
- Buckets
- Objects
- Object Keys
- Object URLs
- Pre-Signed URLs
- S3 Select
- Amazon Athena
- Versioning
- ACL (Access Control List)
- Bucket Policies
- Static Website Hosting
- S3 vs EC2 Hosting
- CloudFront Introduction
- High Availability
- Best Practices
- Interview Questions

---

# 📑 Contents

- Introduction to Amazon S3
- Why S3?
- Object Storage
- Bucket
- Object
- Object Key
- Object URL
- Bucket Naming Rules
- Pre-Signed URL
- S3 Select
- Amazon Athena
- Versioning
- ACL
- Static Website Hosting
- CloudFront
- High Availability
- Architecture
- Practical Tasks
- Interview Questions
- Summary

---

# 🧠 Theory Notes

# What is Amazon S3?

Amazon S3 (Simple Storage Service) is AWS's Object Storage Service that allows users to store and retrieve any amount of data over the internet.

Unlike Amazon EC2, S3 is **not a server**. It is a managed storage service designed for storing files such as:

- Images
- Videos
- PDFs
- Backups
- Application Logs
- Static Website Files
- Documents

Amazon S3 is one of the oldest and most widely used AWS services because it offers:

- High Durability
- High Availability
- Unlimited Scalability
- Security
- Low Cost

---

# Why Do We Need Amazon S3?

Imagine you own an E-Commerce application.

Every customer uploads:

- Product Images
- Product Videos
- Invoices
- Bills

Should these files be stored inside an EC2 server?

**No.**

Because:

- EC2 storage is limited.
- Storage becomes expensive.
- If the EC2 instance is deleted, data can be lost.
- Scaling storage is difficult.

Instead, applications store files inside Amazon S3 while EC2 handles only the application logic.

---

# Real-Time Example

```
Customer Uploads Image
        │
        ▼
Application (EC2)
        │
        ▼
Amazon S3 Bucket
        │
        ▼
Image Stored Successfully
```

Companies using S3:

- Netflix
- Amazon
- Flipkart
- Instagram
- WhatsApp
- Spotify

Almost every cloud-native company stores files inside Object Storage rather than EC2.

---

# Object Storage

Amazon S3 is an **Object Storage Service**.

Every uploaded file is called an **Object**.

Each Object contains:

```
Object
   │
   ├── Data
   ├── Metadata
   └── Object Key
```

### Data

Actual file

Examples

- photo.png
- resume.pdf
- video.mp4

### Metadata

Information about the object

Example

- File Size
- Upload Date
- Owner
- Storage Class
- Content Type

### Object Key

The complete path of the object inside the bucket.

Example

```
images/profile.png

documents/resume.pdf

videos/demo.mp4
```

Every object must have a unique key.

---

# Bucket

A Bucket is a logical container used to store objects.

Think of it as a folder in the cloud.

Example:

```
company-data

employee-documents

application-backups
```

Inside a bucket you can create folders like:

```
company-data

│

├── images

├── videos

├── documents

└── backups
```

Although folders are shown in the AWS Console, Amazon S3 actually stores objects using prefixes (object keys).

---

# Bucket Naming Rules

Bucket names are globally unique.

That means:

If someone in the world already owns

```
my-company-bucket
```

You cannot create another bucket with the same name.

---

## Rules

- Bucket name must be unique globally.
- Only lowercase letters allowed.
- Numbers are allowed.
- Hyphen (-) allowed.
- No spaces.
- No uppercase letters.
- Cannot rename a bucket after creation.

Example:

✅ Correct

```
mohan-devops-bucket

company-backup-2026

aws-project-storage
```

❌ Wrong

```
MyBucket

Company Bucket

ABC_BUCKET
```

---

# Why Bucket Names Must Be Globally Unique?

Every bucket has its own URL.

Example:

```
https://mohan-devops-bucket.s3.amazonaws.com
```

AWS routes requests based on the bucket name.

If two buckets had the same name, AWS would not know where to send the request.

---

# Object

Every file uploaded into Amazon S3 is called an Object.

Examples:

```
resume.pdf

photo.png

movie.mp4

backup.zip
```

There is no limit on the number of objects inside a bucket.

---

# Object Key

The Object Key is the complete path of an object inside a bucket.

Example

```
documents/resume.pdf

images/profile.png

videos/trailer.mp4
```

Each Object Key must be unique inside its bucket.

---

# Object URL

Every object stored inside Amazon S3 has its own URL.

Example

```
https://mohan-devops-bucket.s3.amazonaws.com/images/profile.png
```

If the object is public,

anyone can access it using this URL.

If the object is private,

AWS returns:

```
Access Denied
```

---

# Difference Between Object Key and Object URL

| Object Key | Object URL |
|------------|------------|
| Internal path of the object | Complete URL to access the object |
| Example: images/photo.png | https://bucket.s3.amazonaws.com/images/photo.png |
| Used inside S3 | Used by browsers and applications |

---

# Quick Revision

| Topic | Meaning |
|--------|---------|
| S3 | Object Storage Service |
| Bucket | Container for Objects |
| Object | Stored File |
| Metadata | Information about File |
| Object Key | File Path |
| Object URL | Direct URL of Object |
