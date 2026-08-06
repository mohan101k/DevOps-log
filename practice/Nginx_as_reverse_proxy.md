# 🚀 Day 20 — Nginx Reverse Proxy with Flask Application (Production Deployment)

**Date:** August 06, 2026

**Course:** DevOps with AWS

---

# 📚 Concepts Covered

- What is Reverse Proxy?
- Why Reverse Proxy is required
- Flask Application Deployment
- Nginx Installation
- Nginx Reverse Proxy Configuration
- How Client → Nginx → Flask Communication Works
- Production Deployment Flow
- Basic Troubleshooting
- Common Interview Questions

---

# 📑 Table of Contents

- Introduction
- Company Scenario
- Problem Statement
- What is Reverse Proxy?
- Why Do We Need Reverse Proxy?
- Architecture Diagram
- Request Flow
- Theory Notes

---

# 🏢 Real-Time Company Scenario

Suppose you have joined **ABC Technologies** as a DevOps Engineer.

The Backend Team has developed a REST API using **Python Flask**.

The developer gives you only two files:

```
app.py
requirements.txt
```

The Flask application runs successfully on:

```
http://localhost:5000
```

Now the manager says:

> "Do not expose Flask directly to the internet.
> Users should only access our application using Port 80."

Your responsibility as a DevOps Engineer is to deploy the application securely using **Nginx Reverse Proxy**.

---

# ❌ Problem Statement

If we directly expose Flask like this

```
Internet
     │
     ▼
Public-IP:5000
     │
     ▼
 Flask Application
```

Several problems occur.

- Backend Port becomes public.
- Anyone can directly access the Flask server.
- Difficult to configure HTTPS.
- No Load Balancing.
- No Security Layer.
- No Caching.
- No Path Based Routing.

This is **not** a production-ready architecture.

---

# ✅ Production Solution

Instead of exposing Flask directly, we place **Nginx** in front of it.

```
Internet
     │
     ▼
Public-IP (80)
     │
     ▼
    Nginx
     │
proxy_pass
     │
     ▼
localhost:5000
     │
     ▼
 Flask Application
```

Now users only communicate with **Nginx**.

Flask remains hidden inside the server.

---

# 📖 What is Reverse Proxy?

A Reverse Proxy is a server that sits between the client and backend servers.

Instead of users communicating directly with the backend application, they communicate with the Reverse Proxy.

The Reverse Proxy forwards the request to the backend application and sends the response back to the client.

The client never knows where the backend application is running.

---

## Simple Definition

> Reverse Proxy is a server that receives client requests and forwards them to one or more backend servers.

---

# 🌍 Real-Time Example

Suppose you open

```
amazon.com
```

You are **NOT** directly communicating with Java, Python or NodeJS.

Instead

```
User
 │
 ▼
Load Balancer / Nginx
 │
 ▼
Application Server
```

The Load Balancer or Nginx decides which backend server should handle your request.

Exactly the same thing we implemented in this lab.

---

# ❓ Why Do We Need Reverse Proxy?

Reverse Proxy provides multiple advantages.

## 1. Hide Backend Servers

Without Reverse Proxy

```
User

↓

Server:5000
```

Everyone knows the backend port.

With Reverse Proxy

```
User

↓

Nginx

↓

Flask
```

The backend remains private.

---

## 2. Better Security

Users only communicate with Nginx.

Backend applications remain hidden.

Attackers cannot directly access the backend service.

---

## 3. HTTPS Support

SSL Certificates are usually installed on Nginx.

Nginx decrypts HTTPS traffic and forwards normal HTTP requests to Flask.

```
HTTPS

↓

Nginx

↓

HTTP

↓

Flask
```

This process is called **SSL Termination**.

---

## 4. Load Balancing

One Nginx server can distribute traffic to multiple Flask servers.

Example

```
          Nginx
        /    |    \
       /     |     \
 Flask1 Flask2 Flask3
```

This improves availability and scalability.

---

## 5. Path Based Routing

Different URLs can point to different backend applications.

Example

