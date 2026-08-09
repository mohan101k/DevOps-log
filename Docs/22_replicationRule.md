
🧠 All Topics in One Flow

Ab in sab concepts ko ek company scenario se connect karo:

                  Company Data
                       │
                       ▼
                 S3 Mumbai
                 ap-south-1
                       │
          ┌────────────┴────────────┐
          │                         │
     Multi-AZ                    CRR
    Resilience                     │
          │                         ▼
          │                  S3 Singapore
          │                  ap-southeast-1
          │
          ▼
      S3 Inventory
          │
          ▼
    CSV / Parquet
          │
          ▼
       Athena

Large file:

100 GB Video
     │
     ▼
Multipart Upload
     │
     ▼
S3

Replication:

Mumbai S3
    │
    │ Asynchronous
    ▼
Singapore S3
🎯 Interview Cheat Sheet
Topic	Remember This
CRR	S3 → different AWS Region
SRR	S3 → same AWS Region
S3 Replication	Asynchronous
Default replication direction	One-way
Bidirectional	Configure replication in both directions
Replication prerequisite	Versioning on source & destination
Replication permissions	IAM role
Existing objects	Use S3 Batch Replication
S3 Standard resilience	Multiple AZs
Region-to-region protection	CRR
Inventory	Scheduled object/metadata report
Inventory formats	CSV, ORC, Parquet
Inventory analysis	Athena can query it
Current max object size (2026)	50 TB
Single PUT	Up to 5 GB
Multipart	Up to 50 TB
Multipart advantage	Parallel + failed-part retry
⭐ 5 lines jo definitely yaad rakhna

S3 Standard gives multi-AZ resilience within a Region.

CRR provides an additional copy in another Region.

S3 live replication is asynchronous.

Versioning is required on source and destination for live replication.

As of 2026, S3's maximum individual object size is 50 TB.


# 📦 S3 Deep Dive — Replication, Inventory & Large Object Management

**Topics:** S3 Replication, Synchronous vs Asynchronous Replication, One-Way vs Bidirectional Replication, Versioning, S3 Inventory, Object Size Limits, Multipart Upload, High Availability

---

# 📚 Topics Covered

- S3 Replication
- Cross-Region Replication (CRR)
- Same-Region Replication (SRR)
- Synchronous vs Asynchronous Replication
- One-Way vs Bidirectional Replication
- S3 Replication Prerequisites
- S3 Versioning
- High Availability: AZ vs Region
- S3 Inventory
- S3 Object Size Limits
- Multipart Upload
- S3 Topics Recap
- Interview Questions

---

# 📑 Contents

