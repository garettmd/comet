data "google_compute_network" "default" {
  name    = "default"
  project = var.project_id
}

data "google_compute_subnetwork" "us_central1" {
  name    = "default"
  region  = var.region
  project = var.project_id
}

module "main_cluster" {
  source          = "./modules/gke-cluster-standard"
  project_id      = var.project_id
  name            = "main-cluster"
  location        = var.region
  release_channel = "STABLE"
  vpc_config = {
    network    = module.vpc.network.self_link
    subnetwork = module.vpc.subnets["${var.region}/gke"].self_link
    secondary_range_names = {
      pods     = "pods"
      services = "services"
    }
    master_authorized_ranges = {
      internal-vms = "10.0.0.0/8"
    }
    master_ipv4_cidr_block = "192.168.0.0/28"
  }
  max_pods_per_node = 32
  private_cluster_config = {
    enable_private_endpoint = true
    master_global_access    = false
  }
  labels = {
    environment = "dev"
  }
}

module "main-nodepool" {
  source       = "./modules/gke-nodepool"
  project_id   = var.project_id
  cluster_name = module.main_cluster.name
  location     = var.region
  name         = "main-nodepool"
  k8s_labels   = { environment = "dev" }
  service_account = {
    create       = true
    email        = "main-nodepool" # optional
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
  node_config = {
    machine_type        = "n2-standard-2"
    disk_size_gb        = 50
    disk_type           = "pd-ssd"
    ephemeral_ssd_count = 1
    gvnic               = true
    spot                = true
  }
  nodepool_config = {
    autoscaling = {
      max_node_count = 10
      min_node_count = 1
    }
    management = {
      auto_repair  = true
      auto_upgrade = true
    }
  }
}