```
example.com/hr

↓

HR Application

------------------------

example.com/shop

↓

Shopping Application

------------------------

example.com/admin

↓

Admin Dashboard
```

Only one Public IP is required.

---

## 6. Centralized Logging

Instead of checking logs on every backend server,

Nginx stores incoming request logs in one place.

This makes troubleshooting easier.

---

# 🏗️ Production Architecture

```
                    Internet
                         │
                         ▼
                 Public IP (Port 80)
                         │
                  ┌──────────────┐
                  │    Nginx     │
                  │ Reverse Proxy│
                  └──────┬───────┘
                         │
                 proxy_pass
                         │
                         ▼
               Flask Application
                localhost:5000
                         │
                         ▼
                Python Application
```

---

# 🔄 Request Flow

### Step 1

User opens

```
http://Public-IP
```

↓

### Step 2

Nginx receives the request on

```
Port 80
```

↓

### Step 3

Nginx forwards the request using

```
proxy_pass
```

↓

### Step 4

Flask receives the request on

```
localhost:5000
```

↓

### Step 5

Flask generates the response.

↓

### Step 6

The response returns to Nginx.

↓

### Step 7

Nginx sends the response back to the client.

The client never communicates directly with Flask.

---

# 🧠 Theory Notes

| Component | Responsibility |
|------------|----------------|
| Client | Sends HTTP Request |
| Nginx | Receives request from client |
| Reverse Proxy | Forwards request to Flask |
| Flask | Processes business logic |
| Browser | Displays response |

---

# 💡 Remember

- Flask is **Application Server**
- Nginx is **Web Server + Reverse Proxy**
- Users communicate with **Nginx**
- Nginx communicates with **Flask**
- Flask should never be exposed directly in production
- Reverse Proxy improves Security, Performance and Scalability

---

## ✅ End of Part 1

In **Part 2**, we'll start the practical from scratch:

- Launch EC2
- Install Python
- Install Git
- Clone Flask Project
- Install Dependencies
- Run Flask on Port **5000**
- Verify using `curl`
- Understand every command used during deployment.

- # 🛠️ Practical Implementation (Step-by-Step)

In this section, we will deploy a Flask application on an AWS EC2 instance and configure it to run on **Port 5000**. At this stage, users still cannot access the application through the EC2 Public IP because Nginx Reverse Proxy has not yet been configured. We will configure Nginx in Part 3.

---

# 🎯 Lab Objective

By the end of this section, you will be able to:

- Launch an EC2 Instance
- Install Python and required packages
- Clone a Flask project from GitHub
- Install project dependencies
- Run the Flask application
- Verify the backend using `curl`

---

# 🏗️ Current Architecture

```
                 Internet
                      │
                      ▼
                EC2 Instance
                      │
                      ▼
          Flask Application
             localhost:5000
```

Currently, the application is only accessible **inside the server**.

---

# ✅ Step 1 — Launch EC2 Instance

Launch a new EC2 Instance with the following configuration.

| Property | Value |
|----------|-------|
| Name | reverse-proxy-server |
| AMI | Amazon Linux 2023 |
| Instance Type | t2.micro |
| Key Pair | Your Existing Key |
| Security Group | SSH (22) + HTTP (80) |

### Security Group

| Type | Port | Source |
|------|------|--------|
| SSH | 22 | My IP |
| HTTP | 80 | Anywhere |

> **Note:** We do **NOT** open Port **5000** because it is an internal backend port.

Wait until:

```
Running

2/2 Status Checks Passed
```

---

# ✅ Step 2 — Connect to EC2

Connect using **EC2 Instance Connect** or SSH.

Example:

```bash
ssh -i mykey.pem ec2-user@<Public-IP>
```

---

# ✅ Step 3 — Update Packages

Always update the operating system before installing software.

```bash
sudo dnf update -y
```

---

# ✅ Step 4 — Install Required Packages

Install Python, pip, Git, Nginx and unzip.

```bash
sudo dnf install python3 python3-pip git nginx unzip -y
```

---

# Verify Installation

```bash
python3 --version
```

```bash
pip3 --version
```

```bash
git --version
```

```bash
nginx -v
```

Expected Output

