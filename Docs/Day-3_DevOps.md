
# 📚 DAY-3 (Hypervisor & Docker Fundamentals)

## 📌 Topics Covered

- Hypervisor Layer
- Physical Server Concept
- Hypervisor & Virtualization Relationship
- Ubuntu vs Docker
- Docker Characteristics
- Isolated Environment
- Virtualization Concept
- Containerization
- Docker vs Virtual Machine

---

# 📘 1. Hypervisor Layer

## 📖 Concept

A Hypervisor is software that creates and manages Virtual Machines (VMs). It acts as a bridge between Physical Hardware and Virtual Machines.

---

## 🌍 Real-Time Example

AWS uses Hypervisors to create multiple EC2 Virtual Machines on a single Physical Server.

---

## 🎯 Interview Point

Types of Hypervisors

- Type 1 (Bare Metal)
- Type 2 (Hosted)

---

## 🛠 Examples

- VMware ESXi
- Hyper-V
- VirtualBox
- KVM

---

> 💡 Hardware ➜ Hypervisor ➜ Virtual Machines

---

# 📘 2. Physical Server

## 📖 Concept

A Physical Server is the actual hardware containing CPU, RAM, Storage, Motherboard, and Network Interface Card.

---

## 🌍 Real-Time Example

A company purchases one server with:

- 64 CPU Cores
- 256 GB RAM
- 8 TB SSD

Before Virtualization, only one Operating System used all these resources.

---

## 🎯 Interview Point

Traditional Model

1 Physical Server = 1 Operating System

---

## 🛠 Hardware

- CPU
- RAM
- SSD
- Motherboard
- NIC

---

# 📘 3. Hypervisor & Virtualization Relationship

## 📖 Concept

Virtualization is the technology.

Hypervisor is the software that implements Virtualization.

---

## 🌍 Real-Time Example

One Dell Server runs:

- Ubuntu VM
- Windows VM
- CentOS VM

using a Hypervisor.

---

## 🎯 Interview Point

Without Hypervisor, Virtual Machines cannot exist.

---

## 🛠 Examples

- VMware
- Hyper-V
- Xen

---

# 📘 4. Ubuntu (6GB) vs Docker

## 📖 Concept

Virtual Machines contain the complete Operating System, making them large.

Docker packages only the required dependencies while sharing the Host Operating System.

---

## 🌍 Real-Time Example

Virtual Machine

Ubuntu (6GB)

+ Python

+ Flask

Docker

Python Base Image

+ Flask

≈ 200MB

---

## 🎯 Interview Point

Docker shares the Host Kernel.

---

## 🛠 Common Images

- ubuntu
- alpine
- python
- node
- nginx

---

> 💡 VM = Full OS
>
> Docker = Required Dependencies Only

---

# 📘 5. Docker Characteristics

## 📖 Concept

Docker packages applications with their dependencies into lightweight Containers.

---

## 🌍 Real-Time Example

A Docker Image created on Windows runs exactly the same on AWS or Linux.

---

## 🎯 Interview Point

Characteristics

- Lightweight
- Portable
- Fast
- Isolated
- Efficient

---

## 🛠 Docker Components

- Docker Engine
- Docker Image
- Docker Container
- Docker Hub
- Dockerfile

---

# 📘 6. Isolated Environment

## 📖 Concept

Every Docker Container runs independently with its own file system, networking, and processes.

---

## 🌍 Real-Time Example

One Container runs Python 3.9.

Another runs Python 3.12.

No dependency conflicts occur.

---

## 🎯 Interview Point

Isolation improves security and avoids library conflicts.

---

## 🛠 Related Concepts

- Namespaces
- cgroups
- Docker Network
- Docker Volumes

---

# 📘 7. Virtualization Concept

## 📖 Concept

Virtualization divides one Physical Server into multiple Virtual Machines.

Each VM contains its own Operating System.

---

## 🌍 Real-Time Example

One Server hosts:

- Ubuntu VM
- Windows VM
- Kali Linux VM

---

## 🎯 Interview Point

Virtual Machines are heavier because each contains a complete Operating System.

---

## 🛠 Hypervisors

- VMware
- Hyper-V
- VirtualBox
- KVM

---

# 📘 8. Containerization

## 📖 Concept

Containerization packages an application with its dependencies while sharing the Host Operating System Kernel.

Containers are much smaller and faster than Virtual Machines.

---

## 🌍 Real-Time Example

A Kubernetes cluster can run hundreds of Docker Containers on a single server.

---

## 🎯 Interview Point

Containers start in seconds because they do not boot an Operating System.

---

## 🛠 Technologies

- Docker
- Podman
- containerd
- CRI-O

---

# 📘 9. Docker vs Virtual Machine

## 📖 Concept

Docker creates Containers, not Virtual Machines.

Containers share the Host Operating System Kernel, making them lightweight.

---

## 🌍 Real-Time Example

Docker starts in seconds.

Virtual Machines usually take minutes because they load a complete Operating System.

---

## 🎯 Interview Point

| Virtual Machine | Docker Container |
|-----------------|------------------|
| Full OS | Shared Host OS |
| Hypervisor | Docker Engine |
| Large Size | Small Size |
| Slow Startup | Fast Startup |
| More RAM | Less RAM |

---

## 🛠 Technologies

- Docker
- VMware
- Hyper-V
- Podman

---

> 💡 Docker performs Operating System-Level Virtualization, not Hardware Virtualization.
