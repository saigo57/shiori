resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "shiori-${terraform.workspace}-public-route-table"
  }
}

resource "aws_route_table_association" "qiita_rtb_assoc_pblic" {
  count          = 2
  route_table_id = aws_route_table.rtb_public.id
  subnet_id      = element([aws_subnet.public_1.id, aws_subnet.public_2.id], count.index)
}

resource "aws_route" "route_igw" {
  route_table_id         = aws_route_table.rtb_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  depends_on             = [aws_route_table.rtb_public]
}