- [S3 Replication](#s3-replication)
- [Cross-Region Replication](#cross-region-replication-crr)
- [Same-Region Replication](#same-region-replication-srr)
- [Synchronous vs Asynchronous](#synchronous-vs-asynchronous-replication)
- [One-Way vs Bidirectional](#one-way-vs-bidirectional-replication)
- [Replication Prerequisites](#s3-replication-prerequisites)
- [High Availability](#s3-high-availability)
- [S3 Inventory](#s3-inventory)
- [S3 Object Size Limits](#s3-object-size-limits)
- [Multipart Upload](#multipart-upload)
- [Complete Architecture](#complete-s3-architecture)
- [Interview Questions](#interview-questions)
- [Quick Revision](#quick-revision)
- [Summary](#summary)

---

# 🧠 1. S3 Replication

S3 Replication automatically copies objects from one S3 bucket to another bucket.

Basic flow:

```text
Source Bucket
     │
     │ Replication
     ▼
Destination Bucket
```

Replication is useful when a company needs another copy of its data for:

- Disaster recovery
- Compliance
- Regional availability
- Business continuity
- Data processing in another Region

---

# 🌍 2. Cross-Region Replication (CRR)

Cross-Region Replication copies objects from an S3 bucket in one AWS Region to a bucket in another AWS Region.

Example:

```text
             AWS
              │
      ┌───────┴────────┐
      ▼                ▼
  Mumbai             Singapore
 ap-south-1        ap-southeast-1
      │                │
      ▼                ▼
   S3-Bucket  ────►  S3-Bucket
      Source          Destination
```

### Example

A company keeps its primary application data in Mumbai:

```text
ap-south-1
```

For disaster recovery, the company replicates the data to Singapore:

```text
ap-southeast-1
```

If there is a major regional problem in Mumbai, the company can use the replicated data in Singapore as part of its disaster recovery strategy.

### Important

CRR is **asynchronous**.

There can be some delay between the source and destination buckets.

---

# 🌎 3. Same-Region Replication (SRR)

Same-Region Replication copies objects between S3 buckets in the **same AWS Region**.

Example:

```text
Mumbai Region
     │
     ├── Source Bucket
     │
     └── Destination Bucket
```

Both buckets are located in:

```text
ap-south-1
```

### CRR vs SRR

| Feature | CRR | SRR |
|---|---|---|
| Full Name | Cross-Region Replication | Same-Region Replication |
| Regions | Different | Same |
| Example | Mumbai → Singapore | Mumbai → Mumbai |
| Main Use | Disaster Recovery | Compliance / Data Separation |
| Replication | Asynchronous | Asynchronous |

---

# ⚡ 4. Synchronous vs Asynchronous Replication

## Synchronous Replication

In synchronous replication, data is written to multiple locations before the operation is considered complete.

```text
Application
     │
     ├────► Server A
     │
     └────► Server B
              │
              ▼
        Both Complete
```

The advantage is very low replication lag.

The disadvantage is that waiting for multiple destinations can increase latency.

---

# 🔄 Asynchronous Replication

In asynchronous replication, the source operation completes first and the destination copy happens afterward.

```text
Application
     │
     ▼
Source
     │
     │ Background Replication
     ▼
Destination
```

S3 live replication is **asynchronous**.

Therefore:

```text
Upload to Source
       │
       ▼
Source Object Available
       │
       ▼
Replication Happens
       │
       ▼
Destination Object
```

There can be temporary replication delay.

### Interview Point

> S3 Cross-Region Replication is asynchronous, not synchronous.

---

# 🔁 5. One-Way vs Bidirectional Replication

## One-Way Replication

The most basic replication configuration is:

```text
Bucket A
   │
   ▼
Bucket B
```

Objects from Bucket A are replicated to Bucket B.

Replication does not automatically work in the opposite direction.

---

## Bidirectional Replication

Replication can also be configured in both directions.

```text
             ┌───────────────┐
             │               │
             ▼               │
        Bucket B             │
             │               │
             │               │
             └───────────────┘
                  ▲
                  │
               Bucket A
```

Simplified:

```text
Bucket A  ◄────────►  Bucket B
```

This can be useful for certain multi-Region architectures and failover scenarios.

### Important

Bidirectional replication is still **asynchronous**.

It does not mean both buckets become synchronously consistent.

---

# 🔐 6. S3 Replication Prerequisites

Before configuring live S3 replication, understand the main requirements.

## 6.1 Versioning

Versioning must be enabled on:

```text
Source Bucket
      +
Destination Bucket
```

Example:

```text
Source Bucket
Versioning = Enabled
       │
       ▼
Destination Bucket
Versioning = Enabled
```

Versioning allows S3 to keep different versions of objects.

---

# 6.2 IAM Replication Role

S3 needs permission to replicate objects.

An IAM role is used for this purpose.

```text
S3
 │
 ▼
IAM Replication Role
 │
 ▼
Destination Bucket
```

The role provides the required permissions for replication.

---

# 6.3 Replication Rule

You configure a replication rule that defines:

- Source objects
- Destination bucket
- Destination Region
- Storage class if required
- Which objects should be replicated

You can replicate:

```text
All Objects
```

or only objects matching a filter such as a prefix or tag.

---

# 6.4 Existing Objects

Live replication is primarily used for objects created or updated after replication is configured.

For existing objects, AWS provides:

```text
S3 Batch Replication
```

This allows you to replicate objects that already existed before the replication rule was created.

---

# 🛡️ 7. S3 High Availability

S3 provides high durability and availability without requiring us to manually create servers in different Availability Zones.

S3 Standard stores data redundantly across multiple Availability Zones within an AWS Region.

Conceptually:

```text
             S3 Bucket
                 │
        ┌────────┼────────┐
        ▼        ▼        ▼
       AZ-A     AZ-B     AZ-C
```

If one Availability Zone has a problem, S3 can continue serving the data from its redundant infrastructure.

---

# 🌍 AZ Level vs Region Level

This distinction is extremely important.

## AZ-Level Resilience

S3 automatically provides redundancy across multiple Availability Zones within its Region.

```text
Mumbai Region

 ├── AZ-A
 ├── AZ-B
 └── AZ-C
```

This protects against an Availability Zone failure.

---

## Region-Level Resilience

Multiple AZs inside Mumbai do **not** mean your data automatically exists in Singapore.

For another Region, you need replication:

```text
Mumbai
  │
  │ CRR
  ▼
Singapore
```

### Remember

> **Multiple AZs = Same-Region resilience**

> **CRR = Cross-Region resilience**

---

# 📊 8. S3 Inventory

S3 Inventory provides a scheduled report containing information about objects stored in an S3 bucket.

Imagine a company has:

```text
10 Million Objects
```

Manually checking every object is not practical.

S3 Inventory can generate a report.

```text
S3 Bucket
    │
    ▼
S3 Inventory
    │
    ▼
Report
```

---

# 📋 Information Available in Inventory

Depending on configuration, inventory can contain information such as:

- Object key
- Object size
- Storage class
- Encryption status
- Version information
- Replication status
- Last modified information

---

# 📁 Inventory Output Formats

S3 Inventory reports can be generated in formats such as:

```text
CSV
ORC
Parquet
```

These reports can be stored in another S3 bucket.

---

# ⏰ Inventory Frequency

Inventory reports can be configured on a scheduled basis such as:

```text
Daily
```

or

```text
Weekly
```

It is therefore useful for reporting and auditing rather than real-time object monitoring.

---

# 🔎 S3 Inventory + Athena

Inventory data can be analyzed using Amazon Athena.

Architecture:

```text
S3 Bucket
    │
    ▼
S3 Inventory
    │
    ▼
CSV / Parquet
    │
    ▼
Amazon Athena
    │
    ▼
SQL Query
```

Example use case:

> "Find all objects larger than 1 GB."

Athena can query the inventory report instead of manually checking millions of objects.

---

# 📦 9. S3 Object Size Limits

S3 supports very large individual objects.

## Current Limit

As of 2026:

```text
Maximum individual S3 object
        ↓
       50 TB
```

This is an important updated limit.

Older study material may still mention:

```text
5 TB
```

The maximum object size was increased to **50 TB in December 2025**.

---

# 📊 Important Upload Limits

| Upload Method | Limit |
|---|---:|
| Single PUT request | 5 GB |
| S3 Console | 160 GB |
| Multipart Upload | Up to 50 TB |
| Maximum Object Size | **50 TB** |

### Important Interview Difference

Don't confuse:

```text
Maximum PUT request = 5 GB
```

with:

```text
Maximum S3 Object = 50 TB
```

For very large objects, use **Multipart Upload**.

---

# 🧩 10. Multipart Upload

Multipart Upload divides a large file into smaller parts.

Example:

```text
100 GB File
     │
     ├── Part 1
     ├── Part 2
     ├── Part 3
     ├── Part 4
     └── Part 5
```

Each part can be uploaded independently.

After all parts are successfully uploaded, S3 combines them into the final object.

---

# 🚀 Why Use Multipart Upload?

## 1. Large Files

Useful for:

- Videos
- Backups
- Large datasets
- Log archives
- Database dumps

---

## 2. Parallel Upload

Multiple parts can be uploaded at the same time.

```text
             File
              │
      ┌───────┼───────┐
      ▼       ▼       ▼
    Part 1  Part 2  Part 3
      │       │       │
      └───────┼───────┘
              ▼
              S3
```

This can improve upload performance.

---

## 3. Failed Part Can Be Retried

Suppose:

```text
Part 1 ✅
Part 2 ✅
Part 3 ❌
Part 4 ✅
Part 5 ✅
```

You don't need to upload the entire file again.

You can retry:

```text
Part 3
```

This is especially useful for large files and unreliable networks.

---

# 🔄 Multipart Upload Flow

```text
1. Initiate Multipart Upload
             │
             ▼
2. Split File Into Parts
             │
             ▼
3. Upload Parts
             │
             ▼
4. Retry Failed Parts
             │
             ▼
5. Complete Multipart Upload
             │
             ▼
6. S3 Creates Final Object
```

---

# 🏗️ 11. Complete S3 Architecture

The concepts learned today can be connected together.

```text
                         Company Data
                              │
                              ▼
                        S3 Bucket
                       ap-south-1
                              │
             ┌────────────────┼────────────────┐
             │                │                │
             ▼                ▼                ▼
        Multi-AZ          Inventory        Versioning
        Resilience            │
                              ▼
                         CSV / Parquet
                              │
                              ▼
                           Athena
                             
                             
                  Cross-Region Replication
                              │
                              ▼
                     S3 Singapore
                    ap-southeast-1
```

For large files:

```text
100 GB Video
      │
      ▼
Multipart Upload
      │
      ▼
S3 Bucket
```

Replication:

```text
Mumbai S3
    │
    │ Asynchronous CRR
    ▼
Singapore S3
```

---

# 🎯 12. Practical Example

Suppose ABC Technologies stores customer videos in:

```text
S3 Mumbai
```

The company wants disaster recovery.

### Primary

```text
ap-south-1
```

### DR

```text
ap-southeast-1
```

They configure:

```text
S3 Versioning
       +
CRR
       +
IAM Replication Role
```

Large videos use:

```text
Multipart Upload
```

The company also configures:

```text
S3 Inventory
```

to generate reports about stored objects.

Athena can then query the inventory data.

---

# 💼 13. Interview Questions

## Q1. What is S3 Replication?

S3 Replication automatically copies objects from one S3 bucket to another bucket.

---

## Q2. What is CRR?

CRR stands for **Cross-Region Replication**.

It copies objects between S3 buckets in different AWS Regions.

---

## Q3. What is SRR?

SRR stands for **Same-Region Replication**.

It copies objects between S3 buckets in the same AWS Region.

---

## Q4. Is S3 replication synchronous or asynchronous?

**Asynchronous.**

---

## Q5. What is the main prerequisite for S3 live replication?

**Versioning must be enabled on both source and destination buckets.**

---

## Q6. Why is versioning important for replication?

S3 replication relies on object versions to replicate changes and maintain the required object version state.

---

## Q7. Is S3 replication automatically bidirectional?

No.

A normal replication rule is directional.

For bidirectional replication, replication must be configured in both directions.

---

## Q8. Does S3 automatically replicate data to another AWS Region?

No.

S3 provides redundancy across multiple Availability Zones within its Region, but cross-Region replication must be configured separately.

---

## Q9. What is the difference between AZ-level and Region-level protection?

AZ-level protection protects against an Availability Zone failure within the Region.

CRR provides a copy in another AWS Region for regional disaster recovery.

---

## Q10. What is S3 Inventory?

S3 Inventory is a scheduled report containing information about objects in an S3 bucket.

---

## Q11. Can Athena query S3 Inventory?

Yes.

Inventory reports can be stored in S3 and queried using Athena.

---

## Q12. What is the maximum S3 object size in 2026?

**50 TB.**

---

## Q13. What is the maximum size of a single PUT request?

**5 GB.**

---

## Q14. How can you upload a 10 TB object?

Use **Multipart Upload**.

---

## Q15. What is Multipart Upload?

Multipart Upload divides a large object into smaller parts and uploads them independently before S3 combines them into the final object.

---

## Q16. What happens if one multipart upload part fails?

Only the failed part needs to be retried.

---

## Q17. Why is Multipart Upload useful?

It provides:

- Parallel uploads
- Better performance
- Retry of individual failed parts
- Support for very large objects

---

## Q18. Does CRR replace backups?

Not necessarily.

Replication is primarily for maintaining another copy of data. A deletion or unwanted change can potentially be replicated as well, so proper backup/versioning/retention strategies may still be required.

---

## Q19. What is the difference between CRR and backup?

CRR creates a replicated copy in another Region.

Backup is designed specifically for recovery from accidental deletion, corruption, or other historical states and may use retention mechanisms.

---

## Q20. What is S3 Versioning?

Versioning keeps multiple versions of an object so previous versions can be recovered.

---

# ⚡ 14. Quick Revision

| Topic | Key Point |
|---|---|
| S3 Replication | Automatically copies objects |
| CRR | Different AWS Region |
| SRR | Same AWS Region |
| S3 Replication | Asynchronous |
| Normal Replication | Directional |
| Bidirectional | Configure both directions |
| Replication Prerequisite | Versioning |
| IAM Role | Gives S3 replication permissions |
| Existing Objects | S3 Batch Replication |
| S3 Standard | Multi-AZ resilience |
| CRR | Cross-Region resilience |
| Inventory | Scheduled object report |
| Inventory Formats | CSV, ORC, Parquet |
| Athena | Query Inventory data |
| Maximum Object | **50 TB** |
| Single PUT | **5 GB** |
| Multipart | Up to **50 TB** |
| Multipart Benefit | Parallel upload + retry |

---

# 🧠 15. Most Important Interview Points

Remember these five:

### 1️⃣ Replication

```text
S3 → S3
```

---

### 2️⃣ CRR

```text
Mumbai → Singapore
```

Different Regions.

---

### 3️⃣ Versioning

```text
Source + Destination
       ↓
Versioning Enabled
```

Required for live replication.

---

### 4️⃣ S3 Object Limit

```text
Maximum Object = 50 TB
```

Current 2026 limit.

---

### 5️⃣ Multipart Upload

```text
Large File
    ↓
Parts
    ↓
Parallel Upload
    ↓
S3 Object
```

---

# 📝 Summary

In this topic, we learned how Amazon S3 handles **replication, availability, inventory, and large objects**.

S3 can replicate objects between buckets using **Same-Region Replication (SRR)** or **Cross-Region Replication (CRR)**. S3 live replication is asynchronous, and versioning must be enabled on the source and destination buckets.

S3 already provides resilience across multiple Availability Zones within a Region. However, protecting data against a complete Region-level failure requires a strategy such as **Cross-Region Replication**.

For large-scale bucket management, **S3 Inventory** provides scheduled reports about objects and their metadata. These reports can be stored in S3 and analyzed using **Amazon Athena**.

For large files, **Multipart Upload** divides the object into smaller parts, allowing parallel uploads and individual part retries. As of 2026, the maximum size of an individual S3 object is **50 TB**, while a single PUT request supports up to **5 GB**.

---

# 🎯 Final Architecture to Remember

```text
                         S3
                         │
             ┌───────────┼───────────┐
             │           │           │
             ▼           ▼           ▼
         Versioning   Inventory   Multipart
             │           │           │
             │           ▼           │
             │        Athena         │
             │                       │
             ▼                       ▼
       Replication               Large Objects
             │
       ┌─────┴─────┐
       ▼           ▼
      SRR         CRR
       │           │
 Same Region   Different Region
```

---

# 🚀 Next Steps

Recommended S3 topics to learn next:

- S3 Storage Classes
- S3 Lifecycle Rules
- S3 Intelligent-Tiering
- S3 Encryption
- Bucket Policies
- IAM Policies
- ACL vs Bucket Policy
- S3 Object Lock
- S3 Glacier
- CloudFront + Private S3
- Origin Access Control (OAC)
- S3 Event Notifications
- S3 + Lambda
- S3 + CloudTrail

---

# 🏆 Learning Outcome

After completing these topics, you should be able to explain:

> **How S3 protects data within a Region, how data can be replicated across Regions, how large buckets can be inventoried and analyzed, and how very large objects can be efficiently uploaded using Multipart Upload.**

**S3 Deep Dive — Completed ✅**
