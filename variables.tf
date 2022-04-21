variable "GCP_PROJECT" {}
variable "SSH_USER" {}
variable "SSH_PUBKEY" {}
variable "VPC_NAME" {}
variable "region" {
  default = "us-central1"
}

variable "image_family" {
  default = "debian-9"
}

variable "image_project" {
  default = "debian-cloud"
}


variable "zone" {
  default = "us-central1-c"
}

variable "machine_type" {
  default = "f1-micro"
}
