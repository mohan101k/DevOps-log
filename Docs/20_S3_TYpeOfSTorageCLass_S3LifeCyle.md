
# Amazon S3 Bucket

## What is an S3 Bucket?

An **Amazon S3 (Simple Storage Service) Bucket** is a container used to store objects (files) in AWS.

An object consists of:

- File (Image, Video, PDF, Backup, etc.)
- Metadata (Information about the file)
- Unique Key (File name/path)

---

## Real-Time Example

Suppose your company has an e-commerce website.

Users upload:

- 📷 Product Images
- 🎥 Videos
- 📄 PDF Invoices
- 📂 Documents

Instead of storing these files on an EC2 instance, they are stored in an S3 Bucket.

```text
S3 Bucket
│
├── images/
│     ├── phone.jpg
│     ├── laptop.jpg
│
├── invoices/
│     ├── inv001.pdf
│
└── videos/
      └── demo.mp4
```

---

## Benefits

- Highly Durable (99.999999999% or 11 nines)
- Highly Available
- Scalable
- Secure (IAM, Bucket Policies, Encryption)
- Cost Effective

---

# Types of S3 Storage Classes

AWS provides different storage classes based on how frequently your data is accessed.

| Storage Class | Access Frequency | Cost | Real-Time Example |
|---------------|------------------|------|-------------------|
| S3 Standard | Frequently accessed | High | Website images, application files |
| S3 Intelligent-Tiering | Unknown access pattern | Medium | Business documents with unpredictable usage |
| S3 Standard-IA (Infrequent Access) | Rarely accessed | Lower | Monthly reports |
| S3 One Zone-IA | Rarely accessed, stored in one AZ | Lower | Backup that can be recreated |
| S3 Glacier Instant Retrieval | Rare access but needs milliseconds retrieval | Very Low | Medical records |
| S3 Glacier Flexible Retrieval | Archive data | Very Low | Old backups |
| S3 Glacier Deep Archive | Very rarely accessed | Lowest | Legal records, 7–10 year archives |

---

## 1. S3 Standard

- Frequently accessed data
- Low latency
- Stored across multiple Availability Zones
- Highest availability

### Example

Website images accessed every day.

---

## 2. S3 Intelligent-Tiering

AWS automatically moves data between frequent and infrequent tiers based on access.

### Example

Employee documents.

Some files are opened daily, while others may not be accessed for months.

---

## 3. S3 Standard-IA

- Less frequent access
- Lower storage cost
- Retrieval charges apply

### Example

Monthly project reports.

---

## 4. One Zone-IA

- Stored in only one Availability Zone
- Cheaper than Standard-IA
- Not suitable for critical data

### Example

Temporary backup files.

---

## 5. Glacier Instant Retrieval

- Archive storage
- Millisecond retrieval
- Low storage cost

### Example

Medical records that are rarely viewed but must be available immediately.

---

## 6. Glacier Flexible Retrieval

- Archive storage
- Retrieval takes minutes to hours

### Example

Old database backups.

---

## 7. Glacier Deep Archive

- Cheapest storage
- Retrieval may take several hours

### Example

Tax records kept for 10 years.

---

# Simple Memory Trick

```text
Frequently Used
      ↓
S3 Standard

Unknown Pattern
      ↓
Intelligent-Tiering

Rare Access
      ↓
Standard-IA

Rare + Single AZ
      ↓
One Zone-IA

Archive + Fast Retrieval
      ↓
Glacier Instant

Archive
      ↓
Glacier Flexible

Very Old Archive
      ↓
Deep Archive
```

---

# S3 Lifecycle

## What is Lifecycle?

An **S3 Lifecycle** is a set of rules that automatically moves or deletes objects after a specified number of days.

This helps reduce storage costs without manual work.

---

## Why Use Lifecycle?

Suppose your company stores:

- Daily logs
- User uploads
- Database backups

Initially, everything is stored in **S3 Standard**.

After some time, old files are rarely accessed.

Instead of paying the higher Standard storage cost forever, AWS can automatically move them to cheaper storage classes.

---

## Example Lifecycle Policy

```text
Day 0
↓
S3 Standard

After 30 Days
↓
S3 Standard-IA

After 90 Days
↓
Glacier Flexible Retrieval

After 365 Days
↓
Delete Object
```

---

## Real-Time Scenario

A company stores CCTV recordings.

- First 30 days → Frequently accessed → S3 Standard
- After 30 days → Rarely accessed → Standard-IA
- After 90 days → Archived → Glacier
- After 1 year → Automatically deleted

No manual intervention is needed.

---

## Lifecycle Flow Diagram

```text
Upload File
      │
      ▼
S3 Standard
      │
 30 Days
      ▼
S3 Standard-IA
      │
 90 Days
      ▼
Glacier Flexible Retrieval
      │
365 Days
      ▼
Delete Automatically
```

---

## Advantages of Lifecycle

- Automatically moves files to cheaper storage
- Reduces AWS costs
- No manual management
- Supports automatic deletion
- Ideal for backups, logs, reports, and archives