```
Python 3.x.x
pip 23.x.x
git version ...
nginx version ...
```

---

# Why These Packages?

| Package | Purpose |
|----------|----------|
| Python3 | Run Flask Application |
| pip | Install Python Packages |
| Git | Clone Project |
| Nginx | Reverse Proxy |
| unzip | Extract ZIP files |

---

# ✅ Step 5 — Clone Flask Project

For this lab we used a public GitHub repository.

```bash
cd ~

git clone https://github.com/CloudTechDevOps/docker_python_flask-project.git
```

Verify

```bash
ls
```

Expected

```
docker_python_flask-project
```

---

# Step 6 — Enter Project Directory

```bash
cd docker_python_flask-project
```

Verify files

```bash
ls
```

You should see files similar to

```
app.py
requirements.txt
README.md
Dockerfile
```

---

# Project Structure

```
docker_python_flask-project
│
├── app.py
├── requirements.txt
├── Dockerfile
└── README.md
```

---

# Understanding the Files

## app.py

Contains the Flask application.

Example

```python
@app.route("/")
def hello():
    return "updated Flask sample application on azure hghapp service updated version-6"
```

---

## requirements.txt

Contains all Python libraries required by the project.

Example

```
Flask
gunicorn
...
```

Instead of installing packages manually, we install everything at once.

---

# ✅ Step 7 — Install Python Dependencies

Run

```bash
pip3 install -r requirements.txt
```

If permission errors occur

```bash
pip3 install --user -r requirements.txt
```

Wait until installation completes successfully.

---

# What Happens Here?

pip reads the `requirements.txt` file and automatically downloads every required Python package.

This saves time and avoids missing dependencies.

---

# ✅ Step 8 — Start Flask Application

Run

```bash
python3 app.py
```

Expected Output

```
Running on

http://127.0.0.1:5000

or

http://0.0.0.0:5000
```

This means

✔ Flask Server Started

✔ Listening on Port 5000

---

# Why Port 5000?

Flask Development Server uses **Port 5000** by default.

This port is intended for backend communication and testing.

In production, users should **never** access this port directly.

---

# Current Architecture

```
          EC2 Server

        Flask Application

          Port 5000
```

There is **no Nginx** yet.

---

# ✅ Step 9 — Open Second Terminal

Keep Flask running.

Open another EC2 terminal.

Do **NOT** stop Flask.

---

# Step 10 — Verify Backend

Run

```bash
curl http://localhost:5000
```

Expected

```
updated Flask sample application on azure hghapp service updated version-6
```

Congratulations 🎉

Your Flask backend is now working successfully.

---

# Why Use curl?

Instead of opening a browser, DevOps Engineers use `curl` to quickly verify backend services.

Benefits

- Fast Testing
- No Browser Required
- Easy Debugging
- Useful in CI/CD Pipelines

---

# Current Lab Status

```
                 EC2

                  │

                  ▼

          Flask Application

             localhost:5000

                  │

             curl Works ✅

                  │

      Browser Access ❌
```

The backend is working, but users cannot access it from the internet because nothing is listening on **Port 80**.

---

# 💡 Remember

- Flask is running successfully.
- Backend is listening on **Port 5000**.
- `curl http://localhost:5000` should return the application response.
- Public IP will **NOT** show the Flask application yet.
- We need **Nginx Reverse Proxy** to expose the application on Port **80**.

---

## ✅ End of Part 2

In **Part 3**, we will:

- Install and Start Nginx
- Configure Reverse Proxy
- Understand `proxy_pass`
- Test Nginx Configuration
- Restart Nginx
- Verify using Public IP
- Complete the Production Deployment

- # 🌐 Part 3 — Nginx Installation, Reverse Proxy Configuration & Testing

At this stage, our Flask application is already running on **Port 5000**.

However, users still **cannot** access the application using the EC2 Public IP because the application is only listening on the local machine.

Our goal now is to configure **Nginx** as a Reverse Proxy.

---

# 🎯 Objective

By the end of this section, you will learn:

