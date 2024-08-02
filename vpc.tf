provider "aws" {
  region = "ap-northeast-2"
}

# vpc
resource "aws_vpc" "vpc-1" {
  cidr_block           = "10.1.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "vpc-1"
  }
}

# 인터넷 게이트 웨이
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc-1.id

  tags = {
    Name = "vpc-1-igw"
  }
}

# 서브넷
resource "aws_subnet" "publict-sub-1" {
  vpc_id                  = aws_vpc.vpc-1.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true
  # 이 부분 때문에 public ip가 부여 된다.

  tags = {
    Name = "publict-sub-1"
  }
}

resource "aws_subnet" "publict-sub-2" {
  vpc_id                  = aws_vpc.vpc-1.id
  cidr_block              = "10.1.2.0/24"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = true
  # 이 부분 때문에 public ip가 부여 된다.

  tags = {
    Name = "publict-sub-2"
  }
}

resource "aws_subnet" "private-sub-1" {
  vpc_id            = aws_vpc.vpc-1.id
  cidr_block        = "10.1.3.0/24"
  availability_zone = "ap-northeast-2a"
  # pri이기 떄문에 pub과 다르게 이부분이 없다.

  tags = {
    Name = "private-sub-1"
  }
}

resource "aws_subnet" "private-sub-2" {
  vpc_id            = aws_vpc.vpc-1.id
  cidr_block        = "10.1.4.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "private-sub-2"
  }
}

#routing table 생성
resource "aws_route_table" "rt-pub-vpc-1" {
  vpc_id = aws_vpc.vpc-1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "rt-pub-vpc-1"
  }
}

# pub 라우팅 테이블에 associate 하기
resource "aws_route_table_association" "rt-pub-as1-vpc-10-10-0-0" {
  subnet_id      = aws_subnet.publict-sub-1.id
  route_table_id = aws_route_table.rt-pub-vpc-1.id
}

resource "aws_route_table_association" "rt-pub-as2-vpc-10-10-0-0" {
  subnet_id      = aws_subnet.publict-sub-2.id
  route_table_id = aws_route_table.rt-pub-vpc-1.id
}

# private 서브넷 routing table 생성
resource "aws_route_table" "rt-pri1-vpc-1" {
  vpc_id = aws_vpc.vpc-1.id

  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_instance.nat_1.primary_network_interface_id
  }

  tags = {
    Name = "rt-pri1-vpc-1"
  }

  timeouts {
    create = "30m"
    update = "30m"
  }
}

resource "aws_route_table" "rt-pri2-vpc-1" {
  vpc_id = aws_vpc.vpc-1.id

  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_instance.nat_2.primary_network_interface_id
  }

  tags = {
    Name = "rt-pri2-vpc-1"
  }

  timeouts {
    create = "30m"
    update = "30m"
  }
}

resource "aws_route_table_association" "rt-pri1-as1-vpc-1" {
  subnet_id      = aws_subnet.private-sub-1.id
  route_table_id = aws_route_table.rt-pri1-vpc-1.id
}

resource "aws_route_table_association" "rt-pri2-as2-vpc-1" {
  subnet_id      = aws_subnet.private-sub-2.id
  route_table_id = aws_route_table.rt-pri2-vpc-1.id
}

# EIP 받아오기
resource "aws_eip" "nat-1" {
  instance = aws_instance.nat_1.id
  domain   = "vpc"
}

resource "aws_eip" "nat-2" {
  instance = aws_instance.nat_2.id
  domain   = "vpc"
}
