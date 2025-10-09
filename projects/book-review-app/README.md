# 📦 3-Tier Web Application Deployment on AWS with Terraform

[![Terraform](https://img.shields.io/badge/Terraform-0.15.0-blue?logo=terraform)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-ff9900?logo=amazon-aws)](https://aws.amazon.com/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

---

## 🚀 Project Overview

This project demonstrates provisioning a **3-tier web application** using **Terraform** and **AWS** services.

The application architecture:

- **Frontend Tier** — React static site hosted on S3.
- **Backend Tier** — EC2 instances serving backend logic, behind an Application Load Balancer (ALB).
- **Database Tier** — AWS RDS instance storing application data.

Additional AWS services include: S3, ALB, Auto Scaling Groups, Secrets Manager, CloudWatch, SNS, and SQS.

---
<img width="824" height="708" alt="image" src="https://github.com/user-attachments/assets/859354d7-94d7-4818-8f38-d5942a785241" />


## 🛠 Features

### **Infrastructure as Code**
- Complete AWS infrastructure provisioned via Terraform.
- Terraform state stored securely in S3 with locking enabled.

### **Infrastructure as Code Best Practice**
- Divided the Project into modules each one is responsible for a part of the application.
- Made the project configuration and variable setting be in a central place in main.tf

### **Frontend**
- S3 bucket hosting React frontend as a static website.
- Dynamic ALB DNS written to a file and uploaded to frontend S3 bucket for backend connectivity.

### **Backend**
- S3 bucket storing backend code.
- EC2 instances download backend code on launch using User Data scripts.
- Made the backend instances in private subnets to be more secure.
- Auto Scaling Group (ASG) with policies for load management.
- IAM Role for backend EC2 to access AWS services securely.
- Only Needed IAM policy for Least privilege architecture pattern.

### **Security**
- Created Private Subnets for the backend instances and the RDS Database.
- Stated that backend instances security groups allow inbound only from the ALB security group.
- Stated that RDS security group allow inbound only from the backend instances security group.

### **Networking**
- Private subnets for backend instances and RDS database
- Public subnets for the ALB
- Application Load Balancer (ALB) for request routing.
- Target Group linked to backend EC2 instances.
- Nat gateway for backend ec2 instances to reach the internet without being publically accessible.

### **Database**
- RDS MySQL/PostgreSQL instance.
- AWS Secrets Manager storing database credentials securely.

### **Monitoring & Scaling**
- CloudWatch Alarms trigger auto-scaling of backend EC2 instances.

### **Messaging**
- SNS Topic for review notifications.
- SQS queue for queued review messages.
- Email subscription to SNS for notifications.

---

## 🏗 Architecture Diagram

[React Frontend (S3 Static Website)]
│
[ALB DNS file in S3]
│
[Application Load Balancer]
│
[Auto Scaling Group of EC2 Backend Instances]
│
[RDS Database]
│
[Secrets Manager (DB credentials)]

[SNS Topic] → [SQS Queue] → Backend Processing
→ Email Subscription


---

## ⚙️ AWS Services Used

| Service                | Purpose |
|------------------------|---------|
| S3                     | Static website hosting, backend code storage, Terraform state backend |
| EC2                    | Backend application servers |
| Auto Scaling Group    | Auto-scale backend instances |
| Application Load Balancer | Routes traffic to backend instances |
| RDS                    | Database tier |
| Secrets Manager       | Secure DB credentials storage |
| CloudWatch            | Monitoring and scaling triggers |
| SNS                    | Review notifications |
| SQS                    | Review message queue |
| IAM Roles/Policies    | Secure access management |

---
## ⚙️ Project Structure
<img width="330" height="717" alt="image" src="https://github.com/user-attachments/assets/7266dea4-064e-432c-9406-1bd68847a22e" />


## 💡 How It Works

1. **Terraform Provisioning**  
   Terraform provisions all AWS resources and stores state in an S3 bucket for safety.

2. **Frontend Hosting**  
   React build uploaded to an S3 bucket as a static site. ALB DNS file is uploaded for dynamic backend access.

3. **Backend Provisioning**  
   EC2 instances in ASG download backend code on creation via User Data. Instances registered in ALB target group.

4. **Database Access**  
   EC2 instances fetch database credentials securely from Secrets Manager.

5. **Scaling**  
   CloudWatch monitors metrics and triggers scaling actions.

6. **Notifications**  
   SNS delivers review notifications to SQS queue and sends emails to subscribers.

---

---

## 🚀 Deployment Instructions

1. Install Terraform:  
   [Terraform Installation Guide](https://developer.hashicorp.com/terraform/downloads)

2. Configure AWS CLI:  
   ```bash
   aws configure

---

## 🚀 Deployment Instructions

1. Install Terraform:  
   [Terraform Installation Guide](https://developer.hashicorp.com/terraform/downloads)

2. Configure AWS CLI:  
   ```bash
   aws configure


3. Initialize Terraform:
   ```bash
   terraform init


4. Apply Terraform:
   ```bash
   terraform apply


Access frontend via S3 bucket URL or CloudFront distribution.

## 🛡 Security Considerations

Terraform state stored in S3 with versioning and locking.

Backend EC2 IAM roles restrict access to necessary resources.

Database credentials stored in AWS Secrets Manager.

Public access to S3 buckets is blocked unless required.

## 📈 Possible Improvements

Add CloudFront for frontend CDN caching and HTTPS.

Use Terraform modules for reusable infrastructure.

Implement CI/CD pipelines for automated deployment.

Add HTTPS for backend ALB with ACM certificates.

Add AWS WAF for enhanced security.

📚 References

Terraform Documentation

AWS S3 Static Website Hosting

AWS Auto Scaling

AWS Secrets Manager

Author: Mohamed Abd Elsattar







