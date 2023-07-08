variable "credentials" {
  description = "Caminho para o arquivo JSON de credenciais do GCP"
  type        = string
}

variable "project_id" {
  description = "O ID do seu projeto no GCP"
  type        = string
}

variable "region" {
  description = "A região do GCP para criar recursos"
  default     = "us-central1"
}

variable "vpc_name" {
  description = "O nome da VPC"
  default     = "my-vpc"
}

variable "firewall_name" {
  description = "O nome da regra de firewall"
  default     = "my-firewall"
}

variable "subnet_name" {
  description = "O nome da sub-rede"
  default     = "subnet"
}

variable "subnet_cidr" {
  description = "O CIDR da sub-rede"
  default     = "10.0.0.0/24"
}

variable "manager_labels" {
  description = "Labels para as instâncias do manager"
  type        = map(string)
  default     = { group = "managers", http = "true", https = "true" }
}


variable "worker_labels" {
  description = "Labels para as instâncias de worker"
  type        = map(string)
  default     = { group = "workers" }
}


variable "db_worker_labels" {
  description = "Labels para a instância de worker do banco de dados"
  type        = map(string)
  default     = { group = "db_worker" }
}

variable "global_values" {
  description = "Valores globais para todas as instâncias"
  type = object({
    disk_image = string
    subnet = string
    can_ip_forward = bool
    deletion_protection = bool
    enable_display = bool
    service_account_email = string
    network_tier = string
    metadata = map(string)
    scheduling = object({
      automatic_restart = bool
      on_host_maintenance = string
      preemptible = bool
      provisioning_model = string
    })
    shielded_instance_config = object({
      enable_integrity_monitoring = bool
      enable_secure_boot = bool
      enable_vtpm = bool
    })
    service_account_scopes = list(string)
  })
  default = {
    disk_image = "projects/debian-cloud/global/images/debian-11-bullseye-v20230615"
    subnet = "subnet"
    can_ip_forward = false
    deletion_protection = false
    enable_display = false
    service_account_email = "your-service-account-email"
    network_tier = "PREMIUM"
    metadata = {
     # ssh-keys = "your-username:${file("~/.ssh/id_rsa.pub")}"
    }
    scheduling = {
      automatic_restart = true
      on_host_maintenance = "MIGRATE"
      preemptible = false
      provisioning_model = "STANDARD"
    }
    shielded_instance_config = {
      enable_integrity_monitoring = true
      enable_secure_boot = true
      enable_vtpm = true
    }
    service_account_scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }
}

variable "group_values" {
  description = "Valores padrão por grupo de instâncias"
  type = list(object({
    disk_type = string
    labels = map(string)
    tags = list(string)
  }))
  default = {
    managers = {
      disk_type = "pd-ssd"
      labels = {
        goog-ec-src = "vm_add-tf"
        group = "manager"
      }
      tags = [ "http", "https" ]
    }
    workers = {
      disk_type = "pd-ssd"
      labels = {
        goog-ec-src = "vm_add-tf"
        group = "worker"
      }
      tags = [ ]
    }
    db_worker = {
      disk_type = "pd-ssd"
      labels = {
        goog-ec-src = "vm_add-tf"
        group = "db_worker"
      }
      tags = [ ]
    }
  }
}


variable "managers" {
  description = "Configurações para as instâncias dos managers"
  type = list(object({
    machine_type = string
    disk_size = number
  }))
  default = [
    { machine_type = "e2-medium", disk_size = 10 },
    { machine_type = "e2-medium", disk_size = 10 },
    { machine_type = "e2-medium", disk_size = 10 }
  ]
}

variable "workers" {
  description = "Configurações para as instâncias dos workers"
  type = list(object({
    machine_type = string
    disk_size = number
  }))
  default = [
    { machine_type = "e2-small", disk_size = 10 },
    { machine_type = "e2-small", disk_size = 10 },
    { machine_type = "e2-small", disk_size = 10 }
  ]
}

variable "db_worker" {
  description = "Configuração para a instância do worker do banco de dados"
  type = object({
    machine_type = string
    disk_size = number
  })
  default = {
    machine_type = "e2-micro",
    disk_size = 20
  }
}
