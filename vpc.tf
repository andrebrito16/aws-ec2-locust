resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.vpc_name}-public-subnet"
  }
}

resource "aws_subnet" "public_subnet_bckp" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_bckp_cidr
  availability_zone = "us-east-1b"

  tags = {
    Name = "${var.vpc_name}-public-subnet-bckp"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.vpc_name}-private-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# Route table for public subnet for ports 8089 and 5557
resource "aws_route_table" "public_route_table" {

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_name}-public-route-table"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}
