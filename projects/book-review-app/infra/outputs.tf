output "bastion_public_instance_ip" {
  value = module.backend.bastion_public_instance
}

output "db_endpoint" {
  value = module.db.db_endpoint
}
output "front_lb_dns"{
  value = module.backend.front_lb_dns
}