# Project Highlight: Highly Available Amazon EKS Architecture

Terraform · GitHub Actions · Docker · Helm · Kubernetes

![Project Image](https://github.com/efritznel/eks-project/blob/main/EKS-cluster.png)

# Overview

This project demonstrates how to build a highly available Amazon EKS cluster using Terraform, deploy containerized workloads, and manage application delivery using kubectl and Helm.

The infrastructure is fully automated with Terraform, follows AWS best practices for network isolation and security, and supports CI/CD-ready workflows with Docker images hosted in Docker Hub.

# Architecture Highlights

- Multi-AZ VPC design (public + private subnets)

- Private EKS worker nodes

- Bastion host for controlled administrative access

- Secure outbound access via NAT Gateway

- Scalable Kubernetes workloads

- Application exposure via AWS LoadBalancer Service

# Step 1: Create Remote Backend (Terraform State)

A remote backend is used to securely store Terraform state and enable state locking.

Resources created:

- S3 bucket (Terraform state storage)

- DynamoDB table (state locking)

# Step 2: Provision Core AWS Infrastructure

Terraform provisions the foundational AWS resources:

- VPC

- 2 Public subnets (Multi-AZ)

- 2 Private subnets (Multi-AZ)

- Internet Gateway

- NAT Gateway

- Route tables and associations

- Security Groups

- Bastion Host (EC2) in public subnet
Used for SSH access and administrative downloads

# Step 3: Create Amazon EKS Cluster

- EKS control plane deployed into the VPC

- Worker nodes launched in private subnets

- Cluster networking integrated with VPC CIDR

# Step 4: Grant IAM User Access to the Cluster

If the Nodes tab is empty, access must be explicitly granted.

# Enable EKS access mode

aws eks update-cluster-config \
  --name my-eks-cluster \
  --region us-east-1 \
  --access-config authenticationMode=API_AND_CONFIG_MAP

# Create access entry

aws eks create-access-entry \
  --cluster-name my-eks-cluster \
  --principal-arn arn:aws:iam::153435306748:user/ithomelabadmin \
  --type STANDARD \
  --region us-east-1

# Associate admin policy

aws eks associate-access-policy \
  --cluster-name my-eks-cluster \
  --principal-arn arn:aws:iam::153435306748:user/ithomelabadmin \
  --policy-arn arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy \
  --access-scope type=cluster \
  --region us-east-1

# Step 5: Build and Push Application Docker Image
# Application Structure

mkdir website

cd website

touch Dockerfile index.html

# Build Docker image

docker build -t efritznel/ithomelab-webpage:latest .

# Verify image

docker images

# Push to Docker Hub

docker login

docker push efritznel/ithomelab-webpage:latest

# Step 6: Deploy Application Using kubectl

# Kubernetes Manifests

- deployment.yaml

- service.yaml (type: LoadBalancer)

# Deploy

kubectl apply -f deployment.yaml

kubectl apply -f service.yaml

# Verify

kubectl get nodes

kubectl get pods

![Project Image](https://github.com/efritznel/eks-project/blob/main/Kubectl%20commands.GIF)

# Step 7: Deploy Application Using Helm

# Create Helm Chart

helm create app

# Chart structure:

- templates/

- Chart.yaml

- values.yaml

# Sample Deployment Template

```yaml
#deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Values.deploymentName }}
  labels:
{{- toYaml .Values.labels | nindent 4 }}
spec:
  replicas: {{ .Values.replicaCount | default 2 }}
  selector:
    matchLabels:
{{- toYaml .Values.selectorLabels | nindent 6 }}
  template:
    metadata:
      labels:
{{- toYaml .Values.selectorLabels | nindent 8 }}
    spec:
      containers:
        - name: {{ .Values.container.name | default "webapp" }}
          image: {{ .Values.image.repository }}:{{ .Values.image.tag | default "latest" }}
          imagePullPolicy: {{ .Values.image.pullPolicy | default "IfNotPresent" }}
          ports:
            - name: http
              containerPort: {{ .Values.service.targetPort | default 80 }}
              protocol: TCP
```
```yaml
#service.yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ .Values.service.name }}
  labels:
{{- toYaml .Values.labels | nindent 4 }}
spec:
  type: {{ .Values.service.type | default "LoadBalancer" }}
  selector:
{{- toYaml .Values.selectorLabels | nindent 4 }}
  ports:
    - name: http
      protocol: TCP
      port: {{ .Values.service.port | default 80 }}
      targetPort: {{ .Values.service.targetPort | default 80 }}
```

```yaml
#value.yaml
deploymentName: webapp
replicaCount: 2

labels:
  app.kubernetes.io/name: webapp
  app.kubernetes.io/part-of: ithomelab

selectorLabels:
  app.kubernetes.io/name: webapp

container:
  name: webapp

image:
  repository: efritznel/ithomelab-webpage
  tag: latest
  pullPolicy: IfNotPresent

service:
  name: webapp-service
  type: LoadBalancer
  port: 80
  targetPort: 80
  ```
# Validate Chart

helm template app/

# Install Application

helm install webapp app/

# List Releases

helm ls

# Step 8: Access the Application

Retrieve the Load Balancer DNS name:

kubectl get svc

Open the DNS name in a browser to access the application.

![Project Image](https://github.com/efritznel/eks-project/blob/main/Access%20webpage.GIF)

# Key Takeaways

- End-to-end infrastructure automation with Terraform

- Secure and scalable EKS design

- Dockerized application workflow

- Kubernetes deployment via kubectl and Helm

- Production-ready architecture suitable for CI/CD pipelines

