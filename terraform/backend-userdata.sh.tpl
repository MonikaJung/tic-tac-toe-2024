#!/bin/bash
sudo yum update -y
sudo yum install -y docker git
sudo service docker start
sudo systemctl enable docker

git clone https://github.com/MonikaJung/tic-tac-toe-2024.git
cd tic-tac-toe-2024/backend
docker build -t backend-app .
docker run -d -p 8080:8080 backend-app