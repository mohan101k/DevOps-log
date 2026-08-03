
# 🚀 Production Lab 6
## Problem: Storage Full (Disk 100%)

---

# 🎯 Company Scenario

**Company:** ABC Technologies

Applications running:

- ✅ HR Portal
- ✅ E-Commerce
- ✅ Admin Dashboard

Everything is running on AWS.

Customers start uploading:

- 📷 Product Images
- 🎥 Product Videos
- 📄 PDF Invoices
- 📑 Documents

Initially, the uploads are small.

Manager says:

> "Store everything on our EC2 server. We don't need S3."

You follow the instruction.

---

# 🏗️ Current Architecture

```
                 Internet
                      │
                      ▼
                    ALB
                      │
                      ▼
                 EC2 Server
         ┌─────────┼─────────┐
         ▼         ▼         ▼
      HR App    Shop App   Admin App
                      │
                      ▼
           Local Storage (/var/www/uploads)
```

Everything looks fine.

---

# 📈 After 3 Months...

The company becomes popular.

Daily uploads:

- 500 Images
- 300 PDFs
- 100 Videos

EC2 storage starts filling.

Eventually:

**Disk Usage = 100%**

Now problems begin.

---

# ❌ Production Problems

Users try to upload images.

↓

Upload Failed

↓

Application throws error

↓

Logs cannot be written

↓

Database backup fails

↓

Website becomes unstable

---

# 🌍 Real-Time Example

Imagine Flipkart.

Every day, customers upload:

- Product Images
- Product Videos
- Seller Documents

Would Flipkart store all these files on one EC2?

❌ Never.

If the EC2 crashes:

- Images are lost.
- Videos are lost.
- Customer documents are lost.

That's why companies use Amazon S3.

---

# 🎯 Today's Objective

Today we will:

- Create an EC2 server (or use one if you already have it).
- Simulate storing files on the server.
- Observe disk usage.
- Understand why local storage is a bad idea.
- Then migrate storage to Amazon S3.

By the end of this lab, you'll understand why S3 exists.

---

