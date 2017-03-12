provider "aws" {
 region = "us-east-1"
 }
resource "aws_instance" "example" {
ami = "ami-40d28157"
instance_type = "t2.micro"
}

user_data = <<-EOF
#!/bin/bash
echo "hello world" > index.html
nohup busybox httpd -f -p "${var.server_port} &
EOF

resource "aws_security_group" "instance" {
name = terraform-example-instance"
ingress {
from port = "$[var.server_port}"
to port = "${var.server_port}"
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
}
output "public_ip" {
value = "$[aws_instance.example.public_ip}"
}