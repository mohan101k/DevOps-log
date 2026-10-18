# AWS CloudFront + Application Load Balancer + EC2 Nginx

A hands-on AWS practice project demonstrating how to serve an Nginx web
page on an EC2 instance through an Application Load Balancer (ALB) and
Amazon CloudFront.

## Project status

-   **CloudFront viewer HTTPS:** Working
-   **CloudFront to ALB origin HTTPS:** Not configured yet
-   **ALB HTTP listener:** Working
-   **Nginx page through CloudFront:** Verified

> **Important security note:** The browser-to-CloudFront connection is
> HTTPS, but the current CloudFront-to-ALB connection uses HTTP on port
> 80. This is not end-to-end HTTPS. Origin-side HTTPS is a separate
> improvement and requires a valid certificate matching the origin
> hostname and an HTTPS listener on the ALB.

## Architecture

``` text
Browser
  |
  | HTTPS (443)
  v
Amazon CloudFront
  |
  | HTTP (80) - current configuration
  v
Application Load Balancer
  |
  | Forwards to target group
  v
EC2 instance
  |
  v
Nginx welcome page
```

## AWS resources

  Resource                     Value
  ---------------------------- ---------------------------------------------------
  AWS Region                   `us-east-1` (N. Virginia)
  CloudFront distribution ID   `E2ZZ1G0U2S5PCW`
  CloudFront domain            `d24dinsq5ztv1.cloudfront.net`
  ALB name                     `mohan-alb`
  ALB DNS name                 `mohan-alb-652887542.us-east-1.elb.amazonaws.com`
  Target group                 `mohan-ec2-tg`
  Web server                   Nginx on EC2

These are the values from this practice environment. If you recreate
resources, check the current IDs and DNS names in the AWS Console before
using them.

## What I did

1.  Ran Nginx on an EC2 instance.
2.  Configured an Application Load Balancer to forward HTTP traffic to
    the EC2 target group.
3.  Configured a CloudFront distribution with the ALB as its origin.
4.  Tested the ALB URL over HTTP and confirmed the Nginx welcome page
    loaded.
5.  Tested the CloudFront URL over HTTPS and confirmed the same page
    loaded.
6.  Checked the browser's connection information and verified that the
    CloudFront connection was secure.
7.  Compared the two endpoints and identified that the ALB origin
    connection still uses HTTP.

## Validation

CloudFront endpoint:

`https://d24dinsq5ztv1.cloudfront.net`

ALB endpoint (HTTP):

`http://mohan-alb-652887542.us-east-1.elb.amazonaws.com`

Expected result: - CloudFront URL loads the Nginx welcome page over
HTTPS. - ALB URL loads the Nginx welcome page over HTTP. - Browser
indicates a secure connection for the CloudFront URL.

## What I learned

-   How CloudFront acts as a distribution layer in front of an origin.
-   How an ALB forwards requests to a target group.
-   How an EC2 instance can host Nginx.
-   How to test endpoints using a browser and inspect connection
    security.
-   Viewer-side HTTPS and origin-side HTTPS are separate connections.
-   A successful HTTPS connection to CloudFront does not automatically
    encrypt traffic between CloudFront and the ALB.

## Next improvement: HTTPS from CloudFront to ALB

To encrypt the CloudFront-to-ALB connection:

1.  Configure a domain name and DNS record that point to the ALB.
2.  Request a public certificate in AWS Certificate Manager (ACM) and
    complete DNS validation.
3.  Wait until the certificate status is `Issued`.
4.  Add an HTTPS listener on ALB port `443` and attach the matching
    certificate.
5.  Confirm the ALB security group allows inbound HTTPS traffic from the
    intended sources.
6.  Change the CloudFront origin protocol policy to **HTTPS only** and
    use port `443`.
7.  Wait for the CloudFront distribution to finish deploying.
8.  Test the CloudFront endpoint and troubleshoot any origin errors.

The hostname CloudFront uses to connect to the origin must match the
certificate. A certificate issued for an EC2 `nip.io` hostname will not
validate the default AWS ALB hostname.

## Suggested repository structure

``` text
.
├── README.md
└── screenshots/
    ├── cloudfront-https.png
    └── alb-http.png
```

Add your own screenshots to the `screenshots/` folder. Only include
screenshots you are comfortable sharing publicly.

## Cost and cleanup

AWS resources such as EC2, Application Load Balancers, public IPv4
addresses, and CloudFront usage may incur charges. Check current AWS
pricing and account usage. Stop or delete resources when you no longer
need them, after confirming you will not need the environment again.

## Interview explanation

> I hosted Nginx on EC2, routed requests through an Application Load
> Balancer, and configured CloudFront with the ALB as the origin. I
> verified that the CloudFront endpoint was accessible over HTTPS.
> During testing, I learned that viewer-side HTTPS and origin-side HTTPS
> are separate connections, so configuring HTTPS on the ALB origin is
> the next step.

## Security reminders

-   Never commit AWS access keys, credentials, private keys, or
    certificate files such as `privkey.pem`.
-   Do not put secrets in screenshots or README files.
-   Re-check security group rules and avoid opening ports more broadly
    than required.
