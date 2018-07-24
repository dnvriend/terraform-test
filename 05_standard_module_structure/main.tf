provider "aws" {
  region = "eu-west-1"
}

module "moduleA" {
  source = "modules/module_a"
}

module "moduleB" {
  source = "modules/module_b"
}