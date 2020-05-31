output "nat_data" {
  value = {
    ids = aws_instance.nat.*.id
  }
}