- Install Nginx
- Start and Enable Nginx
- Configure Reverse Proxy
- Understand `proxy_pass`
- Test Nginx Configuration
- Restart Nginx
- Verify using Browser
- Understand complete request flow

---

# 🏗️ Before Reverse Proxy

```
                 Internet
                      │
                      ▼
                 EC2 Instance
                      │
                 Port 80 ❌
                      │
             Nothing Running

--------------------------------

Flask

localhost:5000 ✅
```

The backend works internally.

Users cannot access it.

---

# Why Can't Users Access Flask?

Flask is listening only on

```
localhost:5000
```

The browser tries to access

```
Public-IP:80
```

Since nothing is running on Port 80,

the browser displays

```
Connection Refused

OR

Unable to Connect
```

---

# Solution

Install Nginx.

Nginx will receive requests on Port 80

and forward them to

```
localhost:5000
```

---

# 🏗️ After Reverse Proxy

```
                  Internet
                       │
                       ▼
                EC2 Public IP
                       │
                 HTTP (Port 80)
                       │
                 ┌──────────┐
                 │  Nginx   │
                 └────┬─────┘
                      │
         proxy_pass localhost:5000
                      │
                      ▼
              Flask Application
                 Port 5000
```

---

# Step 1 — Start Nginx

Start the Nginx service.

```bash
sudo systemctl start nginx
```

---

# Step 2 — Enable Nginx

```bash
sudo systemctl enable nginx
```

This ensures Nginx starts automatically whenever the EC2 instance reboots.

---

# Step 3 — Verify Status

```bash
sudo systemctl status nginx
```

Expected Output

```
Active: active (running)
```

---

# Step 4 — Verify Default Nginx Page

Before configuring Reverse Proxy,

check whether Nginx is working.

Run

```bash
curl http://localhost
```

Expected Output

```
Welcome to nginx!
```

or HTML source of the welcome page.

This confirms

✔ Nginx is running

❌ Flask is not connected yet

---

# Understanding Nginx Default Behaviour

Initially,

Nginx serves files from

```
/usr/share/nginx/html
```

instead of forwarding requests to Flask.

Therefore

```
Browser

↓

Welcome to nginx!
```

---

# Step 5 — Open Nginx Configuration

Edit the configuration file.

```bash
sudo nano /etc/nginx/nginx.conf
```

Locate the

```
server
```

block.

Inside the server block,

replace

```
location /
```

with

```nginx
location / {

    proxy_pass http://127.0.0.1:5000;

    proxy_set_header Host $host;

    proxy_set_header X-Real-IP $remote_addr;

    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

}
```

Save the file.

---

# Understanding proxy_pass

This is the most important directive.

```
proxy_pass http://127.0.0.1:5000;
```

Meaning

```
Every request received by Nginx

↓

Forward it to Flask

↓

Receive Response

↓

Return Response to Client
```

---

# Understanding Each Directive

## proxy_pass

Forwards requests to backend server.

Example

```
Client

↓

Nginx

↓

Flask
```

---

## proxy_set_header Host

Passes the original hostname to Flask.

Without this,

Flask may not know which hostname the client requested.

---

## X-Real-IP

Passes the client's original IP address.

Useful for

- Logging
- Auditing
- Security

---

## X-Forwarded-For

If multiple proxies exist,

this header stores every client IP.

Production applications use this heavily.

---

# Step 6 — Test Configuration

Always verify before restarting Nginx.

```bash
sudo nginx -t
```

Expected

```
syntax is ok

test is successful
```

Never restart Nginx without checking configuration.

---

# Step 7 — Restart Nginx

```bash
sudo systemctl restart nginx
```

Verify

```bash
sudo systemctl status nginx
```

Expected

```
active (running)
```

---

# Step 8 — Test Reverse Proxy

Run

```bash
curl http://localhost
```

Earlier,

it returned

```
Welcome to nginx!
```

Now it should return

```
updated Flask sample application on azure hghapp service updated version-6
```

Congratulations 🎉

Nginx is now forwarding requests to Flask.

---

# Step 9 — Verify Using Browser

Open

```
http://<EC2-Public-IP>
```

Example

```
http://34.xxx.xxx.xxx
```

