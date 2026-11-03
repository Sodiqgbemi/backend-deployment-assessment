\# StartupTech Backend Deployment Assessment



\## Project Overview



This project provisions AWS infrastructure using Terraform and deploys the MuchTodo Go backend API using Docker and Docker Compose.



The deployment demonstrates infrastructure as code, network isolation, secure instance access, containerization, service health checks, and application deployment behind an Application Load Balancer.



\## Architecture



The infrastructure includes:



\- A custom AWS VPC (`10.0.0.0/16`).

\- Two public subnets across separate Availability Zones.

\- Two private subnets across separate Availability Zones.

\- Internet Gateway and NAT Gateway.

\- Public Application Load Balancer.

\- Bastion host for SSH access to private instances.

\- Private backend EC2 instance.

\- Private MongoDB EC2 instance.

\- Security groups restricting access between components.



The Docker Compose deployment runs the backend API and a MongoDB container on a private Docker network with persistent database storage.



\*\*Note:\*\* The standalone MongoDB EC2 instance is provisioned by Terraform. The Docker Compose application uses its own MongoDB container, as configured in `docker-compose.yml`.



\## Technologies



\- AWS

\- Terraform

\- Amazon Linux 2

\- Docker

\- Docker Compose

\- Go

\- MongoDB



\## Repository Structure



```text

.

├── Server/

│   └── MuchToDo/

├── terraform/

│   ├── main.tf

│   ├── variables.tf

│   ├── outputs.tf

│   ├── user\_data/

│   └── .terraform.lock.hcl

├── Dockerfile

├── docker-compose.yml

├── .dockerignore

├── .gitignore

├── evidence/

└── README.md

```



\## Prerequisites



\- AWS account with permissions to provision the required resources.

\- AWS CLI installed and configured.

\- Terraform installed.

\- SSH key pair.

\- Docker and Docker Compose.

\- Git.



\## Infrastructure Deployment



Navigate to the Terraform directory:



```bash

cd terraform

```



Initialize Terraform:



```bash

terraform init

```



Format and validate the configuration:



```bash

terraform fmt -recursive

terraform validate

```



Create a `terraform.tfvars` file using the example:



```hcl

aws\_region    = "eu-north-1"

instance\_type = "t3.micro"

my\_ip         = "YOUR\_PUBLIC\_IP/32"

```



Review the deployment plan:



```bash

terraform plan

```



Apply the infrastructure:



```bash

terraform apply

```



Review the outputs:



```bash

terraform output

```



\## Application Deployment



The backend application is containerized using a multi-stage Dockerfile.



The Docker Compose configuration deploys:



\- Backend API service.

\- MongoDB service.

\- Persistent MongoDB volume.

\- Shared Docker network.

\- Health checks and service dependency management.

\- Restart policies.



Create a `.env` file in the project root with a strong JWT secret:



```env

JWT\_SECRET\_KEY=YOUR\_GENERATED\_SECRET

```



Start the application:



```bash

docker compose up -d --build

```



Check service status:



```bash

docker compose ps

```



Check application logs:



```bash

docker compose logs -f backend

```



Test the API locally:



```bash

curl http://localhost:8080/health

```



Test through the Application Load Balancer:



```bash

curl http://YOUR\_ALB\_DNS/health

```



The health endpoint should return HTTP 200 when the backend and database are healthy.



\## Accessing Private Instances



The backend and MongoDB instances are deployed in private subnets.



SSH access to the backend is performed through the Bastion host using SSH ProxyCommand and the configured private key.



The backend instance is not assigned a public IP address.



\## Cleanup



Stop the Docker Compose services:



```bash

docker compose down

```



To also remove the persistent MongoDB volume:



```bash

docker compose down -v

```



\*\*Warning:\*\* The `-v` option deletes the Compose MongoDB data volume.



To destroy the AWS infrastructure, navigate to the Terraform directory and run:



```bash

terraform destroy

```



Review the destruction plan before confirming.



\## Security Considerations



\- SSH access to the Bastion host is restricted to the configured public IP.

\- Backend instances are deployed in private subnets.

\- Backend access is restricted to the Load Balancer security group.

\- MongoDB access is restricted to the backend security group.

\- Environment files, SSH private keys, Terraform state files, and real Terraform variable files are excluded from version control.



\## Evidence



Deployment screenshots are available in the `evidence/` directory.



\## Author



StartupTech Backend Deployment By Rayya

