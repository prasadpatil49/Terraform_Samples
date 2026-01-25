
/*


resource "aws_iam_policy" "adminUsers" {
  name = "AdminUsers"
  policy = file("admin-policy.json")
}


resource "aws_iam_user" "admin-user" {
  name = "prasad"
  tags = {
    Description = "Main admin user"
  }
}

resource "aws_iam_user_policy_attachment" "admin-access" {
    user       = aws_iam_user.admin-user.name
    policy_arn = aws_iam_policy.adminUsers.arn
  
}

resource "aws_s3_bucket" "finance-bucket" {
  bucket = "finance-bucket"
  tags = {
    Description = "Finance and payroll"
  }
}

resource "aws_s3_object" "finance-2025" {
    source = "test-file.txt"
    key     = "test-file.txt"
    bucket  = aws_s3_bucket.finance-bucket.id
    acl = "public-read"
}

*/

resource "aws_dynamodb_table" "cars" {
  name = "cars"
  hash_key = "VIN"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "VIN"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "car-items" {
    table_name = aws_dynamodb_table.cars.name
    hash_key = aws_dynamodb_table.cars.hash_key
    item = <<EOF
    {
        "VIN": {"S":"1234"},
        "Make": {"S": "Toyota"},
        "Model": {"S": "Corolla"},
        "Year": {"N": "2020"},
        "Color": {"S": "Red"}
    }
EOF
  
}

resource "aws_instance" "web" {
  ami           = "ami-0f2593196fe648f28"
  instance_type = "t2.micro"
  tags = {
    Name = "webserver"
    Description = "Web server for the application"
  }
  user_data = <<EOF
    #!/bin/bash
    echo "Hello, World!" > index.html
    dnf install -y httpd
    systemctl start httpd
    systemctl enable httpd
    EOF

  vpc_security_group_ids = [aws_security_group.webserver-sg.id]
  key_name = aws_key_pair.webserver-key.id

  provisioner "local-exec" {
    command = "echo ${aws_instance.web.public_ip} > ${path.module}/public_ip.txt"
  }
}

resource "aws_key_pair" "webserver-key" {
  key_name = "webserver-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "webserver-sg" {
  name = "webserver-sg"
  description = "Security group for the webserver"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "webserver-ip" {
  value = aws_instance.web.public_ip
}