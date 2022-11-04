locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "gobox-ami" {
  ami_name      = "${var.environment}-gobox-ami-${local.timestamp}"
  instance_type = var.instance_type
  region        = var.region
  profile       = var.aws_profile
  source_ami    = var.source_ami
  ssh_username  = "ubuntu"
}

build {
  sources = ["source.amazon-ebs.gobox-ami"]

  provisioner "shell" {
     script = "script.sh"
  }
  provisioner "file" {
     source      = "configuration.conf"
     destination = "/tmp/"
  }
  provisioner "ansible-local" {
     playbook_file = "ansible.yml"
  }
}