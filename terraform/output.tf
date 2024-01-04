output instance_public_dns {
  value       = aws_instance.kanban_ec2[*].public_dns
  description = "public dns of created instance"
  depends_on  = [aws_instance.kanban_ec2]
}

output instance_name {
  value       = aws_instance.kanban_ec2[*].tags["Name"]
  description = "name"
  depends_on  = [aws_instance.kanban_ec2]
}

