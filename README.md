# Project Highlight: Highly Available EKS Architecture with Terraform & GitHub Actions

![Project Image](https://github.com/efritznel/eks-project/blob/main/EKS-cluster.png)
# Setp 1. Create Remote backend

    - Create our remote backend to store our terraform configuration
    
    - Create s3 bucket using TF
    
    - Create DynamoDB using TF

# Step 2. Create our main Infrastructure

    - One VPC
    
    - Subnets (2 Private and 2 Public subnets in 2 different AZ) 
       
    - Internet Gateway
    
    - NAT Gateway
    
    - Route Table
    
    - Routes
    
    - Route table association
    
    - SGs
    
    - Bastion Host (EC2) in our public subnet for SSH and Downloads

# Step 3. Create Kubernetes EKS cluster in our VPC with TF

# Step 4. Node tab is empty - provide access to the IAM user by running those commands

# Switch the cluster mode first
aws eks update-cluster-config `
  --name my-eks-cluster `
  --region us-east-1 `
  --access-config authenticationMode=API_AND_CONFIG_MAP

****************************************************************

aws eks create-access-entry `
  --cluster-name my-eks-cluster `
  --principal-arn arn:aws:iam::153435306748:user/ithomelabadmin `
  --type STANDARD `
  --region us-east-1

****************************************************************
aws eks associate-access-policy `
  --cluster-name my-eks-cluster `
  --principal-arn arn:aws:iam::153435306748:user/ithomelabadmin `
  --policy-arn arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy `
  --access-scope type=cluster `
  --region us-east-1

# Step 5. Create a Dockerfile, create a docker image for our application and push Image to Dockerhub
# Webserver deployment
We have created a folder name website with 2 files: Dokerfile and index.html

Create a folder name: website inside your folder project

    - mkdir website
    
    - cd website/
    
    - touch index.html Dockerfile

# Create Docker image and push it to dockerhub

After creating the index.html and dockerfile - now we are going to create the docker image - we need docker deskstop install in our local computer

# build the image
Command: docker build -t efritznel/ithomelab-webpage:latest .

        - efritznel: is the dockerhub username
        
        - ithomelab-webpage:latest : is the name of the created image 

# To see the freshly created image

        - docker images

# Push the image to Dockerhub

        - docker login
        
        - docker push username/image-name (efritznel/ithomelab-webpage:latest)

# You can deploy the application either using kubectl or HELM both need to be installed on your PC

# Deploy our web app manifest files using Kubectl

    - Create Deployment.yaml file
    
    - Create service.yaml of type Loadbalancer

# deploy our pods

        - Go inside the manifest folder
        
        - kubectl apply -f deployment.yaml
        
        - kubectl apply -f service.yaml

# Verify your deployment

        - kubectl get nodes
        
        - kubectl get pods

![Project Image](https://github.com/efritznel/eks-project/blob/main/Kubectl%20commands.GIF)

# Deploy our web app manifest files using HELM

        1. go inside the manifest folder
		
	2. Create a custom HELM chart: "helm create app"
		
	3. The chart folder will be created with the following files and folders
			
		- templates (a folder with all the yaml files inside like: deployment.yaml, service.yaml)
			
		- Chart.yaml (for metadata)
			
		- values.yaml (to add the default value for the variables we are using in Deployment and Service .yaml)

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
		
	4. Validate the manifest file: "helm template app/"
		
	5. Install the application: "helm install webapp app/"

	6. List kubernetes cluster: "helm ls"

# Access our web app from our internet browser using the Load balancer DNS name
![Project Image](https://github.com/efritznel/eks-project/blob/main/Access%20webpage.GIF)



        


