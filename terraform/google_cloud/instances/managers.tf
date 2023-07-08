resource "google_compute_instance" "manager" {
  count        = length(var.managers)
  name         = "manager${count.index + 1}"
  machine_type = var.managers[count.index].machine_type
  zone         = "us-central1-a"

  boot_disk {
    auto_delete = true
    device_name = "${var.managers[count.index].machine_type}-boot-disk"

    initialize_params {
      image = var.global_values.disk_image
      size  = var.managers[count.index].disk_size
      type  = var.group_values["managers"].disk_type
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    subnetwork = var.global_values.subnet
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = "324324020628-compute@developer.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = true
    enable_vtpm                 = true
  }

  tags = ["http-server", "https-server"]
}
