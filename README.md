Project Task

1. Create Remote backend
    - Create our remote backend to store our terraform configuration
    - Create s3 bucket using TF
    - Create DynamoDB using TF

2. Create our main Infrastructure
    - One VPC
    - Subnets (2 Private and 2 Public subnets)
     # Subnets will be created in 2 different AZ
    - Internet Gateway
    - NAT Gateway
    - Route Table
    - Routes
    - Route table association
    - SGs
    - Bastion Host (EC2) in our public subnet for SSH and Downloads

3. Create Kubernetes EKS cluster in our VPC with TF

4. Create a Dockerfile, create a docker image for our application and push Image to Dockerhub

5. Deploy our web app manifest files using Kubectl
    - Create Deployment
    - Create service of type Loadbalancer

6. Access our web app from our internet browser using the Load balancer external IP

**************************************************************************************************
Webserver deployment
We have created a folder name website with 2 files: dokerfile and index.html

Create a folder name: website inside your folder project
    - mkdir website
    - cd website/
    - touch index.html Dockerfile

Create Docker image and push it to dockerhub
After creating the index.html and dockerfile - now we are going to create the docker image - we need docker deskstop install in our local computer

build the image
docker build -t efritznel/ithomelab-webpage:latest .
        - efritznel: dockerhub username
        - ithomelab-webpage: name of the image creation

To see the freshly created image
        - docker images

Push the image to Dockerhub
        - docker login
        - docker push username/image-name (efritznel/ithomelab-webpage:latest)

*****************************************************************************************************
Need kubectl installed on your computer - to deploy Pods
        - kubectl get nodes
        - kubectl get pods

deploy our pods
        - go inside the manifest folder
        - kubectl apply -f deployment.yaml
        - kubectl apply -f service.yaml
        - kubectl get pods
        - 
        

