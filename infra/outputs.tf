output "instance_public_ip" {
  value = aws_eip.elastic_ip.public_ip
}

output "ec2_id" {
  value = aws_instance.app_server.id
}
