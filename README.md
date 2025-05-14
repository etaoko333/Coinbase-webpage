# # 🚀 Build and Deploy a Modern React Coinbase-Inspired Landing Page to AWS with ECS Fargate, Terraform, Docker, and GitHub Actions



![2025-05-14 (18)](https://github.com/user-attachments/assets/1a6470ac-bd6b-4f09-b7c7-8a7cf344eeb7)

This hands-on guide will walk you through building and deploying a modern, responsive Coinbase-style landing page using **React**. You’ll containerize the app with **Docker**, manage infrastructure with **Terraform**, automate deployment using **GitHub Actions**, and host it on **AWS ECS Fargate** with secure HTTPS access via **ACM** and **Route 53**.

---

## 🧱 Project Structure
.
├── /src                   # React app source
├── Dockerfile             # Multi-stage Docker build
├── nginx.conf             # Nginx config for React routing
├── .github/workflows/     # GitHub Actions CI/CD
│   └── deploy.yml         
├── terraform/             # Infrastructure as Code
│   ├── main.tf            # VPC, ECS, ALB, ACM, Route 53
│   ├── variables.tf       # Configurable inputs  
│   └── outputs.tf         # Deployment outputs (ALB URL)

## 🌟 Overview


---

## 📆 Prerequisites

Ensure you have the following tools and services set up:

| Tool           | Description                                | Link                                                                                 |
| -------------- | ------------------------------------------ | ------------------------------------------------------------------------------------ |
| Node.js (v18+) | Runtime for React                          | [Download](https://nodejs.org/)                                                      |
| Docker         | For containerizing the app                 | [Download](https://www.docker.com/)                                                  |
| AWS CLI        | To interact with AWS                       | [Install Guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) |
| Terraform      | Infrastructure as code                     | [Install Guide](https://developer.hashicorp.com/terraform/downloads)                 |
| Git & GitHub   | For version control & GitHub Actions       | [Git](https://git-scm.com/)                                                          |
| AWS Account    | Includes access to ECS, ACM, ALB, Route 53 | [Sign Up](https://aws.amazon.com/)                                                   |
| Domain Name    | Registered in Route 53                     |                                                                                      |

---

## 📚 Step-by-Step Guide

### 💼 1. Clone the Project

```bash
git clone https://github.com/your-username/react-coinbase-landing.git
cd react-coinbase-landing
```

### 📚 2. Run the React App Locally

```bash
npm install
npm start
```

Open `http://localhost:3000` to preview the app.

---

### 🛠️ 3. Dockerize the React App

**Dockerfile:**

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build
EXPOSE 3000
CMD ["npx", "serve", "-s", "build", "-l", "3000"]
```

**.dockerignore:**

```dockerignore
node_modules
build
.dockerignore
Dockerfile
```

**Build & Run Locally:**

```bash
docker build -t coinbase-app .
docker run -p 3000:3000 coinbase-app
```

---

### 🚢 4. Push Docker Image to Amazon ECR

1. **Login to ECR:**

```bash
aws ecr get-login-password --region us-west-1 | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.us-west-1.amazonaws.com
```

2. **Create ECR Repository:**

```bash
aws ecr create-repository --repository-name coinbase-react-app
```

3. **Push Image:**

```bash
docker tag coinbase-app:latest <ecr_repo_url>
docker push <ecr_repo_url>
```

---

### 🔧 5. Infrastructure with Terraform

Organize files:

```bash
terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── ecs.tf
├── alb.tf
├── acm.tf
├── route53.tf
```



![2025-05-14 (15)](https://github.com/user-attachments/assets/e351a876-3b6a-4017-a915-b73255689ad7)


**Apply Infrastructure:**

```bash
terraform init
terraform plan
terraform apply
```

---

### 🔒 6. Secure with HTTPS via ACM

Terraform will provision an ACM cert. Go to Route 53 and create the CNAME record provided by ACM for domain verification.

Once validated, HTTPS is active.

---

### 🚚 7. Setup GitHub Actions for CI/CD

**.github/workflows/deploy.yml:**

```yaml
name: Deploy React App to AWS

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Log in to ECR
        run: |
          aws ecr get-login-password --region us-west-1 | docker login --username AWS --password-stdin ${{ secrets.AWS_ECR_URL }}

      - name: Build Docker image
        run: docker build -t coinbase-app .

      - name: Tag and Push
        run: |
          docker tag coinbase-app:latest ${{ secrets.AWS_ECR_URL }}/coinbase-app:latest
          docker push ${{ secrets.AWS_ECR_URL }}/coinbase-app:latest

      - name: Trigger Terraform Deployment
        run: |
          cd terraform
          terraform init
          terraform apply -auto-approve
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

Store your AWS credentials and ECR URL as GitHub Secrets.

---

### 🌐 8. Point Domain with Route 53

Create an **Alias A Record** pointing `www.eta-oko.com` to your ALB DNS name.

Example:

```hcl
resource "aws_route53_record" "app" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www"
  type    = "A"
  alias {
    name                   = aws_lb.app.dns_name
    zone_id                = aws_lb.app.zone_id
    evaluate_target_health = true
  }
}
```

---

## 🚀 Deployment Complete

Visit `https://www.eta-oko.com` to view your fully deployed, containerized, and secure React landing page running on AWS ECS Fargate!

---

## 📊 What's Next?

* Add logging with **CloudWatch**
* Improve CI/CD with **Terraform Cloud** or **GitHub Environments**
* Implement autoscaling based on traffic

---

## 👍 Like this Guide?

Star the repo ✨, share it with your network, or fork it to build your own SaaS landing page.

**Medium Blog:** [[https://medium.com/@osenat.alonge/deploying-a-react-coinbase-landing-page-to-aws-a-complete-guide-with-terraform-ecs-fargate-c249ce88204f](https://www.eta-oko.com](https://medium.com/@osenat.alonge/deploying-a-react-coinbase-landing-page-to-aws-a-complete-guide-with-terraform-ecs-fargate-c249ce88204f))
**GitHub Repo:** [[github.com/your-username/react-coinbase-landing](https://github.com/etaoko333/Coinbase-webpage.git)]([https://github.com/your-username/react-coinbase-landing](https://github.com/etaoko333/Coinbase-webpage.git))

Thanks for reading — now go deploy something awesome!
