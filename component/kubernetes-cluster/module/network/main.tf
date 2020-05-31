module "virtual_cloud" {
  source = "./module/virtual-cloud"

  virtual_cloud_cidr = var.network_config.virtual_cloud_cidr
  cluster_data       = var.cluster_data
}

module "private_subnet" {
  source = "./module/private-subnet"

  virtual_cloud_id = module.virtual_cloud.cloud_id
  subnets_zones    = values(var.network_config.private_subnets)
  subnets_cidrs    = keys(var.network_config.private_subnets)
  cluster_data     = var.cluster_data
}

module "public_subnet" {
  source = "./module/public-subnet"

  virtual_cloud_id = module.virtual_cloud.cloud_id
  subnets_zones    = values(var.network_config.public_subnets)
  subnets_cidrs    = keys(var.network_config.public_subnets)
  cluster_data     = var.cluster_data
}

module "internet_gateway" {
  source = "./module/internet-gateway"

  virtual_cloud_id = module.virtual_cloud.cloud_id
  subnets_ids      = module.public_subnet.subnet_ids
  cluster_data     = var.cluster_data
}