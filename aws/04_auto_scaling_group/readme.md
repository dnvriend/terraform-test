# 04_auto_scaling_group
Provision an ELB with health checks, Auto Scaling Group, EC2 instances and security groups.

## Example
The architecture of the infrastructure is a little bit more involved. We have the following:

- 2 security groups (ELB/EC2)
- auto scaling group
- launch configuration
- elastic load balancer

The infrastructure is available in `main.tf` and you should really study the script. 

## Installation
Use the `init`, `plan`, `apply`, `show`, `output` and `destroy` commands.  