variable "ssh_key_file" {
  description = "AWS ssh key for provisioning by scripts"
  default     = "ssh_key.pem"
}

variable "ssh_key_name" {
  description = "AWS ssh key"
  default     = "ssh_key"
}

variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "eu-central-1"
}

variable "aws_availability_zone" {
  description = "The AWS AZ for ldap and mbox"
  default     = "eu-central-1c"
}

variable "test_instance_type" {
  description = "instance type of test"
  default     = "t3.medium"
}


##############################
#----- mgmt ip addresses ----
##############################
variable "mgmt_ip" {
  description = "admin access for mgmt"
  default     = ["85.140.0.0/15"]
}

#----- rdp ip addresses ----
##############################
variable "rdp_ip" {
  description = "rdp access for mgmt"
  default     = ["85.140.0.0/15"]  # mts
}

##############################
#--- instances---
##############################


#### test instance #######################


variable "aws_ami_test" {
  description = "ami-test"
  default     = "ami-0e8bb0071d6db755f"
}


#---   web ports on PROXY are accessible only from cloudflare ----
#---  Get it from https://www.cloudflare.com/ips-v4 ----
variable "cloudflare_ip" {
  description = "cloudflare ip addresses"

  default = ["173.245.48.0/20", "103.21.244.0/22", "103.22.200.0/22",
    "103.31.4.0/22",
    "141.101.64.0/18",
    "108.162.192.0/18",
    "190.93.240.0/20",
    "188.114.96.0/20",
    "197.234.240.0/22",
    "198.41.128.0/17",
    "162.158.0.0/15",
    "104.16.0.0/12",
    "172.64.0.0/13",
    "131.0.72.0/22",
  ]
}



####### latest UBUNTU images  ######
data "aws_ami" "latest_ubuntu_18" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

### output #######
output "image_id" {
  value = "${data.aws_ami.latest_ubuntu_18.id}"
}

output "instance_ips" {
  value = ["${aws_instance.test.*.public_ip}"]
}
