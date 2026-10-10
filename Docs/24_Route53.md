# AWS Route 53 Notes for DevOps Beginners

Simple Hinglish notes for quick reading and GitHub revision.

## 1. What is Route 53?

Amazon Route 53 is an AWS DNS service.

DNS domain name ko IP address ya application endpoint se map karne mein help karta hai.

**Example:**

`app.example.com` → Application Load Balancer (ALB) → EC2 application

**Important:** Route 53 DNS resolution karta hai. Actual HTTP/HTTPS application traffic usually selected endpoint, jaise ALB ya server, tak directly jaata hai.

## 2. How DNS Request Works

1. User browser mein `app.example.com` enter karta hai.
2. DNS resolver domain ka answer find karta hai.
3. Route 53 configured DNS record aur routing policy ke according answer deta hai.
4. Browser selected IP/endpoint ko request bhejta hai.
5. Application response return karti hai.

## 3. Route 53 Routing Policies

| Policy | Simple Meaning | Example Use |
|---|---|---|
| Simple | Basic DNS response | Single website |
| Weighted | Set kiye gaye weights ke according answers | 90/10 traffic split |
| Latency-based | AWS latency data ke basis par suitable Region select karta hai | Global users |
| Failover | Primary/secondary DNS response setup | Disaster recovery |
| Geolocation | User ki geographic location ke basis par | Country-specific website |
| Geoproximity | Resource aur user ki location, optional bias ke saath | Regional traffic control |
| Multivalue answer | Multiple healthy record values return kar sakta hai | Basic DNS-level availability |
| IP-based | Client IP range ke basis par answer | Specific network routing |

**Remember:**
- Weighted routing DNS answers ko weight karta hai; exact HTTP request ratio guarantee nahi hota.
- Latency-based routing hamesha geographically nearest server select nahi karta.
- DNS failover instant hone ki guarantee nahi hai. TTL aur DNS caching impact karte hain.

## 4. Public vs Private Hosted Zone

### Public Hosted Zone
- Public DNS records store karta hai.
- Internet users domain resolve kar sakte hain.
- Example: `www.example.com`
- Public website ya public ALB ke liye useful.

### Private Hosted Zone
- Associated VPCs ke andar private DNS resolution ke liye.
- Example: `db.internal.example.com`
- Internal applications aur services ke liye useful.

**Important:** Private Hosted Zone apne aap application ko secure nahi karti. Security Groups, routing, IAM aur application permissions bhi important hain.

## 5. DNS Records

| Record | Meaning | Example |
|---|---|---|
| A | Domain ko IPv4 address se map karta hai | `app.example.com` → `192.0.2.10` |
| AAAA | Domain ko IPv6 address se map karta hai | `app.example.com` → IPv6 address |
| CNAME | Ek DNS name ko doosre DNS name se map karta hai | `www.example.com` → `app.example.com` |
| Alias | Route 53 feature; supported AWS resources ko target kar sakta hai | `example.com` → ALB |

### Alias vs CNAME
- Route 53 Alias record ALB jaise supported AWS resources ko point kar sakta hai.
- Alias root/apex domain, jaise `example.com`, par bhi use ho sakta hai.
- Standard CNAME root/apex domain par use nahi kar sakte.
- A record IPv4 ke liye; AAAA IPv6 ke liye.

## 6. Subdomain, NS and TTL

- **Subdomain:** Parent domain ka child name. Example: `api.example.com`, `dev.example.com`.
- **NS record:** Domain ya subdomain ke authoritative DNS name servers identify karta hai. NS delegation se subdomain ka DNS management doosri hosted zone ko diya ja sakta hai.
- **TTL (Time To Live):** DNS answer cache mein kitni der reh sakta hai.
- TTL `300` seconds = 5 minutes.

DNS record update karne ke baad kuch users ko caching ki wajah se old answer temporarily mil sakta hai.

## 7. Route 53 + ALB + EC2 Flow

`User → DNS Resolver → Route 53 → ALB → Target Group → EC2/Nginx → Application`

- Route 53 domain resolve karta hai.
- ALB incoming HTTP/HTTPS requests receive karta hai.
- Listener rules request ko correct Target Group tak route kar sakte hain.
- Target Group healthy EC2 instances ko traffic bhejta hai.
- Nginx application serve ya reverse proxy kar sakta hai.

## 8. Useful DNS Commands

```bash
# Domain resolve karna
nslookup app.example.com

# Detailed DNS information
dig app.example.com

# A record
dig A app.example.com

# AAAA record
dig AAAA app.example.com

# Domain ke nameservers
dig NS example.com

# Answer aur TTL dekhna
dig app.example.com +noall +answer

# HTTPS response check karna
curl -I https://app.example.com
```

DNS issue troubleshoot karte waqt check karo:
1. Record name aur value correct hain?
2. Domain ke registrar par correct nameservers configured hain?
3. TTL/cache ki wajah se old answer toh nahi?
4. ALB/EC2 endpoint healthy aur reachable hai?
5. Security Group, route tables aur application port correct hain?

## 9. DevOps Fresher Learning Roadmap

Recommended order:

1. **Linux:** permissions, processes, services, logs, storage and Bash basics.
2. **Docker:** images, containers, Dockerfile, ports, volumes, networks and Compose.
3. **Git:** branches, merge, pull requests and conflict resolution.
4. **CI/CD:** GitHub Actions ya GitLab CI/CD; build, test and deploy pipeline.
5. **Terraform:** providers, resources, variables, outputs, state and modules.
6. **Monitoring:** CloudWatch metrics, logs and alarms.
7. **Security:** IAM roles, least privilege, secrets and Security Groups.
8. **Kubernetes:** Pods, Deployments, Services, ConfigMaps, Secrets and `kubectl`.

## 10. Practical Project Idea

Build an automated deployment project:

`GitHub → CI/CD Pipeline → Docker Image → EC2/ALB → Route 53 → CloudWatch`

Practice tasks:
- Dockerize a simple Flask or web application.
- Deploy it on EC2.
- Put an ALB in front of the application.
- Use Route 53 to connect a domain to the ALB (domain required).
- Automate build/deployment with GitHub Actions or GitLab CI/CD.
- Monitor logs and metrics using CloudWatch.
- Later, use Terraform to create the infrastructure.

**Cost tip:** AWS resources such as ALB, NAT Gateway and Route 53 hosted zones can incur charges. Delete lab resources when finished and check current AWS pricing.

## 11. Quick Interview Revision

- **Route 53:** AWS DNS service.
- **Hosted Zone:** DNS records ka container.
- **A:** IPv4; **AAAA:** IPv6.
- **CNAME:** DNS name ko another DNS name se map karta hai.
- **Alias:** Route 53 feature for supported AWS resources.
- **TTL:** DNS caching duration.
- **Latency routing:** Measured network latency ke basis par suitable endpoint.
- **Weighted routing:** DNS responses ko configured weights ke according distribute karta hai.
- **Failover routing:** Primary/secondary DNS response setup.
- **Public vs Private Zone:** Public DNS vs VPC-associated private DNS resolution.

## Official Documentation

- [Route 53 routing policies](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html)
- [Route 53 concepts](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/route-53-concepts.html)
- [Route 53 record types](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/ResourceRecordTypes.html)