Expected

```
updated Flask sample application on azure hghapp service updated version-6
```

If this appears,

your Reverse Proxy is working successfully.

---

# Complete Request Flow

```
Browser

↓

HTTP Request

↓

Nginx (Port 80)

↓

proxy_pass

↓

Flask (Port 5000)

↓

Application Response

↓

Nginx

↓

Browser
```

The browser never communicates directly with Flask.

---

# Verification Commands

Check Flask

```bash
curl http://localhost:5000
```

Check Reverse Proxy

```bash
curl http://localhost
```

Check Public Access

```
http://<Public-IP>
```

Check Nginx Status

```bash
sudo systemctl status nginx
```

Check Configuration

```bash
sudo nginx -t
```

---

# Lab Success Criteria

✔ Flask running on Port 5000

✔ Nginx running on Port 80

✔ Reverse Proxy configured

✔ Public IP accessible

✔ Browser displays Flask response

✔ Backend Port hidden

---

# 💡 Remember

Flask should never be exposed directly.

Always expose

```
Nginx

↓

Reverse Proxy

↓

Flask
```

This is the architecture followed in production for

- Flask
- Django
- Spring Boot
- NodeJS
- ASP.NET
- Go
- PHP Applications

---

## ✅ End of Part 3

In **Part 4**, we'll cover:

- Production Deployment Flow
- Common Errors
- Troubleshooting
- Best Practices
- Real-Time Production Architecture
- Security Recommendations

- # 🚀 Part 4 — Production Deployment Flow, Troubleshooting & Best Practices

Now that the Reverse Proxy is working successfully, let's understand how companies deploy backend applications in production and how DevOps Engineers troubleshoot common issues.

---

# 🏢 Production Deployment Flow

In real companies, deployment does not end after configuring Nginx.

A complete deployment follows the lifecycle shown below.

```
Developer
     │
     ▼
GitHub Repository
     │
     ▼
CI/CD Pipeline (Jenkins/GitHub Actions)
     │
     ▼
EC2 Server
     │
     ▼
Python Application
     │
     ▼
Flask Server (Port 5000)
     │
     ▼
Nginx Reverse Proxy (Port 80/443)
     │
     ▼
Users
```

This architecture is used by thousands of production applications.

---

# 🚀 Real Production Architecture

```
                    Internet
                         │
                         ▼
                  Route 53 (DNS)
                         │
                         ▼
               Application Load Balancer
                         │
          ┌──────────────┴──────────────┐
          ▼                             ▼
     EC2 Instance 1                EC2 Instance 2
          │                             │
      Nginx Server                  Nginx Server
          │                             │
      Flask :5000                  Flask :5000
          │                             │
          └──────────────┬──────────────┘
                         ▼
                    Amazon RDS
```

As traffic increases,

ALB distributes requests across multiple servers.

Each server has

- Nginx
- Flask
- Same Application Code

---

# Why Do We Need Nginx?

Many beginners ask

> Why can't users access Flask directly?

Because Flask is designed as an **application server**, not as a production web server.

Nginx provides

- Reverse Proxy
- Static File Serving
- HTTPS
- SSL Termination
- Request Routing
- Security
- Compression
- Logging
- Load Balancing

---

# Production Request Flow

```
Browser

↓

Route53

↓

Application Load Balancer

↓

Nginx

↓

Flask

↓

Business Logic

↓

Database

↓

Flask

↓

Nginx

↓

Load Balancer

↓

Browser
```

---

# Why Use localhost?

Notice we configured

```
proxy_pass http://127.0.0.1:5000;
```

instead of

```
proxy_pass http://Public-IP:5000;
```

Reason

Both Nginx and Flask are running on the same EC2 instance.

Communication stays inside the server.

Benefits

- Faster
- More Secure
- No Internet Traffic
- Lower Latency

---

# Common Errors & Troubleshooting

## Problem 1

### Browser Shows

```
Welcome to nginx!
```

### Reason

Reverse Proxy not configured.

OR

Configuration not reloaded.

### Solution

Check

```bash
sudo nginx -t
```

Then

