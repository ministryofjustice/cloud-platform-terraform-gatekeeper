provider "aws" {
  region  = "eu-west-2"
  profile = "moj-cp"
}

module "gatekeeper" {
  source = "../../"

  cluster_domain_name = "gatekeeper.cloud-platform.service.justice.gov.uk"
}
