output "main_vpc_id" {
  description = "main vpc id"
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "loadbalancer subnet ids"
  value = [aws_subnet.pub_subnet1.id, aws_subnet.pub_subnet2.id]
}
