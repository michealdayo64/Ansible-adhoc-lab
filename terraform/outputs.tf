output "vm_public_ip_address" {
  value = aws_instance.vm[*].public_ip
}

