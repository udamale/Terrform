provider "aws" {
  
}

resource "aws_key_pair" "name" {
  key_name = "task"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "aws_instance" "name" {
  ami = "ami-0861f4e788f5069dd"
  instance_type = "t2.micro"
  subnet_id = "subnet-09f113a76bbdf6b91"
  tags = {
    Name="ec2-server"
  }
  key_name = aws_key_pair.name.key_name
   associate_public_ip_address = true

  # connection {
  #   type = "ssh"
  #   user = "ec2-user"
  #   private_key = file("~/.ssh/id_ed25519")
  #   host = self.public_ip
  #   timeout = "2m"
  # }

   #provisioner "file" {
   #  source = "D:/AWS Notes/linux User management.txt"
   #  destination = "/home/ec2-user/linux User management.txt"

  # }

   #provisioner "remote-exec" {
   # inline = [
   #     "touch /home/ec2-user/ganesh",
   #     "echo 'hello from devpos by kartik' >> /home/ec2-user/ganesh"
   # ]
  # }
  # provisioner "local-exec" {
  #   command = "touch ganesh.txt"
  # }
}
resource "null_resource" "name" {
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("~/.ssh/id_ed25519")
    host = aws_instance.name.public_ip
    timeout = "2m"
  }
  provisioner "file" {
     source = "D:/AWS Notes/linux User management.txt"
     destination = "/home/ec2-user/linux User management.txt"
  }

  provisioner "remote-exec" {
    inline = [ 
      "touch /home/ec2-user/ganesh.txt",
      "echo 'welecome form me' >> /home/ec2-user/ganesh.txt"
     ]
  }


  triggers = {
   always_run = "${timestamp()}"
  }
  
}
#Solution-2 to Re-Run the Provisioner
#Use terraform taint to manually mark the resource for recreation:
# terraform taint aws_instance.server
# terraform apply