resource "aws_vpc" "twohundreadok-vpc" {
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "twohundreadok-vpc"
  }
}

# Subnet
resource "aws_subnet" "twohundreadok-public-subnet" {
  vpc_id            = aws_vpc.twohundreadok-vpc.id
  cidr_block        = "10.0.0.0/28"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "twohundreadok public subnet"
  }
}

resource "aws_subnet" "twohundreadok-private-subnet" {
  vpc_id            = aws_vpc.twohundreadok-vpc.id
  cidr_block        = "10.0.0.16/28"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "twohundreadok private subnet"
  }
}

resource "aws_subnet" "twohundreadok-public-subnet-2" {
  vpc_id            = aws_vpc.twohundreadok-vpc.id
  cidr_block        = "10.0.0.128/28"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "twohundreadok public subnet 2"
  }
}

resource "aws_subnet" "twohundreadok-private-subnet-2" {
  vpc_id            = aws_vpc.twohundreadok-vpc.id
  cidr_block        = "10.0.0.144/28"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "twohundreadok private subnet 2"
  }
}
resource "aws_internet_gateway" "twohundreadok-vpc-ig" {
  vpc_id = aws_vpc.twohundreadok-vpc.id

  tags = {
    Name = "twohundreadok-vpc-ig"
  }
}

# resource "aws_nat_gateway" "twohundreadok-vpc-ng" {
#   # allocation_id = aws_eip.iac-e-ip.id
#   subnet_id     = aws_subnet.twohundreadok-private-subnet.id

#   tags = {
#     Name = "twohundreadok-vpc-ng"
#   }

#   # To ensure proper ordering, it is recommended to add an explicit dependency
#   # on the Internet Gateway for the VPC.
#   depends_on = [aws_internet_gateway.twohundreadok-vpc-ig]
# }

resource "aws_route_table" "twohundreadok-vpc-rt" {
  vpc_id = aws_vpc.twohundreadok-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.twohundreadok-vpc-ig.id
  }

  tags = {
    Name = "twohundreadok-vpc-rt"
  }
}

resource "aws_route_table" "twohundreadok-vpc-rt-private-1" {
  vpc_id = aws_vpc.twohundreadok-vpc.id

  tags = {
    Name = "twohundreadok-vpc-rt-private-1"
  }
}

resource "aws_main_route_table_association" "a" {
  vpc_id         = aws_vpc.twohundreadok-vpc.id
  route_table_id = aws_route_table.twohundreadok-vpc-rt.id
}

resource "aws_route_table_association" "private-1" {
  subnet_id      = aws_subnet.twohundreadok-private-subnet.id
  route_table_id = aws_route_table.twohundreadok-vpc-rt-private-1.id
}

resource "aws_route_table_association" "private-2" {
  subnet_id      = aws_subnet.twohundreadok-private-subnet-2.id
  route_table_id = aws_route_table.twohundreadok-vpc-rt-private-1.id
}

resource "aws_security_group" "lambda_sg" {
  name        = "lambda_sg"
  description = "Security Group for Lambda"
  vpc_id      = aws_vpc.twohundreadok-vpc.id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "es_sg"
  }
}