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

lifecycle {
create_before_destroy = true
}
}
resource "aws_security_group" "instance" {
name = terraform-example-instance"
ingress {
from port = "$[var.server_port}"
to port = "${var.server_port}"
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_autoscalling_group" "example" {
launch_configuration = "${aws_launch_configuration.example.id}"
availability_zones = ["${data.aws_availability_zones.all.names}"]

min_size = 2
max_size = 10
tag {
key = "Name"
value = "terraform-asg-example"
propage_at_launch=true
}
}
lifecycle {
create_before_destroy = true
}
}
tags {
Name = "terraform-example"
}

output "public_ip" {
value = "$[aws_instance.example.public_ip}"
}
