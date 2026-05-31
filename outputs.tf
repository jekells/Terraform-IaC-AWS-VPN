output "vpn_server_public_ip" {
    value = aws_instance.vpn_server.public_ip
    description = "Public IP address of the Wireguard server"
}