AWS Infrastructure Automation with Terraform & Ansible
📌 Project Overview

This project provisions a highly available and secure AWS architecture using Terraform for Infrastructure as Code (IaC) and Ansible for configuration management.
It demonstrates how to build a scalable cloud environment with a reverse proxy layer (NGINX), backend web servers, and load balancing across multiple Availability Zones.

🏗️ Architecture

  VPC (10.0.0.0/16) with public and private subnets across two Availability Zones for high availability.

  NGINX reverse proxies deployed in public subnets to handle incoming traffic.

  Backend web servers (BE WS) running in private subnets, isolated from the internet.

  Application Load Balancers (ALB) to distribute requests between proxies and backend instances.

  Security Groups configured to strictly control communication between components.

⚙️ Tools & Technologies

Terraform

  Modularized infrastructure code for reusability and scalability.

  Automated provisioning of networking, compute, and load balancing.

Ansible

  Configured NGINX reverse proxies.

  Automated backend server setup and system hardening.

AWS Services
  VPC, EC2, ALB, Security Groups, Subnets.

🚀 Features

  End-to-end automation of infrastructure provisioning and configuration.

  Idempotent deployments: safe to re-run without breaking the environment.

  Zero-downtime design using multi-AZ architecture and load balancing.

  Backend workloads secured in private subnets with only proxies exposed to the internet.

📊 Results

  Reduced provisioning and configuration time by ~80% compared to manual setup.

  Delivered a production-ready, resilient, and secure environment.

  Demonstrates best practices in IaC, configuration management, and cloud architecture design.
