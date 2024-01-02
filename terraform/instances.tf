resource "aws_instance" "kanban_ec2" {
  count                       = length(var.availability_zones)
  subnet_id                   = aws_subnet.public[count.index].id
  vpc_security_group_ids      = [aws_security_group.kanban_sg.id]
  ami                         = "ami-027a754129abb5386"
  instance_type               = "t2.medium"
  user_data                   = file("${path.module}/script.sh")
  key_name                    = "kanban"
  associate_public_ip_address = true
  availability_zone           = var.availability_zones[count.index]

  tags = {
    Name = var.instance_names[count.index]
  }
}