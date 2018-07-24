# tests
The tests folder contains automated tests for the modules and examples.

## Description
You can use your favorite tool and/or programming language to code automated tests for the modules and examples. This
could be Scala, Python, Go, etc. 

When you want to test Terraform modules though, there is a Go library called [Terratest](https://github.com/gruntwork-io/terratest)
that can be used to write automated tests for your infrastructure code. It provides a variety of helper functions and patterns for common 
infrastructure testing tasks, including:
                 
- Testing Terraform code
- Testing Packer templates
- Testing Docker images
- Executing commands on servers over SSH
- Working with AWS APIs
- Making HTTP requests
- Running shell commands
- And much more

Using Go, you can put your Go `dep` tool to create your dependencies and some `.go` files to test.

## Concept
The purpose of terraform and Infrastructure as code tools is to make API calls, talk to the outside world, make effects.
All tests will thus be integration tests and will take some time to run. But they are very valuable.