```bash
sudo systemctl restart nginx
```

---

## Problem 2

Browser Shows

```
502 Bad Gateway
```

Reason

Flask application is not running.

Solution

Check

```bash
ps -ef | grep python
```

or

```bash
python3 app.py
```

---

## Problem 3

Browser Shows

```
Connection Refused
```

Reason

Backend service stopped.

OR

Wrong proxy_pass port.

Verify

```bash
curl localhost:5000
```

---

## Problem 4

```
Permission Denied
```

Reason

Python package installation failed.

Solution

```bash
pip3 install --user -r requirements.txt
```

or

```bash
sudo pip3 install -r requirements.txt
```

---

## Problem 5

```
404 Not Found
```

Reason

Incorrect Flask Route.

Verify

```python
@app.route("/")
```

exists.

---

## Problem 6

Public IP not opening

Possible Reasons

- Security Group
- Nginx not running
- Firewall
- Wrong Public IP

Check

```bash
sudo systemctl status nginx
```

---

## Problem 7

```
curl localhost:5000

Works

Browser Doesn't
```

Reason

Nginx configuration problem.

Verify

```bash
sudo nginx -t
```

---

## Problem 8

```
502 Bad Gateway
```

Even though Flask is running.

Reason

Incorrect

```
proxy_pass
```

Verify

```nginx
proxy_pass http://127.0.0.1:5000;
```

---

# Useful Commands

## Check Flask

```bash
curl localhost:5000
```

---

## Check Reverse Proxy

```bash
curl localhost
```

---

## Check Nginx Status

```bash
sudo systemctl status nginx
```

---

## Restart Nginx

```bash
sudo systemctl restart nginx
```

---

## Reload Nginx

```bash
sudo systemctl reload nginx
```

---

## Verify Configuration

```bash
sudo nginx -t
```

---

## View Running Processes

```bash
ps -ef
```

---

## Check Listening Ports

```bash
sudo ss -tulnp
```

or

```bash
sudo netstat -tulnp
```

Expected

```
80

5000
```

---

## Check Port 5000

```bash
sudo lsof -i :5000
```

---

## Check Port 80

```bash
sudo lsof -i :80
```

---

# Production Best Practices

## ✅ Never Expose Backend Port

Bad

```
Public-IP:5000
```

Good

```
Public-IP

↓

Nginx

↓

Flask
```

---

## ✅ Use HTTPS

Production

```
HTTPS

↓

Nginx

↓

HTTP

↓

Flask
```

---

## ✅ Keep Backend Private

Only Nginx should be public.

Backend should remain

```
localhost
```

or

```
Private IP
```

---

## ✅ Use Systemd Service

Don't run

```bash
python3 app.py
```

in production.

Instead

Create

```
flask.service
```

so the application starts automatically after reboot.

Example

```bash
sudo systemctl start flask
```

---

## ✅ Use Gunicorn

Production Flow

```
User

↓

Nginx

↓

Gunicorn

↓

Flask
```

Gunicorn is a production-grade WSGI server.

---

## ✅ Use Load Balancer

One server

❌ Single Point of Failure

Multiple servers

```
ALB

↓

EC2-1

EC2-2

EC2-3
```

---

## ✅ Enable Monitoring

Use

- CloudWatch
- Prometheus
- Grafana

to monitor

- CPU
- Memory
- Network
- Disk

---

## ✅ Store Logs

Important Logs

```
/var/log/nginx/access.log

/var/log/nginx/error.log
```

Always check these during troubleshooting.

---

# Real Company Deployment Checklist

Before deployment

- EC2 Running
- Security Group Configured
- Python Installed
- Dependencies Installed
- Flask Working
- Nginx Installed
- Reverse Proxy Configured
- Configuration Tested
- Nginx Restarted
- Browser Tested
- Logs Verified

Only after all checks pass should the application be considered successfully deployed.

---

# ⭐ Key Takeaways

✔ Flask handles application logic.

✔ Nginx handles client requests.

✔ Reverse Proxy hides backend services.

✔ Users never access Flask directly.

✔ Production deployments always place Nginx (or another reverse proxy) in front of backend applications.

