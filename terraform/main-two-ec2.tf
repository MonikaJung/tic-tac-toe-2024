provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "tic_tac_toe_key" {
  key_name   = "tic-tac-toe-key"
  public_key = file("tic-tac-toe-key.pub")
}

resource "aws_vpc" "tic_tac_toe_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "TicTacToe-VPC"
  }
}

resource "aws_subnet" "tic_tac_toe_subnet" {
  vpc_id                  = aws_vpc.tic_tac_toe_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "TicTacToe-Subnet"
  }
}

resource "aws_internet_gateway" "tic_tac_toe_igw" {
  vpc_id = aws_vpc.tic_tac_toe_vpc.id

  tags = {
    Name = "TicTacToe-IGW"
  }
}

resource "aws_route_table" "tic_tac_toe_rt" {
  vpc_id = aws_vpc.tic_tac_toe_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tic_tac_toe_igw.id
  }

  tags = {
    Name = "TicTacToe-RouteTable"
  }
}

resource "aws_route_table_association" "tic_tac_toe_rta" {
  subnet_id      = aws_subnet.tic_tac_toe_subnet.id
  route_table_id = aws_route_table.tic_tac_toe_rt.id
}

resource "aws_security_group" "frontend_sg" {
  name        = "FrontendSG"
  description = "Allow SSH and public HTTP access to frontend"
  vpc_id      = aws_vpc.tic_tac_toe_vpc.id

  ingress {
    from_port   = 22  # SSH
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000  # Public frontend
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "FrontendSG"
  }
}


resource "aws_security_group" "backend_sg" {
  name        = "BackendSG"
  description = "Allow SSH and allow access from frontend SG only"
  vpc_id      = aws_vpc.tic_tac_toe_vpc.id

  ingress {
    from_port   = 22  # SSH (optional, maybe for debugging)
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 8080  # Backend service
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id]  # Only from frontend
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "BackendSG"
  }
}


resource "aws_instance" "backend_instance" {
  ami                         = "ami-0c02fb55956c7d316"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.tic_tac_toe_subnet.id
  vpc_security_group_ids      = [aws_security_group.backend_sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.tic_tac_toe_key.key_name

  user_data = templatefile("backend-userdata.sh.tpl", {})
  tags = {
    Name = "TicTacToe-Backend"
  }
}

resource "aws_instance" "frontend_instance" {
  ami                         = "ami-0c02fb55956c7d316"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.tic_tac_toe_subnet.id
  vpc_security_group_ids      = [aws_security_group.frontend_sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.tic_tac_toe_key.key_name

  user_data = templatefile("frontend-userdata.sh.tpl", {
    backend_ip = aws_instance.backend_instance.public_ip
  })

  tags = {
    Name = "TicTacToe-Frontend"
  }
}

output "backend_public_ip" {
  value = aws_instance.backend_instance.public_ip
}

output "frontend_public_ip" {
  value = aws_instance.frontend_instance.public_ip
}

output "frontend_url" {
  value = "http://${aws_instance.frontend_instance.public_ip}:8000"
}
