#!/bin/bash

rm $0

### STARTING POINT ###
apt-get update && apt-get upgrade -y
apt-get install haveged openjdk-8-jdk supervisor -y

### INSTALL VERIFIER ###
git clone https://github.com/n-y-z-o/nyzoVerifier.git
cd nyzoVerifier && ./gradlew build
mkdir -p /var/lib/nyzo/production
cp trusted_entry_points /var/lib/nyzo/production
chmod +x nyzoVerifier.sh && ./nyzoVerifier.sh && sudo cp nyzoVerifier.conf /etc/supervisor/conf.d/

### FIREWALL CONFIGURATION ###
ufw allow 9444/tcp
ufw allow 9446/udp
ufw reload

### RESTART SUPERVISOR ###
supervisorctl reload
