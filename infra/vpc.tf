resource "aws_vpc" "main" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "shiori-${terraform.workspace}-vpc"
  }
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id
  availability_zone = "ap-northeast-1a"
  cidr_block        = "10.10.1.0/24"
  tags = {
    Name = "shiori-${terraform.workspace}-private-subnet"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id = aws_vpc.main.id
  availability_zone = "ap-northeast-1a"
  cidr_block        = "10.10.2.0/24"
  tags = {
    Name = "shiori-${terraform.workspace}-public-subnet1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id = aws_vpc.main.id
  availability_zone = "ap-northeast-1c"
  cidr_block        = "10.10.3.0/24"
  tags = {
    Name = "shiori-${terraform.workspace}-public-subnet2"
  }
}
