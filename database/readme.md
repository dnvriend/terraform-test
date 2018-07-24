# database

## Schema Versioning
Databases have schemas, and these schemas should be under version control. The following tools provide a way to
version control these schemas and have an option to run via the CLI:

- [Flyway](https://flywaydb.org/getstarted/firststeps/commandline) is an open source database migration tool. It strongly favors simplicity and convention over configuration. It is based around 7 basic commands: Migrate, Clean, Info, Validate, Undo, Baseline and Repair.
- [Liquibase](https://www.liquibase.org/documentation/command_line.html) is an open source database-independent library for tracking, managing and applying database schema changes. It was started in 2006 to allow easier tracking of database changes, especially in an agile software development environment.
- [DBDeploy](https://code.google.com/archive/p/dbdeploy/) is a Java tools to manage agile database development. It Manages the deployment of numbered change scripts to a SQL database, using a simple table in the database to track applied changes.
- [golang-migrate](https://github.com/golang-migrate/migrate) is a Database migration tool with CLI and Golang library.

## Local-exec Provisioner
Terraform supports registering a [provisioner](https://www.terraform.io/docs/provisioners/local-exec.html) that can be run after
a resource has been created:

```hcl-terraform
resource "aws_instance" "web" {
  # ...

  provisioner "local-exec" {
    command = "echo ${aws_instance.web.private_ip} >> private_ips.txt"
  }
}
```

The local-exec provisioner invokes a local executable after a resource is created. This invokes a process on the machine running Terraform, not on the resource.

## Remote-exec provisioner
The [remote-exec provisioner](https://www.terraform.io/docs/provisioners/remote-exec.html) invokes a script on a remote resource after it is created. 
This can be used to run a configuration management tool, bootstrap into a cluster, etc. To invoke a local process, see the local-exec provisioner instead. 
The remote-exec provisioner supports both ssh and winrm type connections.

```hcl-terraform
resource "aws_instance" "web" {
  # ...

  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}
```