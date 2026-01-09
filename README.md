# Project Highlight: Highly Available EKS Architecture with Terraform & GitHub Actions

![Project Image](https://github.com/efritznel/eks-project/blob/main/EKS-cluster.png)
# Setp 1. Create Remote backend

    - Create our remote backend to store our terraform configuration
    
    - Create s3 bucket using TF
    
    - Create DynamoDB using TF

# Step 2. Create our main Infrastructure

    - One VPC
    
    - Subnets (2 Private and 2 Public subnets)
    
       - Subnets will be created in 2 different AZ
       
    - Internet Gateway
    
    - NAT Gateway
    
    - Route Table
    
    - Routes
    
    - Route table association
    
    - SGs
    
    - Bastion Host (EC2) in our public subnet for SSH and Downloads

# Step 3. Create Kubernetes EKS cluster in our VPC with TF

# Step 4. Node tab is empty - provide access to the IAM user by running those commands
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

# Step 6. Deploy our web app manifest files using Kubectl

    - Create Deployment.yaml file
    
    - Create service.yaml of type Loadbalancer

# Need kubectl installed on your computer - to deploy Pods

        - kubectl get nodes
        
        - kubectl get pods

# deploy our pods

        - go inside the manifest folder
        
        - kubectl apply -f deployment.yaml
        
        - kubectl apply -f service.yaml
        
        - kubectl get pods

# Step 6. Access our web app from our internet browser using the Load balancer DNS name
![Project Image](https://github.com/efritznel/eks-project/blob/main/Access%20webpage.GIF)



        


