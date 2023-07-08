// Cria uma regra de firewall para permitir o tráfego interno na VPC
resource "google_compute_firewall" "allow_internal" {
  name    = "${var.firewall_name}-allow-internal" // Nome da regra de firewall
  network = google_compute_network.vpc_network.self_link // VPC associada

  // Permite tráfego ICMP
  allow {
    protocol = "icmp"
  }
  
  // Permite todas as portas TCP
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  
  // Permite todas as portas UDP
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  // Define os intervalos de endereços IP de origem para os quais a regra se aplica
  // Isso é efetivamente equivalente a permitir o tráfego entre todas as instâncias da VPC, não importa a região.
  source_ranges = ["10.128.0.0/9"]
}

// Cria uma regra de firewall para permitir conexões SSH de qualquer origem
resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.firewall_name}-allow-ssh"
  network = google_compute_network.vpc_network.self_link

  // Permite a porta 22 (SSH)
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  // Aplica a regra para qualquer endereço IP de origem
  source_ranges = ["0.0.0.0/0"]
}

// Cria uma regra de firewall para permitir tráfego ICMP de qualquer origem
resource "google_compute_firewall" "allow_icmp" {
  name    = "${var.firewall_name}-allow-icmp"
  network = google_compute_network.vpc_network.self_link

  // Permite tráfego ICMP
  allow {
    protocol = "icmp"
  }

  // Aplica a regra para qualquer endereço IP de origem
  source_ranges = ["0.0.0.0/0"]
}

/*
// Cria uma regra de firewall para permitir tráfego TCP na porta 8080 de um intervalo específico de IPs
resource "google_compute_firewall" "allow_specific" {
  name    = "${var.firewall_name}-allow-8080"
  network = google_compute_network.vpc_network.self_link

  // Permite a porta 8080
  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  // Aplica a regra apenas para endereços IP no intervalo 192.0.2.0/24
  source_ranges = ["192.0.2.0/24"] 
}

// Cria uma regra de firewall para negar todo o tráfego ICMP de qualquer origem
resource "google_compute_firewall" "deny_icmp" {
  name    = "${var.firewall_name}-deny-icmp"
  network = google_compute_network.vpc_network.self_link

  // Nega tráfego ICMP
  deny {
    protocol = "icmp"
  }

  // Aplica a regra para qualquer endereço IP de origem
  source_ranges = ["0.0.0.0/0"]
}
*/
