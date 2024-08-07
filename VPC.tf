// Create VPC
resource "aws_vpc" "k8s_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "k8s_vpc"
    region = "var.region"
    owner_contact = "veeru_mot"
  }
}

// Create Subnet

resource "aws_subnet" "k8s_vpc_publicsubnet" {
  vpc_id     = aws_vpc.k8s_vpc.id
  cidr_block = "10.1.0.0/24"

  tags = {
    Name = "k8s_vpc_publicsubnet"
  }
}

resource "aws_subnet" "k8s_vpc_privatesubnet" {
  vpc_id     = aws_vpc.k8s_vpc.id
  cidr_block = "10.2.0.0/24"

  tags = {
    Name = "k8s_vpc_private"
  }
}
// Create Internet Gateway
resource "aws_internet_gateway" "k8s_vpc_igw" {
  vpc_id = aws_vpc.k8s_vpc.id

  tags = {
    Name = "k8s_vpc_igw"
  }
}

// Create Route Table
resource "aws_route_table" "k8s_vpc_routetable" {
  vpc_id = aws_vpc.k8s_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s_vpc_igw.id
  }

  tags = {
    Name = "k8s_vpc_routetable"
  }
}

//associate subnet with route table
resource "aws_route_table_association" "k8s_vpc-rt-association" {
  subnet_id      = aws_subnet.k8s_vpc_publicsubnet.id
  route_table_id = aws_route_table.k8s_vpc_routetable.id
}

# // Create Security Group
# resource "aws_security_group" "k8s_vpc_SG" {
#   name        = "k8s_vpc_SG"
#   vpc_id      = aws_vpc.k8s_vpc.id

#   ingress {
#     from_port        = 20
#     to_port          = 20
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = {
#     Name = "k8s_vpc_SG"
#   }
# }

# // Create EC2 Instance

# resource "aws_instance" "portfolio_EC2_Instance" {
#   ami           = "ami-0fc5d935ebf8bc3bc" # us-east-1
#   instance_type = "t2.micro"
#   key_name   = "portfolio"
#   subnet_id = aws_subnet.k8s_vpc_Publicsubnet.id
#   vpc_security_group_ids = [aws_security_group.k8s_vpc_SG.id]

# }