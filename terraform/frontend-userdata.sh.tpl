#!/bin/bash
sudo yum update -y
sudo yum install -y docker git
sudo service docker start
sudo systemctl enable docker

git clone https://github.com/MonikaJung/tic-tac-toe-2024.git
cd tic-tac-toe-2024/frontend

echo "REACT_APP_BACKEND_IP=${backend_ip}" > .env

docker build -t frontend-app .
sudo docker run -d -p 8000:80 frontend-app