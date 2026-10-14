
# AWS S3 + EC2 + Docker + Nginx — End-to-End POC

A beginner-friendly DevOps project demonstrating how to host a static website on Amazon S3, download the website file to an Amazon EC2 instance, and serve the same file through an Nginx Docker container.

## 📌 Project Overview

This project was built to understand how AWS cloud services and Docker work together in a practical deployment workflow.

Instead of only learning concepts theoretically, I created an S3 bucket, launched an EC2 instance, installed Docker, ran an Nginx container, and served my own HTML page through the container.

**Project level:** Beginner  
**Project type:** Proof of Concept (POC)  
**Cloud provider:** Amazon Web Services (AWS)

## 🎯 Project Objectives

- Understand Amazon S3 and static website hosting.
- Launch and connect to an Amazon EC2 Linux instance.
- Understand AWS Security Groups and network access.
- Install Docker on Amazon Linux 2023.
- Run an Nginx web server inside a Docker container.
- Create an IAM role that allows EC2 to read S3 objects.
- Download an HTML file from S3 to EC2.
- Serve the downloaded HTML file through a Docker container.
- Understand the relationship between cloud infrastructure, storage, containers, and web servers.

## 🏗️ Architecture

```text
                  AWS CLOUD
                      |
          +-----------+-----------+
          |                       |
     Amazon S3                Amazon EC2
          |                       |
     index.html          Amazon Linux 2023
          |                       |
          |                 Docker Engine
          |                       |
          |                 Nginx Container
          |                       |
          +---- HTML File --------+
                                  |
                            Port Mapping
                              8080:80
                                  |
                             Web Browser
                                  |
                          Custom HTML Page
```

### How the architecture works

1. **Amazon S3:** Stores the `index.html` file and independently hosts the static website.
2. **Amazon EC2:** Provides the virtual Linux server on which Docker runs.
3. **IAM Role:** Grants the EC2 instance permission to read objects from S3 without storing AWS access keys on the server.
4. **Docker:** Runs the Nginx web server in an isolated container.
5. **Nginx:** Serves the HTML file to visitors.
6. **Port Mapping:** Maps port `8080` on EC2 to port `80` inside the container.
7. **Web Browser:** Accesses the website through the EC2 public IPv4 address.

**Important:** S3 static website hosting and the Docker-hosted website are two separate ways of serving the same HTML content.

## 🛠️ Technologies Used

| Technology | Purpose |
|---|---|
| Amazon S3 | Object storage and static website hosting |
| Amazon EC2 | Virtual Linux server |
| Amazon Linux 2023 | Operating system |
| AWS IAM | Identity and access management |
| AWS Security Groups | Network traffic control |
| Docker | Container runtime |
| Nginx | Web server |
| HTML | Website content |
| AWS CLI | Interacting with AWS services from the terminal |
| GitHub | Source code and project documentation |

## 🚀 Implementation Steps

### Step 1: Create an S3 Bucket

Created an S3 general-purpose bucket named `mohanbucket101k`.

Uploaded a file named `index.html` containing a simple HTML webpage.

Enabled static website hosting and configured `index.html` as the index document.

**What I learned:** S3 can store static website files and serve HTML, CSS, JavaScript, and other static assets through its website endpoint.

### Step 2: Launch an EC2 Instance

Launched an EC2 instance using Amazon Linux 2023.

Configured the instance with a public IPv4 address and a security group.

Configured the required inbound access:

- SSH (TCP 22): Restricted to my public IP.
- HTTP (TCP 80): Used for HTTP website access.
- TCP 8080: Used to access the Docker-hosted Nginx website.

Connected to the Linux instance using EC2 Instance Connect.

**What I learned:** EC2 provides the compute environment required to run applications and containers in the cloud.

### Step 3: Install Docker

Updated the operating system packages:

```bash
sudo dnf update -y
```

Installed Docker:

```bash
sudo dnf install docker -y
```

Enabled and started the Docker service:

```bash
sudo systemctl enable --now docker
```

Verified the service:

```bash
sudo systemctl status docker
```

**What I learned:** Docker can run applications in containers without requiring a separate virtual machine for every application.

### Step 4: Run an Nginx Container

Started an Nginx container and mapped EC2 port 8080 to container port 80:

```bash
sudo docker run -d --name webtest -p 8080:80 nginx
```

Verified that the container was running:

```bash
sudo docker ps
```

Opened the website using the EC2 public IPv4 address:

```text
http://YOUR_EC2_PUBLIC_IP:8080
```

The default Nginx welcome page confirmed that the container was accessible.

**What I learned:** Docker images provide the application environment, containers run those images, and port mapping makes container services accessible from outside the container.

### Step 5: Create an IAM Role for S3 Access

