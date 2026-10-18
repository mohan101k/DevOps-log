# 🐧 POC 03 — Linux Users, Groups & Permissions

<p align="center">
  <img src="https://img.shields.io/badge/Platform-AWS%20EC2-orange?style=for-the-badge&logo=amazonaws" alt="AWS EC2">
  <img src="https://img.shields.io/badge/OS-Amazon%20Linux%202023-232F3E?style=for-the-badge&logo=linux" alt="Amazon Linux 2023">
  <img src="https://img.shields.io/badge/Domain-DevOps-blue?style=for-the-badge" alt="DevOps">
</p>

## 📌 Project Overview

This hands-on project demonstrates essential Linux system administration skills using an **Amazon Linux 2023 EC2 instance**.

The objective is to understand how Linux manages users, groups, file ownership, and permissions while applying access control and least-privilege principles.

## 🎯 Objectives

- Create and manage Linux user accounts.
- Create groups and configure group membership.
- Understand UID, GID, and supplementary groups.
- Manage ownership using `chown` and `chgrp`.
- Configure permissions using `chmod`.
- Understand symbolic and numeric permission modes.
- Test shared file access between users.
- Troubleshoot permission-related errors.

## 🛠️ Technology Stack

| Component | Technology |
|---|---|
| Cloud Platform | AWS |
| Compute Service | Amazon EC2 |
| Operating System | Amazon Linux 2023 |
| Connection | EC2 Instance Connect |
| Interface | Linux Command Line |
| Focus Area | Linux Administration and DevOps |

## 🏗️ Practical Workflow

```text
AWS EC2 Instance
       |
       v
Verify Linux Environment
       |
       v
Create Test Users
(devuser, tester)
       |
       v
Create Group
(developers)
       |
       v
Configure Group Membership
       |
       v
Create Test Files and Directories
       |
       v
Configure Ownership and Permissions
       |
       v
Test User Access
       |
       v
Verify Results and Troubleshoot
```

## 💻 Hands-on Implementation

### 1. Verify the Linux Environment

```bash
whoami
hostname
cat /etc/os-release
```

### 2. Create Test Users

```bash
sudo useradd -m devuser
sudo passwd devuser
sudo useradd -m tester

id devuser
id tester
getent passwd devuser
```

### 3. Create a Group and Assign Users

```bash
sudo groupadd developers
sudo usermod -aG developers devuser
sudo usermod -aG developers tester

id devuser
id tester
getent group developers
```

### 4. Create a Test Directory and File

```bash
mkdir -p ~/poc3-lab/shared

echo "Linux permissions POC 03" > ~/poc3-lab/shared/project.txt

ls -l ~/poc3-lab/shared/project.txt
```

### 5. Configure File Ownership

```bash
sudo chgrp developers ~/poc3-lab/shared/project.txt

sudo chown devuser:developers ~/poc3-lab/shared/project.txt

ls -l ~/poc3-lab/shared/project.txt
```

### 6. Configure File Permissions

```bash
chmod 664 ~/poc3-lab/shared/project.txt

stat -c '%A %a %U %G %n' ~/poc3-lab/shared/project.txt
```

### 7. Configure a Shared Directory

```bash
sudo mkdir -p /tmp/poc3-shared

sudo chown ec2-user:developers /tmp/poc3-shared

sudo chmod 2770 /tmp/poc3-shared
```

The setgid bit (`2`) on the directory helps new files and subdirectories inherit its group.

### 8. Test Shared File Access

```bash
echo "Shared access test" | sudo tee /tmp/poc3-shared/shared.txt

sudo chown ec2-user:developers /tmp/poc3-shared/shared.txt

sudo chmod 660 /tmp/poc3-shared/shared.txt

sudo -u devuser cat /tmp/poc3-shared/shared.txt
```

Test write access:

```bash
sudo -u devuser bash -c 'echo "Written by devuser" >> /tmp/poc3-shared/shared.txt'

cat /tmp/poc3-shared/shared.txt
```

Expected output:

```text
Shared access test
Written by devuser
```

### 9. Practice Executable Permissions

```bash
printf '#!/bin/bash\necho "Permission test successful"\n' > ~/poc3-lab/test.sh

chmod 750 ~/poc3-lab/test.sh

ls -l ~/poc3-lab/test.sh

~/poc3-lab/test.sh
```

Expected output:

```text
Permission test successful
```

## 🔐 Linux Permission Reference

Linux permissions determine what the owner, group, and other users can do with a file or directory.

| Permission | Numeric Value | Description |
|---|---:|---|
| Read (`r`) | 4 | Read file contents |
| Write (`w`) | 2 | Modify file contents |
| Execute (`x`) | 1 | Execute a file or traverse a directory |
| None (`-`) | 0 | No permission |

### Common Permission Modes

| Mode | Symbolic Form | Meaning |
|---|---|---|
| `750` | `rwxr-x---` | Owner has full access; group can read and execute |
| `664` | `rw-rw-r--` | Owner and group can read/write; others can read |
| `640` | `rw-r-----` | Owner can read/write; group can read |
| `660` | `rw-rw----` | Owner and group can read/write |

## 🧰 Commands Reference

| Command | Purpose |
|---|---|
| `whoami` | Display current user |
| `id` | Display UID, GID, and group memberships |
| `useradd` | Create a user |
| `passwd` | Set a user's password |
| `usermod -aG` | Add a user to a supplementary group |
| `userdel` | Delete a user |
| `groupadd` | Create a group |
| `groupdel` | Delete a group |
| `getent` | Retrieve account and group records |
| `chmod` | Change permissions |
| `chown` | Change ownership |
| `chgrp` | Change group ownership |
| `ls -l` | Inspect ownership and permissions |
| `stat` | Display file metadata |
| `sudo -u` | Run a command as another user |

## ✅ Validation Checklist

- [ ] Verified the Linux environment.
- [ ] Created and inspected test users.
- [ ] Created a development group.
- [ ] Verified group membership.
- [ ] Changed file ownership.
- [ ] Applied numeric permission modes.
- [ ] Tested shared file access.
- [ ] Executed a shell script.
- [ ] Verified results and reviewed cleanup.

> Mark each item complete only after running and verifying the corresponding practical exercise.

## 🚀 Key Learnings

- Linux account and group administration.
- UID, GID, and supplementary group concepts.
- File ownership and permission management.
- Symbolic and numeric permission notation.
- Shared directory access and the setgid bit.
- Access-control troubleshooting.
- Least-privilege principles for Linux servers.

## ☁
