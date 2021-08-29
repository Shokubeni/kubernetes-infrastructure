![Maintained by metal-city.ru](https://img.shields.io/badge/maintained%20by-metal--city.ru-green.svg?style=for-the-badge&logo=appveyor)
![Status work in progress](https://img.shields.io/badge/status-stable-green.svg?style=for-the-badge&logo=appveyor)
# Information
This configuration provides a simple way for quick, secure and fully management installation of Kubernetes cluster. Advanced settings give the possibility to configure support tools such as Kube Lego, Prometeus and Grafana, which helps to monitor cluster resources and simplify its management.

## Requirements
We use Terragrunt. It is provides extra tools for working with multiple Terraform modules. At the beginning you need to install Terraform and Terragrunt console applications as showing below.

#### Terraform
 - Download the binary for your OS from [Releases Page](https://www.terraform.io/downloads.html), rename it to `terraform`, and add it to your PATH.
 - You can install Terragrunt on OSX using [Homebrew](https://brew.sh/): `brew install terrafrom`.
#### Terragrunt
 - Download the binary for your OS from [Releases Page](https://github.com/gruntwork-io/terragrunt/releases), rename it to `terragrunt`, and add it to your PATH.
 - You can install Terragrunt on OSX using [Homebrew](https://brew.sh/): `brew install terragrunt`.

## Quick start
At the beginning you must create AWS profile inside `~/.aws/creditnails` file or use another 
way [standartized by AWS](https://aws.amazon.com/blogs/security/a-new-and-standardized-way-to-manage-credentials-in-the-aws-sdks/). Then just execute the commands follow below.
```sh
cd environment/environment-name
terragrunt apply-all
```
## Environment
These environment variables must be configured before you start installation.
```sh
TF_VAR_AWS_PROFILE       = <string>AWS cluster operator profile name
TF_VAR_CLUSTER_NAME      = <string>[MetalCity]
TF_VAR_CLUSTER_LABEL     = <string>[metal-city]
TF_VAR_TELEGRAM_TOKEN    = <string>Telegram bot access token
TF_VAR_TELEGRAM_ADMIN    = <string>Telegram bot admin ID
TF_VAR_GRAFANA_CLIENT_ID = <string>OAuth application client ID
TF_VAR_GRAFANA_SECRET    = <string>OAuth application secret
```
