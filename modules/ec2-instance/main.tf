# Creates one EC2 var.instance_count instances on each subnet
resource "aws_instance" "aws_ubuntu" {

  count = var.instance_count

  instance_type = var.instance_type 
  ami = var.ami
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id          = element(var.subnet_ids, count.index % length(var.subnet_ids))

  user_data =  templatefile("${path.module}/files/user_data.sh.tmpl", {
    python_app = file("${path.module}/files/app.py")
    openai_key = "${var.openai_api_key}"
  })

  tags = {
    Name = "${var.name_prefix}-${count.index}"
  }

}

