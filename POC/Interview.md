
# POC 01 — AWS S3 + EC2 + IAM + Docker + Nginx

## 1. Project overview

This POC demonstrates a **manual deployment workflow**. An HTML file is stored in Amazon S3, downloaded onto an Amazon EC2 instance using the AWS CLI and an attached IAM role, copied into an Nginx Docker container, and served to a browser.

### Architecture

```text
Amazon S3 (index.html)
        |
        | AWS CLI + EC2 IAM role
        v
Amazon EC2 (Amazon Linux 2023)
        |
        | docker cp
        v
Nginx Docker container (port 80)
        ^
        | Docker port mapping: host 8080 -> container 80
        |
Browser: http://<EC2-PUBLIC-IP>:8080
```

### Main components

| Component | Purpose |
|---|---|
| Amazon S3 | Stores the HTML file as an object |
| IAM role (`EC2S3ReadRole`) | Allows EC2 to access S3 without hardcoded access keys |
| EC2 | Provides the Linux server |
| AWS CLI | Lists S3 objects and downloads the HTML file |
| Docker | Runs Nginx in an isolated container |
| Nginx | Serves the HTML page |
| EC2 Security Group | Controls inbound and outbound network traffic |

Example names used in the lab:
- S3 bucket: `mohanbucket101k`
- Container: `webtest`
- Image: `nginx`
- Host port: `8080`
- Container port: `80`

> Replace example names and the public IP with the values in your own AWS environment.

## 2. Interview questions and answers

### Q1. What did you build in this POC?

**Answer:** I built a manual deployment POC using Amazon S3, EC2, IAM, Docker, and Nginx. I stored an HTML file in S3, downloaded it to EC2 using the AWS CLI and an attached IAM role, copied it into the Nginx container, and accessed it through the EC2 public IP on port 8080.

### Q2. Why did you use an IAM role on EC2 instead of AWS access keys?

**Answer:** An IAM role provides temporary credentials to the EC2 instance. This avoids hardcoding or manually managing long-term access keys on the server. The role should follow least privilege and grant only the S3 actions and resources required.

### Q3. What is the purpose of Amazon S3 in this project?

**Answer:** S3 stores the HTML file as an object. In this workflow, S3 is the source location; the file is downloaded to EC2 and then served by Nginx.

### Q4. Why did you use EC2?

**Answer:** EC2 provides a cloud-based Linux server where I can install Docker, use the AWS CLI, download the HTML file, and run the web server container.

### Q5. What does `-p 8080:80` mean in Docker?

**Answer:** It maps **host port 8080** to **container port 80**. A request to the EC2 host on port 8080 is forwarded to Nginx on port 80 inside the container. This Docker mapping does not automatically open the port in the AWS Security Group.

### Q6. Why did you use Nginx?

**Answer:** Nginx is a web server that serves the HTML file to the browser. The official Nginx image includes a default document root at `/usr/share/nginx/html`.

### Q7. What does this command do?

```bash
sudo docker run -d --name webtest -p 8080:80 nginx
```

**Answer:**
- `sudo`: runs the command with elevated privileges.
- `docker run`: creates and starts a container.
- `-d`: runs it in detached/background mode.
- `--name webtest`: assigns the container the name `webtest`.
- `-p 8080:80`: maps host port 8080 to container port 80.
- `nginx`: specifies the image to run.

### Q8. How did you download the file from S3 to EC2?

```bash
aws s3 cp s3://mohanbucket101k/index.html ./index.html
```

**Answer:** `aws s3 cp` copies an object between S3 and a local path. The S3 URI is the source and `./index.html` is the destination in the current working directory. This command downloads the object; it does not delete it from S3.

### Q9. Why did you use `docker cp`?

```bash
sudo docker cp ./index.html webtest:/usr/share/nginx/html/index.html
```

**Answer:** It copies the HTML file from the EC2 host filesystem into the running container, replacing the default Nginx index page at the document-root path.

### Q10. How did you verify that the container was running?

```bash
sudo docker ps
```

**Answer:** It lists running containers. I checked the container name, image, status, and port mapping.

To include stopped containers:

```bash
sudo docker ps -a
```

### Q11. How did you verify the HTML file inside the container?

```bash
sudo docker exec webtest cat /usr/share/nginx/html/index.html
```

**Answer:** `docker exec` runs a command inside a running container. `cat` prints the file content so I can verify that the expected HTML was copied.

### Q12. What would you check if the website showed “connection refused”?

**Answer:** I would troubleshoot layer by layer:
1. Confirm the EC2 instance is running and I am using its current public IP.
2. Check the Security Group inbound rule for TCP port 8080 and ensure the source is appropriately restricted.
3. Run `sudo docker ps` to confirm the container is running and the port mapping is present.
4. Check `sudo docker logs webtest`.
5. Verify that Nginx is serving the expected file.

“Connection refused” often points to a service or port that is not listening/reachable; a missing Security Group rule can instead cause a timeout, depending on the situation.

### Q13. What if the Nginx default welcome page still appears?

**Answer:** Check that the correct file was copied to `/usr/share/nginx/html/index.html` inside the correct container. Verify its contents with `docker exec ... cat ...`, then refresh the browser. A container restart is normally not required just because a static HTML file was overwritten.

### Q14. How would you update the HTML file?

