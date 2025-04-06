# AWS EKS Deployment with Terraform
This project uses Terraform to provision an Amazon EKS (Elastic Kubernetes Service) cluster along with all necessary AWS infrastructure components. It also includes steps for deploying a simple Nginx "Hello World" application to demonstrate the complete workflow.
Architecture Overview
This project provisions:

# VPC Infrastructure:

VPC with CIDR 10.0.0.0/16
4 Subnets (2 private, 2 public) across 2 availability zones
Internet Gateway for public internet access
NAT Gateway for private subnet outbound traffic
Route tables for network traffic management


# EKS Cluster:

EKS Cluster running Kubernetes v1.30
IAM roles and policies for EKS control plane
Node group with t3.large instances
OIDC provider for Kubernetes service account integration


Application Deployment:

Custom Nginx Docker container
Kubernetes Deployment, Service, and Ingress resources
Nginx Ingress Controller for external access



# Prerequisites

AWS CLI installed and configured with appropriate permissions
Terraform v1.0.0+ installed
Docker installed (for building and pushing the container image)
kubectl installed
Helm v3+ installed
A Docker Hub account (or other container registry)




# Step-by-Step Deployment Guide
1. Deploy the EKS Infrastructure with Terraform
- Initialize Terraform ===> terraform init
  
- Preview the changes ===> terraform plan
  
- Deploy the infrastructure ===> terraform apply

2. Configure kubectl to work with your EKS cluster
  aws eks update-kubeconfig --region <provide the resion where provision> --name <name of you eks cluster>

3. Deploy the Nginx Ingress Controller
- Add the Nginx Ingress Helm repository ===> helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

- Update Helm repositories ===> helm repo update

- Install Nginx Ingress Controller
- helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set controller.service.type=LoadBalancer \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/aws-load-balancer-type"=classic
  
4. Build and Push the Docker Image
- Build the Docker image (replace <user_name> with your Docker Hub username) ===> docker build -t <user_name>/nginx-hello:latest .

- Push the image to Docker Hub ===> docker push <user_name>/nginx-hello:latest

- Optional: Test the image locally ===> docker run -d -p 8080:80 <user_name>/nginx-hello:latest

5. Deploy the Application to Kubernetes
- Create the namespace ===> kubectl apply -f namespace.yaml

- Deploy the application (update the image name in deployment.yaml first) ==> kubectl apply -f deployment.yaml

- Create the service ===> kubectl apply -f service.yaml

- Create the ingress resource ===> kubectl apply -f ingress.yaml


