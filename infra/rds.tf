
resource "aws_db_subnet_group" "db_subnet" {
	name        = "db_subnet-${terraform.workspace}"
	subnet_ids  = [
    aws_subnet.private.id,
    aws_subnet.public_1.id,
    aws_subnet.public_2.id,
    ]
}

resource "aws_db_instance" "default" {
    identifier = "shiori-${terraform.workspace}-db"
    allocated_storage = 20
    engine = "mysql"
    engine_version = "8.0.20"
    instance_class = var.rds_instance_class
    name = var.database_name
    username = var.db_username
    password = var.db_password
    db_subnet_group_name = aws_db_subnet_group.db_subnet.name
    vpc_security_group_ids = [aws_security_group.db_sg.id]
    multi_az = false
    backup_retention_period = "0"
    backup_window = "19:00-19:30"
    apply_immediately = "true"
    auto_minor_version_upgrade = false
    availability_zone = "ap-northeast-1a"
    enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]
}
