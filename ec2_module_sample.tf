
data "aws_subnet_ids" "all" {
  vpc_id = var.vpc_id
}

data "aws_subnet" "first_subnet" {
  id = tolist(data.aws_subnet_ids.all.ids)[0]
}

// Data source to get the latest approved AMI
data "aws_ami" "latest_aws_linux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_security_group" "my_test_sg_sample" {
  name   = "My_test_sg_sample"
  vpc_id = var.vpc_id
  tags = merge(
    var.common_tags
  )
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_ec2_sample_test_instance" {
  #  count = var.instance_count
  ami           = data.aws_ami.latest_aws_linux.id
  instance_type = var.instance_type
  #  user_data              = var.user_data
  subnet_id = var.subnet_id ? var.subnet_id : data.aws_subnet.first_subnet.id
  #  iam_instance_profile   = var.iam_instance_profile
  #  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.my_test_sg_sample.id]
  volume_tags            = { volName = "volume name tag example" }
  root_block_device {
    encrypted = true
  }
  tags = merge(
    var.common_tags,
    {
      Name = "custom_name_tag"
    }
  )
}


