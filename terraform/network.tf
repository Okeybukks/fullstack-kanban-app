# VPC creation
resource "aws_vpc" "kanban_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

# Subnet creation
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.kanban_vpc.id
  count                   = length(var.availability_zones)
  cidr_block              = var.cidr[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public_subnet_${count.index}"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

# Internet gateway creation
resource "aws_internet_gateway" "kanban_gw" {
  vpc_id = aws_vpc.kanban_vpc.id

  tags = {
    Name = "main"
  }
}

# Route table creation
resource "aws_route_table" "kanban_rt" {
  vpc_id = aws_vpc.kanban_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kanban_gw.id
  }

  tags = {
    Name = "kanban-rt"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

# Associate the public route table with the subnets
resource "aws_route_table_association" "public_route_table_association" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.kanban_rt.id

  depends_on = [aws_route_table.kanban_rt]
}