Created an IAM role named `EC2S3ReadRole`.

Configured EC2 as the trusted service and attached the `AmazonS3ReadOnlyAccess` managed policy.

Attached the role to the EC2 instance.

Verified access to the S3 bucket from the EC2 terminal:

```bash
aws s3 ls
```

Listed the contents of the project bucket:

```bash
aws s3 ls s3://mohanbucket101k/
```

**What I learned:** IAM roles allow AWS services to access other AWS resources using temporary credentials instead of hard-coded access keys.

**Production improvement:** Replace the broad `AmazonS3ReadOnlyAccess` policy with a least-privilege policy restricted to the specific project bucket and required objects.

### Step 6: Download the HTML File from S3

Downloaded the website file to the EC2 instance:

```bash
aws s3 cp s3://mohanbucket101k/index.html ./index.html
```

Verified that the file was available locally:

```bash
ls -l index.html
```

**What I learned:** The AWS CLI can transfer objects between S3 and an EC2 instance when the instance has the required IAM permissions.

### Step 7: Copy the HTML File into the Nginx Container

Copied the downloaded file into the directory from which Nginx serves website content:

```bash
sudo docker cp ./index.html webtest:/usr/share/nginx/html/index.html
```

Verified the file contents:

```bash
sudo docker exec webtest cat /usr/share/nginx/html/index.html
```

Opened the Docker-hosted website again:

```text
http://YOUR_EC2_PUBLIC_IP:8080
```

The browser displayed my custom HTML page instead of the default Nginx welcome page.

**What I learned:** Docker containers can serve custom website content, and files can be copied between the EC2 host and a running container.

## 🔐 Security Considerations

This project is a learning POC, not a production-ready architecture.

- Restrict SSH access to your own public IP.
- Expose only the ports required by the application.
- Avoid opening all inbound traffic.
- Use IAM roles rather than storing AWS credentials in files.
- Use least-privilege IAM permissions for S3 access.
- Avoid storing sensitive information in a public S3 bucket.
- Remember that public S3 website hosting allows visitors to access publicly available website content.
- Use HTTPS through an appropriate service such as CloudFront when designing a production deployment.
- Monitor AWS resources and remove unused resources to avoid unnecessary charges.

## 🧪 Troubleshooting

| Problem | Possible solution |
|---|---|
| EC2 connection fails | Check instance status, security group, public IP, and network configuration. |
| Docker command not found | Verify that Docker is installed. |
| Docker service is inactive | Check the service using `sudo systemctl status docker`. |
| S3 access denied | Verify the IAM role, its permissions, and the bucket policy. |
| HTML file not found | Check the S3 object key and local file path. |
| Website is unreachable | Check the container status, port mapping, security group, and public IP. |
| Default Nginx page still appears | Verify that the custom HTML file was copied to `/usr/share/nginx/html/index.html`. |

## 📚 Key Learnings

Through this project, I gained practical exposure to:

- Provisioning cloud infrastructure on AWS.
- Configuring security groups and network access.
- Understanding object storage and static website hosting.
- Managing permissions through IAM roles.
- Installing and operating Docker on Linux.
- Running and inspecting Docker containers.
- Mapping host ports to container ports.
- Downloading files from S3 using the AWS CLI.
- Serving custom HTML content through Nginx.
- Troubleshooting real-world connectivity and deployment issues.

## 🔮 Future Enhancements

The next improvements I plan to explore are:

1. **Dockerfile:** Package the website into a reproducible custom Docker image instead of copying files into a running container.
2. **Git and GitHub:** Version-control the HTML file, Dockerfile, and deployment documentation.
3. **Automated Deployment:** Automate the download and deployment workflow.
4. **CI/CD Pipeline:** Build and deploy the Docker image automatically when code changes.
5. **Amazon ECR:** Store versioned Docker images in Amazon Elastic Container Registry.
6. **Application Load Balancer:** Distribute incoming traffic across multiple EC2 instances.
7. **Auto Scaling:** Automatically adjust compute capacity based on demand.
8. **HTTPS:** Secure browser connections using TLS.
9. **Amazon CloudWatch:** Monitor application logs and infrastructure metrics.
10. **Kubernetes:** Explore container orchestration after understanding Docker fundamentals.

## 💡 Conclusion

This POC helped me understand how Amazon S3, Amazon EC2, IAM, Docker, and Nginx can work together in a basic cloud deployment workflow.

I started with a simple HTML page, hosted it on S3, downloaded it to an EC2 instance, and served it through an Nginx Docker container.

The project strengthened my practical understanding of cloud infrastructure, Linux administration, containerization, access management, and web deployment.

**This is a learning project and a foundation for future DevOps automation and CI/CD projects.**
