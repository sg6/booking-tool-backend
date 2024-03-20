resource "aws_vpc" "booking_sg6_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "booking_sg6_vpc"
  }
}

resource "aws_internet_gateway" "booking_sg6_igw" {
  vpc_id = aws_vpc.booking_sg6_vpc.id

  tags = {
    Name = "booking_sg6_igw"
  }
}

resource "aws_security_group" "eks_worker_sg" {
  name        = "eks-worker-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = aws_vpc.booking_sg6_vpc.id

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-worker-sg"
  }
}

# todo: for-loop
resource "aws_subnet" "booking_sg6_subnet1" {
  vpc_id     = aws_vpc.booking_sg6_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "booking_sg6_subnet1"
    "kubernetes.io/role/elb"    = "1"
    "kubernetes.io/cluster/booking-app-sg6-cluster" = "shared"
  }
}

resource "aws_subnet" "booking_sg6_subnet2" {
  vpc_id     = aws_vpc.booking_sg6_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "booking_sg6_subnet2"
    "kubernetes.io/role/elb"    = "1"
    "kubernetes.io/cluster/booking-app-sg6-cluster" = "shared"
  }
}

resource "aws_eip" "booking_sg6_nat" {
  vpc = true
}

resource "aws_nat_gateway" "booking_sg6_nat" {
  allocation_id = aws_eip.booking_sg6_nat.id
  subnet_id     = aws_subnet.booking_sg6_subnet1.id

  depends_on = [aws_internet_gateway.booking_sg6_igw]
}

# Allow inbound SSH traffic for e.g. trouble shooting
resource "aws_security_group_rule" "booking_sg6_ssh_sg" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["212.17.95.191/32"]
  security_group_id = aws_security_group.eks_worker_sg.id
}

# Allow inbound traffic from the security group itself (nodes communicating with each other)
resource "aws_security_group_rule" "booking_sg6_ssh_intra_sg" {
  type                    = "ingress"
  from_port               = 0
  to_port                 = 0
  protocol                = "-1"
  source_security_group_id = aws_security_group.eks_worker_sg.id
  security_group_id       = aws_security_group.eks_worker_sg.id
}

resource "aws_route_table" "booking_sg6_ssh_public_rt" {
  vpc_id = aws_vpc.booking_sg6_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.booking_sg6_igw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

# todo: for-loop
resource "aws_route_table_association" "public_rt_assoc_booking_sg6_subnet1" {
  subnet_id      = aws_subnet.booking_sg6_subnet1.id
  route_table_id = aws_route_table.booking_sg6_ssh_public_rt.id
}

resource "aws_route_table_association" "public_rt_assoc_booking_sg6_subnet2" {
  subnet_id      = aws_subnet.booking_sg6_subnet2.id
  route_table_id = aws_route_table.booking_sg6_ssh_public_rt.id
}