#!/bin/bash
LOGFILE="jenkins_installer_$(date +%Y%m%d_%H%M%S).log"

# -------------------------------
# 1. System Update and Prerequisites
# java is one of the prereq for jenkins installer
# -------------------------------
echo "System Updates, and installing pre-requistes" | tee -a "$LOGFILE"
sudo apt update -y 
sudo apt install -y fontconfig openjdk-21-jre
java -version  | tee -a "$LOGFILE"

# -------------------------------
# 2. Add Jenkins Repository and Key
# -------------------------------
echo "Add Jenkins Repo and relevant keys" | tee -a "$LOGFILE"
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# -------------------------------
# 3. Install Jenkins
# -------------------------------
echo "Install updates and jenkins " | tee -a "$LOGFILE"
sudo apt-get update -y
sudo apt-get install -y jenkins

# -------------------------------
# 4. Change Jenkins Port from 8080 → 8000
# jenkins config must be explicitly mentioned in override.conf
# $ sudo systemctl edit jenkins --full 
# -------------------------------
echo "Change Jenkins Listening Port" | tee -a "$LOGFILE"
sudo mkdir -p /etc/systemd/system/jenkins.service.d/
sudo bash -c 'echo "[Service]" > \
     /etc/systemd/system/jenkins.service.d/override.conf'
sudo bash -c 'echo "Environment=\"JENKINS_PORT=8000\"" >> \
    /etc/systemd/system/jenkins.service.d/override.conf'

# -------------------------------
# 5. Enable and Start Jenkins Service
# restart all relevant processes
# -------------------------------
echo "restart relevant services" | tee -a "$LOGFILE"
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl restart jenkins

# -------------------------------
#6. Verify Service and Port
# -------------------------------
sleep 10
echo "validate status" | tee -a "$LOGFILE"
sudo systemctl status jenkins --no-pager | tee -a "$LOGFILE"
sudo ss -tuln | grep 8000 | tee -a "$LOGFILE"


# -------------------------------
# useful details
# -------------------------------
    # URL: http://<your-server-ip>:8000"
    # Initial admin password:"
    # sudo cat /var/lib/jenkins/secrets/initialAdminPassword
