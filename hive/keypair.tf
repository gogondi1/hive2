# Create a key-pair

variable "keyname" {
type = string

}

variable "publickey" {
type = string

}
resource "aws_key_pair" "ssh-key" {
  key_name   = var.keyname
  public_key = var.publickey
}
