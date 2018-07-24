# terraform-test
A small study project on [Terraform](https://www.terraform.io/)

## Introduction
[Terraform]((https://www.terraform.io/)) is an infrastructure as code software by HashiCorp. It allows users to define 
a datacenter infrastructure in a high-level configuration language, from which it can create an execution plan to build 
the infrastructure such as OpenStack or in a service provider such as IBM Cloud (formerly Bluemix), AWS, 
Microsoft Azure or Google Cloud Platform. Infrastructure is defined in a HCL Terraform syntax or JSON format.

Terraform has excellent [documentation](https://www.terraform.io/intro/index.html) and IntelliJ supports the HCL
syntax by means of a plugin.

## Configuration
Terraform uses text files to describe infrastructure and to set variables. These text files are called Terraform configurations 
and end in `.tf`. When invoking any command that loads the Terraform configuration, Terraform loads all configuration files within the directory 
specified in alphabetical order. The files loaded must end in either `.tf` or `.tf.json` to specify the format that is in use. 
Otherwise, the files are ignored. Multiple file formats can be present in the same directory; it is okay to have one Terraform 
configuration file be Terraform syntax and another be JSON. Terraform loads all configuration files within a directory and 
appends them together. This means that two resources with the same name are not merged, and will cause a validation error.

Override files are loaded **after** all non-override files, in alphabetical order. Overrides is a way to create files 
that are loaded last and merged into your configuration, rather than appended.

Overrides have a few use cases:

- Machines (tools) can create overrides to modify Terraform behavior without having to edit the Terraform configuration 
  tailored to human readability.
- Temporary modifications can be made to Terraform configurations without having to modify the configuration itself.

Overrides names must be `override` or end in `_override`, excluding the extension. Examples of valid override files 
are `override.tf`, `override.tf.json`, `temp_override.tf`.
  
The order of variables, resources, etc. defined within the configuration doesn't matter. Terraform configurations are 
declarative, so references to other resources and variables do not depend on the order they're defined.
 
## Variables
Values for the input variables of a root module can be gathered in variable definition files and passed together using 
the `-var-file=FILE` option. For all files which match `terraform.tfvars` or `*.auto.tfvars` present in the current directory, 
Terraform automatically loads them to populate variables. If the file is located somewhere else, you can pass the path to the 
file using the `-var-file` flag. It is recommended to name such files with names ending in `.tfvars`.

Both these files have the variable baz defined: 

**foo.tfvars**:

```bash
baz = "foo"
``` 

**bar.tfvars**

```bash
baz = "bar"
```

When they are passed in the following order:

```bash
$ terraform apply -var-file=foo.tfvars -var-file=bar.tfvars
```

The result will be that baz will contain the value `bar` because `bar.tfvars` has the last definition loaded. Definition files 
passed using the `-var-file` flag will always be evaluated after those in the working directory. Values passed within definition 
files or with `-var` will take precedence over `TF_VAR_` environment variables, as environment variables are considered defaults.

Comparing `modules` to `functions` in a traditional programming language, if `variables` are analogous to `function arguments` 
and `outputs` are analogous to `function return values` then `local values` are comparable to a function's `local variables`.

## Environment Variables
- **TF_LOG**: If set to any value, enables detailed logs to appear on stderr which is useful for debugging. For example: `export TF_LOG=TRACE`. 
To disable, either unset it or set it to empty. When unset, logging will default to stderr. For example: `export TF_LOG=`
- **TF_LOG_PATH**: This specifies where the log should persist its output to. Note that even when `TF_LOG_PATH` is set, 
TF_LOG must be set in order for any logging to be enabled. For example, to always write the log to the directory you're 
currently running terraform from: `export TF_LOG_PATH=./terraform.log`
- **TF_INPUT**: If set to `false` or `0`, causes terraform commands to behave as if the `-input=false` flag was specified. 
This is used when you want to disable prompts for variables that haven't had their values specified. For example: `export TF_INPUT=0`
- **TF_MODULE_DEPTH**: When given a value, causes terraform commands to behave as if the `-module-depth=VALUE` flag was specified. 
By setting this to `0`, for example, you enable commands such as plan and graph to display more compressed information. `export TF_MODULE_DEPTH=0`
- **TF_VAR_name**: Environment variables can be used to set variables. The environment variables must be in the format `TF_VAR_name` and 
this will be checked last for a value. For example: `export TF_VAR_region=us-west-1`
- **TF_CLI_ARGS and TF_CLI_ARGS_name**: The value of TF_CLI_ARGS will specify additional arguments to the command-line. 
This allows easier automation in CI environments as well as modifying default behavior of Terraform on your own system.
For example, the following command: `TF_CLI_ARGS="-input=false"` terraform apply `-force` is the equivalent to manually 
typing: `terraform apply -input=false -force`.
- **TF_DATA_DIR**: changes the location where Terraform keeps its per-working-directory data, such as the current remote backend configuration.
By default this data is written into a `.terraform` subdirectory of the current directory, but the path given in `TF_DATA_DIR` will be used instead if non-empty.
The data directory is used to retain data that must persist from one command to the next, so it's important to have this variable set consistently throughout 
all of the Terraform workflow commands (starting with terraform init) or else Terraform may be unable to find providers, modules, and other artifacts.
- **TF_SKIP_REMOTE_TESTS**: This can be set prior to running the unit tests to opt-out of any tests requiring remote network connectivity. 
The unit tests make an attempt to automatically detect when connectivity is unavailable and skip the relevant tests, but by setting this variable 
you can force these tests to be skipped.

## Modules
Modules are used in Terraform to modularize **and encapsulate** groups of resources in your infrastructure:

```hcl-terraform
module "consul" {
  source  = "hashicorp/consul/aws"
  servers = 5
}
```

A `module` block instructs Terraform to create an instance of a module, and in turn to instantiate any resources defined within it.
Within the block body is the configuration for the module. All attributes within the block must correspond to variables within the module, 
with the exception of the following which Terraform treats as special:

- **source** (Required): A module source string specifying the location of the child module source code.
- **version** (Optional): A version constraint string that specifies which versions of the referenced module are acceptable. 
The newest version matching the constraint will be used. version is supported only for modules retrieved from module registries.
- providers (Optional): A map whose keys are provider configuration names that are expected by child module and whose values 
are corresponding provider names in the calling module. This allows provider configurations to be passed explicitly to child modules. 
If not specified, the child module inherits all of the default (un-aliased) provider configurations from the calling module.

Modules in Terraform are folders with Terraform files. In fact, when you run `terraform apply`, the current working directory holding 
the Terraform files you're applying comprise what is called the `root module`. This itself is a valid module.

 
## Shell Tab-Completion
If you use either bash or zsh as your command shell, Terraform can provide tab-completion support for all command names and 
(at this time) some command arguments. To add the necessary commands to your shell profile, run the following command:

```bash
terraform -install-autocomplete
```

## State
In the default configuration, Terraform stores the state in a file in the current working directory where Terraform was run. 
This is okay for getting started, but when using Terraform in a team it is important for everyone to be working with the same 
state so that operations will be applied to the same remote objects.

Remote state is the recommended solution to this problem. With a fully-featured state backend, Terraform can use remote locking 
as a measure to avoid two or more different users accidentally running Terraform at the same time, and thus ensure that each 
Terraform run begins with the most recent updated state.

If supported by your backend, Terraform will lock your state for all operations that could write state. This prevents others 
from acquiring the lock and potentially corrupting your state. State locking happens automatically on all operations that could 
write state. You won't see any message that it is happening. If state locking fails, Terraform will not continue. You can disable 
state locking for most commands with the `-lock` flag but it is not recommended.

Terraform must initialize any configured `backend` before use. This can be done by simply running `terraform init`.
A `backend` in Terraform determines how state is loaded and how an operation such as `apply` is executed. This abstraction 
enables `non-local file state storage`, remote execution, etc. Terraform supports remote state with locking using
[S3+DynamoDB-combination](https://www.terraform.io/docs/backends/types/s3.html), [Azure blob container](https://www.terraform.io/docs/backends/types/azurerm.html),
[Google Cloud Storage (GCS)](https://www.terraform.io/docs/backends/types/gcs.html), and others, please see the Terraform doc.

The `local` backend (default), stores state on the local filesystem, locks that state using system APIs, and performs operations locally:

```hcl-terraform
terraform {
  backend "local" {
    path = "relative/path/to/terraform.tfstate"
  }
}
``` 

Note: path is Optional, The path to the tfstate file. This defaults to `terraform.tfstate` relative to the root module by default. 

## Providers
Terraform is used to create, manage, and update infrastructure resources such as physical machines, VMs, network switches, containers, and more. 
Almost any infrastructure type can be represented as a resource in Terraform. Providers provide `resources` but also `data sources` that can be
queried.  

A provider is responsible for understanding API interactions and exposing resources. Providers generally are an IaaS (e.g. AWS, GCP, Microsoft Azure, OpenStack), 
PaaS (e.g. Heroku), or SaaS services (e.g. Terraform Enterprise, DNSimple, CloudFlare). For a full list of providers see the [doc](https://www.terraform.io/docs/providers/index.html),
which ranges from Github, Gitlab to AWS, Azure, GCP, to DNS, Docker and Vault and even more are available from the [community providers](https://www.terraform.io/docs/providers/type/community-index.html) page,
ranging from Active Directory to Kafka. 

## Provisioners
[Provisioners](https://www.terraform.io/docs/provisioners/index.html) are used to execute scripts on a local or remote machine 
as part of resource creation or destruction. Provisioners can be used to bootstrap a resource, cleanup before destroy, 
run configuration management, etc. Provisioners by default run when the resource they are defined within is created.
Creation-time provisioners are only run during creation, not during updating or any other lifecycle. They are meant as a 
means to perform bootstrapping of a system. If a creation-time provisioner fails, the resource is marked as `tainted`. 
A tainted resource will be planned for destruction and recreation upon the next `terraform apply`.

If `when = "destroy"` is specified, the provisioner will run when the resource it is defined within is destroyed.
Destroy provisioners are run before the resource is destroyed. If they fail, Terraform will error and rerun the provisioners 
again on the next `terraform apply`. Due to this behavior, care should be taken for destroy provisioners to be safe to run multiple times.

Multiple provisioners can be specified within a resource. Multiple provisioners are executed in the order they're defined in the configuration file.

There are multiple provisioners available:

- [Chef (CM)](https://www.terraform.io/docs/provisioners/chef.html): The chef provisioner installs, configures and runs the Chef Client on a remote resource. The chef provisioner supports both ssh and winrm type connections.
Terraform uses a number of defaults when connecting to a resource, but these can be overridden using a connection block in either a resource or provisioner.
- [File](https://www.terraform.io/docs/provisioners/file.html): The file provisioner is used to copy files or directories from the machine executing Terraform to the newly created resource.
- [Habitat](https://www.terraform.io/docs/provisioners/habitat.html): The [Habitat](https://www.habitat.sh/) provisioner installs the Habitat supervisor and loads configured services. This provisioner only supports Linux targets using the ssh connection type at this time.
- [Local-exec](https://www.terraform.io/docs/provisioners/local-exec.html): The local-exec provisioner invokes a local executable after a resource is created. This invokes a process on the machine running Terraform, **not on the resource**.
- [Remote-exec](https://www.terraform.io/docs/provisioners/remote-exec.html): The remote-exec provisioner invokes a script on a remote resource after it is created. This can be used to run a configuration management tool, bootstrap into a cluster, etc.
- [null-resource](): The null_resource is a resource that allows you to configure provisioners that are not directly associated with a single existing resource. A null_resource behaves exactly like any other resource, so you configure provisioners, connection details, and other meta-parameters in the same way you would on any other resource.
- [Salt Masterless (CM)](https://www.terraform.io/docs/provisioners/salt-masterless.html): The salt-masterless Terraform provisioner provisions machines built by Terraform using Salt states, without connecting to a Salt master. The salt-masterless provisioner supports ssh connections.
- [Connections](https://www.terraform.io/docs/provisioners/connection.html): Many provisioners require access to the remote resource. For example, a provisioner may need to use SSH. 
        
                                         
## Chef vs Habitat vs Inspec
Chef and Habitat solve two different problems. Chef handles infrastructure complexity. Habitat runs apps smoothly on that infrastructure.

[Chef](https://www.chef.io/) is a proven automation framework for modeling infrastructure complexity. Chef shines in infrastructure automation use cases that require 
flexibility, scalability, and extensibility. Chef is good at solving the complex problems you face when developing in an infrastructure-first approach.

[Habitat](https://www.habitat.sh/) is different. Habitat aims to introduce a forward-thinking application-first approach that defers decisions about infrastructure complexity. 
“Application-first” means that Habitat enables an appdev model where infrastructure decisions can be made at runtime. But that underlying 
infrastructure still needs to be configured. Compliance on that infrastructure is still a real concern. We believe that Habitat enables 
a more delightful app dev experience than what other tools provide today.  Those tools continue to solve the problems for which they were created to solve. 
We encourage you to try Habitat for **application management** to see if its app-first approach is right for you.

**As code:**
- [Chef](https://www.terraform.io/docs/provisioners/chef.html) is useful for managing **infrastructure as code**. 
- [Habitat](https://www.habitat.sh/) is useful for managing **application management as code**
- [Inspec](https://www.inspec.io/) is still useful for managing **compliance policy as code**.

## Book
- [Terraform: Up and Running: Writing Infrastructure as Code - Yevgeniy Brikman](https://www.amazon.com/Terraform-Running-Writing-Infrastructure-Code/dp/1491977086/ref=sr_1_1) 