✔ This same deployment pattern is used for Flask, Django, Spring Boot, Node.js, ASP.NET, Go, PHP, and many other backend frameworks.

---

## ✅ End of Part 4

In **Part 5**, we'll cover:

- 20+ Production Interview Questions & Answers
- Scenario-Based Questions
- Quick Revision Table
- Summary
- Final Learning Outcomes
- Next Steps

- # 🎯 Part 5 — Interview Questions, Summary & Next Steps

Congratulations! 🎉

You have successfully deployed a **Python Flask Application** behind an **Nginx Reverse Proxy** on an AWS EC2 instance.

This is one of the most common production deployment architectures used in companies before moving to Docker and Kubernetes.

---

# 💼 Interview Questions & Answers

## Q1. What is a Reverse Proxy?

A Reverse Proxy is a server that receives client requests and forwards them to one or more backend servers. The client never communicates directly with the backend server.

---

## Q2. What is Nginx?

Nginx is a high-performance Web Server that can also act as a Reverse Proxy, Load Balancer, API Gateway, and Static File Server.

---

## Q3. Why do we use Nginx with Flask?

Flask is an application framework and its built-in server is meant for development. Nginx acts as the front-end server, handling client requests and forwarding them to Flask.

---

## Q4. Why shouldn't Flask be exposed directly?

Because:

- Backend Port becomes public
- Less Secure
- Difficult to configure HTTPS
- No Load Balancing
- Poor Performance

---

## Q5. Which port does Flask use?

Default

```
5000
```

---

## Q6. Which port does Nginx use?

Default

```
80
```

For HTTPS

```
443
```

---

## Q7. What is proxy_pass?

It forwards incoming client requests from Nginx to the backend application.

Example

```nginx
location / {

    proxy_pass http://127.0.0.1:5000;

}
```

---

## Q8. Why do we use localhost instead of Public IP?

Because Flask and Nginx are running on the same server.

Communication stays internal.

Faster and more secure.

---

## Q9. How do you check whether Flask is running?

```bash
curl http://localhost:5000
```

---

## Q10. How do you verify Reverse Proxy?

```bash
curl http://localhost
```

---

## Q11. How do you verify Nginx configuration?

```bash
sudo nginx -t
```

---

## Q12. Which command restarts Nginx?

```bash
sudo systemctl restart nginx
```

---

## Q13. Difference between Forward Proxy and Reverse Proxy?

| Forward Proxy | Reverse Proxy |
|---------------|---------------|
| Represents Client | Represents Server |
| Hides Client | Hides Backend Server |
| Used in Organizations | Used in Data Centers |
| Controls Client Requests | Controls Incoming Requests |

---

## Q14. Can Nginx perform Load Balancing?

Yes.

Example

```
              Nginx

         /      |      \

     Flask1 Flask2 Flask3
```

---

## Q15. Can Nginx terminate HTTPS?

Yes.

SSL Certificates are usually installed on Nginx.

Nginx forwards HTTP traffic to backend applications.

---

## Q16. What happens if Flask crashes?

Nginx remains running.

However,

clients receive

```
502 Bad Gateway
```

because the backend application is unavailable.

---

## Q17. What causes 502 Bad Gateway?

Possible Reasons

- Flask stopped
- Wrong proxy_pass
- Backend Port incorrect
- Backend crashed

---

## Q18. What causes 404 Not Found?

Usually

- Wrong Route
- Missing API
- Wrong URL

---

## Q19. What happens if Port 80 is already occupied?

Nginx cannot start.

Linux allows only one application to listen on a specific IP:Port combination.

---

## Q20. Which logs help during troubleshooting?

Nginx Logs

```
/var/log/nginx/access.log
```

```
/var/log/nginx/error.log
```

---

## Q21. Which command checks open ports?

```bash
sudo ss -tulnp
```

or

```bash
sudo netstat -tulnp
```

---

## Q22. Which command checks which process owns Port 80?

```bash
sudo lsof -i :80
```

---

## Q23. Which command checks Port 5000?

```bash
sudo lsof -i :5000
```

