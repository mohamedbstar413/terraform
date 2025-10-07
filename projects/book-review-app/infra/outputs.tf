output "bastion_public_instance_ip" {
  value = module.backend.bastion_public_instance
}

output "db_endpoint" {
  value = module.db.db_endpoint
}
output "front_lb_dns"{ #put the lb dns as backend url for the react app inside s3
  value = module.backend.front_lb_dns
}

output "react_s3_dns" {
  value = module.application.react_s3_dns 
}

output "react_website_url" {
  value = module.application.react_website_url
}