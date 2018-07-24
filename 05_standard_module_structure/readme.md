# 05_standard_module_structure
Provisions two modules, `module_a` containing the infrastructure for a simple ec2 instance, and `module_b` containing 
the infrastructure for a web server.

## Standard module structure
The standard module structure is a file and folder layout we recommend for reusable modules. Terraform tooling is built 
to understand the standard module structure and use that structure to generate documentation, index modules for the registry, and more.

The standard module expects the structure documented below. The list may appear long, but everything is optional except for the root module. 
All items are documented in detail. Most modules don't need to do any work to follow the standard structure.

- **Root module**: This is the only required element for the standard module structure. Terraform files must exist in 
the root directory of the module. This should be the primary entrypoint for the module and is expected to be opinionated. 
For the Consul module the root module sets up a complete Consul cluster. A lot of assumptions are made, however, and it is 
fully expected that advanced users will use specific nested modules to more carefully control what they want.

- **README.md**: The root module and any nested modules should have README files. There should be a description of the module 
and what it should be used for. If you want to include an example for how this module can be used in combination with other 
resources, put it in an examples directory like this. Consider including a visual diagram depicting the infrastructure 
resources the module may create and their relationship. The README doesn't need to document inputs or outputs of the module 
because tooling will automatically generate this. If you are linking to a file or embedding an image contained in the repository 
itself, use a commit-specific absolute URL so the link won't point to the wrong version of a resource in the future.

- **LICENSE**: The license under which this module is available. If you are publishing a module publicly, many organizations 
will not adopt a module unless a clear license is present. We recommend always having a license file, even if the license is non-public.

- **main.tf, variables.tf, outputs.tf**: These are the recommended filenames for a minimal module, even if they're empty. main.tf should 
be the primary entrypoint. For a simple module, this may be where all the resources are created. For a complex module, resource creation 
may be split into multiple files but all nested module usage should be in the main file. variables.tf and outputs.tf should contain the 
declarations for variables and outputs, respectively. Variables and outputs should have descriptions. All variables and outputs should have 
one or two sentence descriptions that explain their purpose. This is used for documentation.

- **Nested modules**: Nested modules should exist under the `modules/` subdirectory. Any nested module with a README.md is considered 
usable by an external user. If a README doesn't exist, it is considered for internal use only. These are purely advisory; Terraform will 
not actively deny usage of internal modules. Nested modules should be used to split complex behavior into multiple small modules that 
advanced users can carefully pick and choose. For example, the Consul module has a nested module for creating the Cluster that is separate 
from the module to setup necessary IAM policies. This allows a user to bring in their own IAM policy choices.

- **Examples**: Examples of using the module should exist under the `examples/` subdirectory at the root of the repository. Each example may have a 
README to explain the goal and usage of the example. Examples for submodules should also be placed in the root examples/ directory.