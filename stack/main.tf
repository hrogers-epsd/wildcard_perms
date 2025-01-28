#.

provider "aws" {
  region = "us-east-2"
}

module "iam" {
  source = "./modules/iam"
}

module "network" {
  source = "./modules/network"
}

