provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.aws_region
}

############################################
#--- instances---
############################################
# variable "ssh_connection" {
#     type = map
#     default = {
#       type     = "ssh"
#       user     = "ubuntu"
#       #password = "${var.root_password}"
#       private_key = file("${var.ssh_key_file}")
#       host     = self.public_ip
#     }
# }


resource "aws_instance" "test" {
  ami           = data.aws_ami.latest_ubuntu_18.id
  instance_type = var.test_instance_type
  key_name = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.test_sg.id]
  availability_zone      = var.aws_availability_zone
  source_dest_check      = false

  root_block_device {
    delete_on_termination = "true"
  }

  # Copies the xrdp-color-config.txt file to /etc/myapp.conf
  provisioner "file" {
    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = file("${var.ssh_key_file}")
      host     = self.public_ip
    }

    source      = "xrdp-conf/xrdp-color-config.txt"
    destination = "/tmp/xrdp-color-config.txt"
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = file("${var.ssh_key_file}")
      host     = self.public_ip
    }

    inline = [
      "sleep 10",
      "sudo apt-get -y -q update",
      "sudo apt-get -y -q upgrade",
	    "sudo apt-get -y -q install kubuntu-desktop",
	    "sudo apt-get -y -q install xrdp",
      "sudo apt-get -y -q install mc",
	    "sudo useradd -m user-01",
      "sudo mv /tmp/xrdp-color-config.txt /etc/polkit-1/localauthority/50-local.d/45-allow.colord.pkla",
      "wget https://bitcoin.org/bin/bitcoin-core-0.19.1/bitcoin-0.19.1-x86_64-linux-gnu.tar.gz -O /tmp/bitcoin.tar.gz",
      "sudo tar -xzvf /tmp/bitcoin.tar.gz -C /home/user-01/",
      "sudo chmod 777 /home/user-01/bitcoin* -R",
    ]
  }



  # connection {
  #   type = "ssh"
  #   user = "ubuntu"
  #   private_key = file("${var.ssh_key_file}")
  # }

  tags = {
    Name  = "test"
    group = "test"
  }

  volume_tags = {
    Name  = "test"
    group = "test"
  }
}

resource "aws_eip" "test_eip" {
  #instance = "aws_instance.test.id"
  vpc = true
  #name       = "test"
  depends_on = [aws_instance.test]

  tags = {
    Name  = "test"
    group = "web_servers"
  }
}

resource "aws_eip_association" "test_eip_assoc" {
  instance_id   = aws_instance.test.id
  allocation_id = aws_eip.test_eip.id
}

#### привязываем внешний IP адрес

#resource "aws_eip_association" "eip_xmpp_assoc" {
#  instance_id   = aws_instance.xmpp.id
#  allocation_id = data.aws_eip.xmpp_eip_allocation_id.id
#}
