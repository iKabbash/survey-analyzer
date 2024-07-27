#!/bin/bash

RAND_ID=$(hostname | cut -d '-' -f3)

sudo apt-get update -y
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
sudo usermod -aG docker ubuntu

sudo apt update && sudo apt upgrade -y
sudo apt install nginx python3-pip certbot python3-certbot-nginx -y

# Nginx setup
sudo sed -i 's/# server_names_hash_bucket_size 64;/server_names_hash_bucket_size 128;/g' /etc/nginx/nginx.conf
# not recommended to use --register-unsafely-without-email, take note that you can't generate more than 5 certs
sudo certbot --nginx -d survey-analyzer-${RAND_ID}.eastus.cloudapp.azure.com --register-unsafely-without-email --agree-tos
sudo mkdir -p /etc/nginx/ssl
sudo cp /etc/letsencrypt/live/survey-analyzer-${RAND_ID}.eastus.cloudapp.azure.com/fullchain.pem /etc/nginx/ssl/
sudo cp /etc/letsencrypt/live/survey-analyzer-${RAND_ID}.eastus.cloudapp.azure.com/privkey.pem /etc/nginx/ssl/

sudo cat << EOF > /etc/nginx/conf.d/survey-analyzer.conf
server {
    listen 80;
    server_name survey-analyzer-${RAND_ID}.eastus.cloudapp.azure.com;

    location / {
        return 301 https://\$host\$request_uri;
    }
}

server {
    listen 443 ssl;
    server_name survey-analyzer-${RAND_ID}.eastus.cloudapp.azure.com;
    ssl_certificate /etc/letsencrypt/live/survey-analyzer-${RAND_ID}.eastus.cloudapp.azure.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/survey-analyzer-${RAND_ID}.eastus.cloudapp.azure.com/privkey.pem; # managed by Certbot

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location /analyze {
        proxy_pass http://localhost:5000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

sudo rm /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
sudo nginx -s reload