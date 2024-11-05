module "vpc" {
  source     = "./modules/net-vpc"
  project_id = var.project_id
  name       = "gke-network"
  subnets = [
    # custom description and PGA disabled
    {
      name                  = "gke"
      region                = var.region
      ip_cidr_range         = "10.0.0.0/16",
      description           = "Subnet for GKE"
      enable_private_access = false
      secondary_ip_ranges = {
        pods     = "192.168.16.0/20"
        services = "192.168.32.0/20"
      }
      flow_logs_config = {
        flow_sampling        = 0.5
        aggregation_interval = "INTERVAL_10_MIN"
      }
    },
  ]
}