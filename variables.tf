variable "region" {
    default = "us-east-2"
}

variable "instance_type" {
    default = "t2.micro" # free tier
}

variable "subnet_cidr" {
    default = "10.0.1.0/24"
}
variable "vpc_cidr" {
    default = "10.0.1.0/24"
}

variable "wg_port" {
    default = 51820
}
