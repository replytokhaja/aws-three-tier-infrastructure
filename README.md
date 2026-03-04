# AWS Three-Tier Infrastructure with Terraform

![Terraform](https://img.shields.io/badge/Terraform-1.6+-7B42BC?logo=terraform)
![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?logo=amazonaws)
![CI](https://img.shields.io/badge/CI-GitHub_Actions-2088FF?logo=githubactions)
![License](https://img.shields.io/badge/License-MIT-green)

A production-grade, highly available **three-tier AWS architecture** fully automated with Terraform modules. Deploys a complete VPC, Application Load Balancer, Auto Scaling EC2 group, and RDS MySQL database across two Availability Zones.

---

## 🏗️ Architecture

```
Internet
    │
    ▼
┌─────────────────────────────────────────────────┐
│              Application Load Balancer           │
│         (Public Subnets — us-east-1a/1b)        │
└────────────────────┬────────────────────────────┘
                     │
    ┌────────────────▼────────────────┐
    │     Auto Scaling Group (EC2)    │
    │   (Private Subnets — App Tier)  │
    │   Min: 1 | Max: 4 | Desired: 2  │
    └────────────────┬────────────────┘
                     │
    ┌────────────────▼────────────────┐
    │       RDS MySQL 8.0             │
    │  (DB Subnets — Database Tier)   │
    │    Encrypted | Backup: 7 days   │
    └─────────────────────────────────┘
```

### Network Layout

| Layer | Subnet | CIDR | AZ |
|-------|--------|------|----|
| ALB (Public) | public-subnet-1 | 10.0.1.0/24 | us-east-1a |
| ALB (Public) | public-subnet-2 | 10.0.2.0/24 | us-east-1b |
| EC2 (Private) | private-subnet-1 | 10.0.11.0/24 | us-east-1a |
| EC2 (Private) | private-subnet-2 | 10.0.12.0/24 | us-east-1b |
| RDS (DB) | db-subnet-1 | 10.0.21.0/24 | us-east-1a |
| RDS (DB) | db-subnet-2 | 10.0.22.0/24 | us-east-1b |

---

## ✅ Features

- **Multi-AZ** deployment across 2 Availability Zones
- **Auto Scaling Group** with CPU-based scaling policies (scale up >70%, scale down <20%)
- **Application Load Balancer** with health checks
- **NAT Gateways** per AZ for private subnet internet access
- **Least-privilege Security Groups** — EC2 only accepts traffic from ALB, RDS only accepts traffic from EC2
- **RDS MySQL 8.0** with encrypted storage, automated backups (7 days), CloudWatch logging
- **IAM Role** for EC2 with SSM access (no SSH keys needed) and CloudWatch agent
- **CloudWatch Alarms** for ASG CPU-based auto scaling
- **GitHub Actions CI** — runs `terraform fmt`, `validate`, and `plan` on every PR
- **Modular structure** — each layer is an independent reusable module

---

## 📁 Project Structure

```
aws-three-tier-infrastructure/
├── main.tf                    # Root module — wires all modules together
├── variables.tf               # Input variables
├── outputs.tf                 # Output values
├── .gitignore
├── modules/
│   ├── vpc/                   # VPC, subnets, IGW, NAT GW, route tables
│   ├── security-groups/       # ALB, EC2, RDS security groups
│   ├── alb/                   # Application Load Balancer + Target Group
│   ├── ec2/                   # Launch Template + ASG + IAM + CloudWatch
│   └── rds/                   # RDS MySQL + subnet group
├── environments/
│   └── dev/
│       └── terraform.tfvars   # Environment-specific variables
└── .github/
    └── workflows/
        └── terraform-ci.yml   # GitHub Actions CI pipeline
```

---

## 🚀 How to Deploy

### Prerequisites

- [Terraform >= 1.3.0](https://developer.hashicorp.com/terraform/downloads)
- AWS CLI configured (`aws configure`)
- AWS account with appropriate IAM permissions

### 1. Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/aws-three-tier-infrastructure.git
cd aws-three-tier-infrastructure
```

### 2. Set your DB password via environment variable

```bash
# Never hardcode passwords!
export TF_VAR_db_password="YourSecurePassword123!"
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Review the plan

```bash
terraform plan -var-file="environments/dev/terraform.tfvars"
```

### 5. Deploy

```bash
terraform apply -var-file="environments/dev/terraform.tfvars"
```

### 6. Get the ALB DNS name

```bash
terraform output alb_dns_name
```

Open the DNS name in your browser — you should see the app running.

### 7. Destroy (to avoid AWS charges)

```bash
terraform destroy -var-file="environments/dev/terraform.tfvars"
```

---

## ⚙️ Configuration

Key variables in `environments/dev/terraform.tfvars`:

| Variable | Default | Description |
|----------|---------|-------------|
| `aws_region` | `us-east-1` | AWS region |
| `instance_type` | `t3.micro` | EC2 instance size |
| `asg_min_size` | `1` | Minimum EC2 instances |
| `asg_max_size` | `4` | Maximum EC2 instances |
| `db_instance_class` | `db.t3.micro` | RDS instance size |

---

## 🔒 Security Design

- EC2 instances live in **private subnets** — no direct internet access
- RDS lives in **isolated DB subnets** — accessible only from EC2 security group
- EC2 uses **IAM + SSM** for access — no SSH keys or open port 22
- All RDS storage is **encrypted at rest** (AES-256)
- Security Groups follow **least-privilege principle**

---

## 🛠️ Tech Stack

| Tool | Purpose |
|------|---------|
| Terraform 1.6 | Infrastructure as Code |
| AWS VPC | Network isolation |
| AWS ALB | Layer 7 load balancing |
| AWS EC2 + ASG | Auto-scaling compute |
| AWS RDS MySQL 8.0 | Managed relational database |
| AWS CloudWatch | Monitoring + auto-scaling alarms |
| AWS IAM | Least-privilege access control |
| GitHub Actions | CI pipeline (fmt, validate, plan) |

---

## 👤 Author

**Mohammed Khaja** — AWS Solutions Architect Associate  
[LinkedIn](https://linkedin.com/in/mohd-khaja) | [GitHub](https://github.com/YOUR_USERNAME)

---

## 📄 License

MIT License — free to use and modify.
