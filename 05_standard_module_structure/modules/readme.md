# modules
The modules folder contains `standalone` submodules.

## Description
Modules are self-contained units that allow for reusable, composable components that can be put together to create
different types of architectures. For a great example look at the [terraform-aws-vault](https://github.com/hashicorp/terraform-aws-vault/tree/master/modules/vault-elb)
module, that contains submodules that do exactly this. The key thing is that modules are all standalone and do one thing only.

For example, a standalone module that installs the 'ELB' functionality, or in other words 'one use-case', consisting of:

- aws_security_group_rule
- aws_route53_record
- aws_autoscaling_attachment
- aws_elb
  
The module describes itself using a `readme`, the `input` variables, the `output` variables and of course the `main.tf` 
describing the minimum Terraform version, the resources, and the configuration of the resources that depend on the variables.

Other modules:
- a module that installs vault on an AMI
- a module that creates self-signed TLS certificates
- a module that deploys AMIs across an ASG
- a module that creates an S3 bucket and IAM policies as storage backend\
- a module that configures the security group settings
- a module that deploys a load balancer

When you use all these modules together you get the full solution, combine only a partial set of modules or even swap out 
modules and replace it with your own code.

## Versioned modules

  
  