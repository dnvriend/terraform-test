
output "module_a_public_ip" {
  value = "${module.moduleA.public_ip}"
  sensitive = false
}

output "module_b_public_ip" {
  value = "${module.moduleB.public_ip}"
  sensitive = false
}