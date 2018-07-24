# 06_rds
Provisions an RDS Postgres instance.

## Description
The infrastructure description is based on the [Terraform AWS Modules on Github](https://github.com/terraform-aws-modules)
and specifically the [Terraform AWS RDS Module](https://github.com/terraform-aws-modules/terraform-aws-rds). 

Interestingly, Terraform can reference to a module from Github, and be executed:

```hcl-terraform
module "db" {
  source = "github.com/terraform-aws-modules/terraform-aws-rds"   
}
```
