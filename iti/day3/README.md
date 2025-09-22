# 🌍 AWS Infrastructure Automation with Terraform & Ansible

![Terraform](https://img.shields.io/badge/Terraform-IaC-blueviolet?logo=terraform)
![NGINX](https://img.shields.io/badge/NGINX-Reverse%20Proxy-green?logo=nginx)
![AWS](https://img.shields.io/badge/AWS-Cloud-orange?logo=amazonaws)

## 📌 Overview
This project provisions a **highly available AWS infrastructure** with **Terraform (modular approach)**  
and configures **NGINX reverse proxies + backend web servers**.  

The setup demonstrates how to automate **infrastructure provisioning and instance configuration** end-to-end.

---

## 🏗️ Architecture
- **VPC (10.0.0.0/16)** with multiple **public** and **private** subnets  
- **NGINX Reverse Proxies** (public subnets) to handle incoming requests  
- **Backend EC2 Instances** (private subnets) secured from direct internet access  
- **Application Load Balancer (ALB)** for traffic distribution  
- **Security Groups** with least-privilege rules  

📌 *Diagram
<img width="1115" height="586" alt="image" src="https://github.com/user-attachments/assets/73d9ad8b-1c1a-4ff7-92a5-01986f009441" />

---

## ⚙️ Tools & Technologies

| Tool         | Purpose |
|--------------|---------|
| **Terraform** | Infrastructure provisioning (VPC, EC2, ALB, SGs) |
| **AWS EC2**   | Compute resources for proxy & backend servers |
| **NGINX**     | Reverse proxy for traffic routing |

---

## 🚀 Features
- ✅ **Modular Terraform** setup for reusable infrastructure code  
- ✅ **Ansible automation** for consistent server configuration  
- ✅ **Private subnet isolation** for backend workloads  
- ✅ **Scalable & highly available** architecture with multi-AZ deployment  

---

## 📂 Project Structure
```bash
├── day3/        # Terraform modules & root configs
├── day3/instances #instances config files
├── day3/network #network config files for vpc, subnets ... etc
├── day3/load-balancers #config files for the load balancers i used

