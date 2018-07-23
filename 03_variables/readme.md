# 03_variables
Provision a web server that responds with 'hello world' at a configurable port

## Input Variables
Terraform allows to define `input variables`. By convention, use the `vars.tf` file to define input variables that can 
be referenced in `main.tf`

```hcl-terraform
variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = 8080
  type = "string"
}
```

## Provide variable values
There are a number of ways to provide a value for the variable, including passing it in at the command line, using
the `-var` option, the `-var file` option or via an environment variable `TF_VAR_<variable_name>`. If no variable
is found, the default value is used.

Alternatively, if the directory contains either `terraform.tfvars` or `.auto.tfvars`, these variables will be automatically
loaded. Of course, any variable set by the CLI will have precedence.
 
## Example
Remember to use the `init`, `plan`, `apply`, `show` and `destroy` commands.

## Outputs
Terraform also allows to define output variables, and will be shown at the end of the `apply` command:

```bash
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

public_ip = 34.243.230.228}
```

or when running the `terraform output` command:

```bash
$ terraform output
public_ip = 34.243.230.228}
```