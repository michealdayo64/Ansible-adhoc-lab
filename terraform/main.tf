
# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vnet-ansible-adhoc-lab
  }
}

# ---------------------------
# Availability Zone lookup
# ---------------------------
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public_subnet" {

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = var.subnet-ansible-adhoc-lab
  }

}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.igw-ansible-adhoc-lab
  }

}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = var.rt-ansible-adhoc-lab
  }

}

resource "aws_route_table_association" "rt_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "sgr_name" {
  name        = var.ansiblemm
  description = "Security group for all instances"
  vpc_id      = aws_vpc.vpc.id

  # Allow SSH from your IP address
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["102.89.69.175/32"]
  }

  # Allow HTTP from anywhere
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Create EC2 Key Pair
resource "aws_key_pair" "deployer" {
  key_name   = "ansible-adhoc-lab-key"
  public_key = file(var.ansible-adhoc-key)

  tags = {
    Name = "ansible-adhoc-lab-key"
  }
}

# Create EC2 Instance
resource "aws_instance" "vm" {
  count         = length(var.vm_roles)
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  subnet_id = aws_subnet.public_subnet.id

  vpc_security_group_ids = [
    aws_security_group.sgr_name.id
  ]

  key_name = aws_key_pair.deployer.key_name

  associate_public_ip_address = true

  tags = {
    Name = var.vm_roles[count.index]
  }
}



