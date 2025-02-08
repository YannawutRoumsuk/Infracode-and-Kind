terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.20.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"  # ใช้ config จาก Kubernetes Cluster ที่สร้างด้วย KiND
}

# สร้าง Deployment สำหรับแอป
resource "kubernetes_deployment" "nxz_backend" {
  metadata {
    name = "nxz-backend-app"
  }
  spec {
    replicas = 2  # รันแอป 2 instance เพื่อความเสถียร
    selector {
      match_labels = {
        app = "nxz-backend-app"
      }
    }
    template {
      metadata {
        labels = {
          app = "nxz-backend-app"
        }
      }
      spec {
        container {
          name  = "nxz-backend-app"
          image = "nxz-backend-app:latest"  # ใช้ Docker Image 
          image_pull_policy = "Never"  # บอก Kubernetes ไม่ให้ดึง Image จาก Docker Hub
          port {
            container_port = 3000
          }
        }
      }
    }
  }
}

# สร้าง Service เพื่อเปิดพอร์ตให้เข้าถึงแอป
resource "kubernetes_service" "nxz_service" {
  metadata {
    name = "nxz-backend-service"
  }
  spec {
    selector = {
      app = "nxz-backend-app"
    }
    port {
      port        = 3000
      target_port = 3000
      node_port   = 30080
    }
    type = "NodePort"
  }
}
