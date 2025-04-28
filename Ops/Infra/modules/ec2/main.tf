resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id] 
  associate_public_ip_address = true

  root_block_device {
    volume_size = var.volume_size
  }

  user_data = (
    var.user_data_script != null && var.user_data_script != "" ?
    file(var.user_data_script) :
    null
  )


  tags = merge(
    {
      Name = var.instance_name 
    },
    var.tags                  
  )
}
