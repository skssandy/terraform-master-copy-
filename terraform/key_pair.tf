resource "tls_private_key" "app_server_prvt_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "app_server_public_key" {
  key_name   = "${var.app_env}-${var.app_id}-app-key" # Create "myKey" to AWS!!
  public_key = tls_private_key.app_server_prvt_key.public_key_openssh

  provisioner "local-exec" { # Create "myKey.pem" to your computer!!
    command = "echo '${tls_private_key.app_server_prvt_key.private_key_pem}' > ./${var.app_env}-${var.app_id}-app.pem"
  }
}

resource "tls_private_key" "bastion_prvt_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "bastion_public_key" {
  key_name   = "${var.app_env}-${var.app_id}-bastion-key" # Create "myKey" to AWS!!
  public_key = tls_private_key.bastion_prvt_key.public_key_openssh

  provisioner "local-exec" { # Create "myKey.pem" to your computer!!
    command = "echo '${tls_private_key.bastion_prvt_key.private_key_pem}' > ./${var.app_env}-${var.app_id}-bastion.pem"
  }
}