---

## Q24. Why is Nginx faster than many web servers?

Because Nginx uses an **event-driven asynchronous architecture**, allowing it to handle thousands of concurrent connections efficiently with lower resource usage.

---

## Q25. Why is Gunicorn used with Flask?

Gunicorn is a production-grade WSGI server.

Production Architecture

```
Internet

↓

Nginx

↓

Gunicorn

↓

Flask
```

---

# 🌍 Real-Time Production Example

Imagine Amazon.

Customer opens

```
amazon.com
```

Request Flow

```
Browser

↓

Route53

↓

Application Load Balancer

↓

Nginx

↓

Gunicorn

↓

Flask

↓

Database

↓

Flask

↓

Nginx

↓

Browser
```

Users never know

- Backend Port
- Server Location
- Programming Language

Everything is hidden behind Nginx and the Load Balancer.

---

# 🔥 Production Tips

✅ Keep backend ports private.

---

✅ Use HTTPS in production.

---

✅ Never expose Flask directly.

---

✅ Monitor Nginx logs regularly.

---

✅ Use Systemd Service for Flask.

---

✅ Use Gunicorn instead of Flask Development Server.

---

✅ Use ALB for High Availability.

---

✅ Use Auto Scaling Group for traffic spikes.

---

✅ Use CloudWatch for monitoring.

---

✅ Store application code in GitHub.

---

✅ Automate deployments using Jenkins or GitHub Actions.

---

# 🧠 Quick Revision

| Component | Purpose |
|-----------|---------|
| Flask | Backend Application |
| Python | Programming Language |
| Nginx | Web Server + Reverse Proxy |
| proxy_pass | Forward Requests |
| localhost:5000 | Backend Port |
| Port 80 | Public HTTP |
| curl | API Testing |
| nginx -t | Configuration Test |
| systemctl restart nginx | Restart Service |
| lsof | Check Port Usage |

---

# 📝 Summary

In this lab, we learned how to deploy a Flask application using **Nginx Reverse Proxy** on an AWS EC2 instance.

We installed Python, cloned the application from GitHub, installed dependencies, and started the Flask application on **Port 5000**. Since backend applications should not be exposed directly, we configured Nginx to listen on **Port 80** and forward incoming requests to Flask using the `proxy_pass` directive.

We verified the deployment using `curl`, tested it in the browser, and learned how to troubleshoot common issues such as **502 Bad Gateway**, **404 Not Found**, and incorrect Nginx configurations.

Finally, we explored production best practices, including using **Gunicorn**, **Application Load Balancers**, **Auto Scaling Groups**, **CloudWatch**, and **CI/CD pipelines** to build scalable and secure backend architectures.

---

# 🏆 Skills Gained

After completing this lab, you can confidently:

- ✅ Deploy a Flask application on AWS EC2.
- ✅ Install and configure Nginx.
- ✅ Configure Nginx as a Reverse Proxy.
- ✅ Understand request flow between client, Nginx, and Flask.
- ✅ Debug common Nginx and Flask issues.
- ✅ Explain Reverse Proxy concepts in interviews.
- ✅ Design a production-ready backend deployment architecture.

---

# 📚 Next Steps

Now that you understand Reverse Proxy, the next logical topics are:

- Gunicorn (Production WSGI Server)
- Systemd Service for Flask
- SSL/HTTPS with Let's Encrypt
- Application Load Balancer (ALB)
- Auto Scaling Group (ASG)
- Dockerizing Flask Application
- Deploying with Docker Compose
- Kubernetes Deployment
- CI/CD using Jenkins
- Monitoring with CloudWatch & Prometheus

---

# ⭐ Final Note

> **"A Flask application should never be directly exposed to the internet in production. Nginx acts as the secure entry point, handling client requests and forwarding them to the backend application. This architecture improves security, scalability, performance, and maintainability, making it the industry-standard deployment pattern for modern web applications."**

---

## 🎉 Congratulations!

You have successfully completed **Day 20 — Nginx Reverse Proxy with Flask Application (Production Deployment)**.

**Repository Status:** ✅ Production Deployment Completed
