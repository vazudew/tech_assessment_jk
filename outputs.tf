# -------------------------------
# Jenkins URL 
# -------------------------------
output "jenkins_url" {
  description = "accessible url for ubuntu with the port"
  value       = "http://${module.jenkins_server.public_ip}:${var.jenkins_port}"
}