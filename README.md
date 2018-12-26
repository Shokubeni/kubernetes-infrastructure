![Maintained by smart-gears.io](https://img.shields.io/badge/maintained%20by-smart--gears.io-green.svg?style=for-the-badge&logo=appveyor)
![Status work in progress](https://img.shields.io/badge/status-work%20in%20progress-red.svg?style=for-the-badge&logo=appveyor)
# Kubernetes formation
This configuration provides a simple way for quick, secure and fully management installation of Kubernetes cluster. Advanced settings give the possibility to configure support tools such as Rancher and Grafana, which helps to monitor cluster resources and simplify its management.

## Requirements
We use Terragrunt. It is provides extra tools for working with multiple Terraform modules. At the beginning you need to install Terraform and Terragrunt console applications as showing below.

#### Terraform
 - Download the binary for your OS from [Releases Page](https://www.terraform.io/downloads.html), rename it to `terraform`, and add it to your PATH.
 - You can install Terragrunt on OSX using [Homebrew](https://brew.sh/): `brew install terrafrom`.
#### Terragrunt
 - Download the binary for your OS from [Releases Page](https://github.com/gruntwork-io/terragrunt/releases), rename it to `terragrunt`, and add it to your PATH.
 - You can install Terragrunt on OSX using [Homebrew](https://brew.sh/): `brew install terragrunt`.

## Environments
Directory `environment` contains subdirectories used for splitting independent configurations with different requirements for cloud infrastucture. By default there is only `default` subdirectory with common parameters preset. For deep understanding this concept please read Terragrunt [documentation](https://github.com/gruntwork-io/terragrunt).

Most common directory structure can be represented as showing bellow. Or you can use only `default` config and create environments inside Kubernetes cluster as `namespaces`:
```
└── environment
    ├── production
    |   ├── terraform.tfvars
    │   └── component
    │       └── terraform.tfvars
    ├── development
    |   ├── terraform.tfvars
    │   └── component
    │       └── terraform.tfvars
    └── stage
        ├── terraform.tfvars
        └── component
            └── terraform.tfvars
```

## Quick start
At the beginning you must create `cluster_operator` profile inside `~/.aws/creditnails` file or use another 
way [standartized by AWS](https://aws.amazon.com/blogs/security/a-new-and-standardized-way-to-manage-credentials-in-the-aws-sdks/). Then just execute the commands follow below.
```sh
cd environment/default
terragrunt apply-all
```
At the end of execution secure S3 bucket, dynamoDB lock table and Kubernetes cluster components will be created.