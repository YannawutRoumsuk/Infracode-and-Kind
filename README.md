# README

This project demonstrates a complete DevOps pipeline setup using Docker, Docker Compose, GitHub Actions, Kubernetes (via KiND), and Terraform.

## Prerequisites

Ensure you have the following tools installed on your local machine:

1. **Node.js** (v22.13.1)
2. **Docker**
3. **Docker Compose**
4. **Git**
5. **Terraform**
6. **KiND (Kubernetes in Docker)**
7. **kubectl**

## Project Structure

```
├── backend-apps            # Node.js application
│   ├── Dockerfile          # Dockerfile for the app
│   ├── docker-compose.yml  # Docker Compose file for local development
│   ├── index.ts            # Main application code
│   ├── package.json        # Dependencies and scripts
│   └── tsconfig.json       # TypeScript configuration
│
├── .github/workflows       # GitHub Actions workflows
│   └── ci-cd-pipeline.yml  # CI/CD pipeline configuration
│
├── cicd-diagram            # CI/CD diagrams
│   └── upgraded_ci_cd_pipeline.png  # CI/CD pipeline flowchart
│
├── infra-code              # Infrastructure as Code (IaC) using Terraform
│   └── main.tf             # Terraform configuration to deploy on Kubernetes
│
└── README.md               # Project documentation
```

## Running the Application Locally

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR-USERNAME/nxz-devops-assignment.git
cd nxz-devops-assignment
```

### 2. Run Using Docker Compose

Navigate to the `backend-apps` directory and run:

```bash
cd backend-apps
docker-compose up --build
```

The application will be available at `http://localhost:3000`.

### 3. Running Tests

To verify the endpoints:

```bash
curl http://localhost:3000/health
curl http://localhost:3000/ready
curl http://localhost:3000/success
```

## CI/CD Pipeline

The CI/CD pipeline is configured using **GitHub Actions**. It performs the following steps when code is pushed to the `main` branch:

1. **Checkout the repository**
2. **Set up Node.js**
3. **Install dependencies**
4. **Build the application**
5. **Run tests** (`/health`, `/ready`, `/success`)
6. **Deploy to Kubernetes** (if a tag version is created)

### Triggering Deployment

Deployment is triggered automatically when a new tag is pushed:

```bash
git tag v1.0.0
git push origin v1.0.0
```

## Deploying to Kubernetes with Terraform

### 1. Create a Kubernetes Cluster with KiND

```bash
kind create cluster --name nxz-cluster
```

### 2. Load Docker Image to KiND

```bash
docker build -t nxz-backend-app:latest ./backend-apps
kind load docker-image nxz-backend-app:latest --name nxz-cluster
```

### 3. Apply Terraform Configuration

Navigate to the `infra-code` directory and run:

```bash
cd infra-code
terraform init
terraform apply
```

### 4. Verify Deployment

Check if the pods and services are running:

```bash
kubectl get pods
kubectl get services
```

Test the application via NodePort:

```bash
curl http://localhost:30080/health
curl http://localhost:30080/ready
curl http://localhost:30080/success
```

## Troubleshooting

- **Port Conflicts**: Ensure port `3000` is not used by other applications (e.g., Grafana).
- **Image Pull Errors**: Verify the image is loaded into KiND with `kind load docker-image nxz-backend-app:latest --name nxz-cluster`.
- **Terraform Errors**: Ensure the correct `kubeconfig` path in `infra-code/main.tf`.

## License

This project is licensed under the MIT License.