**Answer:** Edit the source file, upload it to S3 if S3 is the source of truth, download the updated object to EC2, and copy it into the Nginx document root again. Then refresh the browser. A restart is usually unnecessary for a static HTML file copied into the running container.

### Q15. What if port 8080 is missing from the Security Group?

**Answer:** Open the EC2 instance's Security Group, edit inbound rules, and add a TCP rule for port 8080 with the narrowest suitable source, such as my public IP. Save the rule and test again. Avoid leaving `0.0.0.0/0` open unnecessarily.

### Q16. How can you troubleshoot a container that has stopped?

**Answer:** Use `sudo docker ps -a` to see stopped containers and `sudo docker logs webtest` to inspect their logs. Then investigate the error before restarting or recreating the container.

### Q17. Can this setup serve multiple HTML pages?

**Answer:** Yes. Place pages such as `index.html` and `about.html`, along with CSS and image assets, in the Nginx document root and link to them using relative paths. S3 can also store the site files, but serving the site directly from S3 static website hosting is a different architecture from serving it through EC2 and Nginx.

### Q18. Did you implement CI/CD?

**Answer:** No. This was a manual deployment POC. I manually downloaded the file from S3 and copied it into the container. A future improvement would be to automate testing and deployment with a CI/CD pipeline.

### Q19. What are the main limitations of this POC?

**Answer:** The deployment is manual, the HTML is copied into a running container rather than baked into a custom image, and CI/CD, HTTPS, automated rollback, and production monitoring were not implemented end-to-end.

### Q20. Explain the project in an interview.

**Answer:**  
“I built an end-to-end manual deployment POC using Amazon S3, EC2, IAM, Docker, and Nginx. I uploaded an HTML file to S3 and attached an IAM role to EC2 so the instance could access S3 without hardcoded access keys. Using the AWS CLI, I downloaded the file onto the EC2 instance, ran an Nginx Docker container with host port 8080 mapped to container port 80, and copied the HTML file into Nginx’s document root. I then verified the page through the EC2 public IP on port 8080. This helped me practise IAM permissions, Linux administration, cloud storage, containerization, port mapping, and basic troubleshooting.”

## 3. Commands quick reference

| Command | Purpose |
|---|---|
| `sudo dnf update -y` | Updates installed packages where updates are available |
| `sudo dnf install docker -y` | Installs the Docker package |
| `sudo systemctl enable --now docker` | Enables Docker at boot and starts it now |
| `sudo systemctl status docker` | Shows Docker service status |
| `sudo docker run -d --name webtest -p 8080:80 nginx` | Creates and starts an Nginx container |
| `sudo docker ps` | Lists running containers |
| `sudo docker ps -a` | Lists all containers, including stopped ones |
| `aws s3 ls` | Lists buckets visible to the current AWS identity, subject to permissions |
| `aws s3 ls s3://mohanbucket101k/` | Lists objects in the specified bucket, subject to permissions |
| `aws s3 cp s3://mohanbucket101k/index.html ./index.html` | Downloads the S3 object to the current directory |
| `sudo docker cp ./index.html webtest:/usr/share/nginx/html/index.html` | Copies the file into the container |
| `sudo docker exec webtest cat /usr/share/nginx/html/index.html` | Prints the file inside the running container |
| `sudo docker logs webtest` | Shows container logs |

### Useful command meanings

- `sudo`: run a command with elevated privileges.
- `dnf`: package manager used by Amazon Linux 2023.
- `systemctl`: manages systemd services.
- `enable`: configure a service to start at boot.
- `--now`: also apply the start/stop action immediately.
- `-y`: automatically answer yes to package-manager confirmation prompts.
- `./`: current working directory.
- `cp`: copy.
- `cat`: print file contents.
- `-d`: detached mode.
- `-p`: publish/map container ports.

## 4. Troubleshooting checklist

| Symptom | Checks |
|---|---|
| `AccessDenied` from S3 | Confirm the role is attached, its policy permits the required action/resource, and the bucket policy/KMS permissions do not deny access |
| `aws: command not found` | Confirm AWS CLI is installed and available in `PATH` |
| Docker service is inactive | Check `sudo systemctl status docker` and service logs |
| Container is missing or stopped | Run `sudo docker ps -a` |
| Container exits unexpectedly | Run `sudo docker logs webtest` |
| Website times out | Check public IP, network path, Security Group inbound TCP 8080, and routing |
| Website returns Nginx default page | Verify the HTML file path and content inside the correct container |
| Browser shows an old page | Confirm the file was updated, then hard-refresh the browser and consider caching |

## 5. Security notes

- Prefer least-privilege IAM policies scoped to the required bucket and actions.
- Restrict SSH access to a trusted IP or use an approved management method.
- Restrict port 8080 to the intended audience; do not leave it broadly exposed without a reason.
- S3 static website hosting with public-read access makes content publicly accessible. Use it only for content intended to be public and follow the required bucket/public-access configuration carefully.
- This POC uses HTTP for basic learning. Production deployments should assess HTTPS, access control, logging, updates, monitoring, and a secure deployment process.

## 6. Suggested next improvements

1. Build a custom Docker image with a `Dockerfile`.
2. Use a mounted volume or a repeatable deployment method rather than manual file copying.
3. Automate testing and deployment with CI/CD.
4. Add HTTPS and appropriate monitoring/logging.
5. Replace broad permissions and open network rules with least-privilege settings.
