![Maintained by smart-gears.io](https://img.shields.io/badge/maintained%20by-smart--gears.io-green.svg?style=for-the-badge&logo=appveyor)
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
TF_VAR_GRAFANA_CLIENT_ID = <string>`Google OAuth application client ID`
TF_VAR_GRAFANA_SECRET    = <string>`Google OAuth application secret`
TF_VAR_AWS_ROLE          = <string>`AWS cluster operator role arn`
TF_VAR_AWS_PROFILE       = <string>`AWS cluster operator profile name`
TF_VAR_CLUSTER_NAME      = <string>[Kubernetes]
TF_VAR_CLUSTER_LABEL     = <string>[kubernetes]
TF_VAR_SMTP_HOST         = <string>[email-smtp.us-east-1.amazonaws.com]
TF_VAR_SMTP_PORT         = <number>[587]
TF_VAR_SMTP_METRICS_USER = <string>`SMTP user name`
TF_VAR_SMTP_METRICS_PASS = <string>`SMTP user password`
TF_VAR_SMTP_ALERTS_USER  = <string>`SMTP user name`
TF_VAR_SMTP_ALERTS_PASS  = <string>`SMTP user password`
TF_VAR_SLACK_ALERTS_URL  = <url>`slack alerts webhook`
TF_VAR_SLACK_CHANNEL     = <string>`slack alerts chanel`
TF_VAR_KUBE_CONFIG       = <string>`path to kubernetes config`
```
