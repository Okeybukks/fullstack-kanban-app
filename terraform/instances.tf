resource "aws_instance" "kanban_ec2" {
  count                  = var.instance_count
  subnet_id              = aws_subnet.public[count.index].id
  vpc_security_group_ids = [aws_security_group.kanban_sg.id]
  ami                    = "ami-027a754129abb5386"
  instance_type          = var.instance_type
  user_data = templatefile("${path.module}/script.sh", {
    instance_name = var.instance_names[count.index]
  })
  key_name                    = var.key_name
  associate_public_ip_address = true
  availability_zone           = var.availability_zones[count.index]
  iam_instance_profile        = var.instance_names[count.index] == "master" ? aws_iam_instance_profile.controller_profile.name : aws_iam_instance_profile.node_profile.name


  tags = {
    Name = var.instance_names[count.index]
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}