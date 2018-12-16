Backend configuration example

```
terraform {
  backend "s3" {
    access_key           = "<access_key>"
    secret_key           = "<secret_key>"
    bucket               = "<bucket_name>"
    region               = "eu-west-1"
    workspace_key_prefix = "environment"
    key                  = "state"
  }
}
```

Cluster variables example

```
// Provider settings
provider_info = {
  access_key = "<access_key>"
  secret_key = "<secret_key>"
  region     = "<aws_region>"
}

// Cluster naming
cluster_info = {
  name  = "Kubernetes"
  label = "kubernetes"
}

// Network settings
virtual_cloud_cidr = "172.16.0.0/16"
private_subnets = {
  "172.16.0.0/20"  = "eu-west-1b"
}
public_subnets = {
  "172.16.16.0/20" = "eu-west-1b"
}
```