# Klucz SSH
resource "aws_key_pair" "tic_tac_toe_key" {
  key_name   = "tic-tac-toe-key"
  public_key = file("tic-tac-toe-key.pub")
}

# Dostawca i region, gdzie beda tworzone zasoby
provider "aws" {
  region = "us-east-1"
}

# Prywatna siec (Virtual Private Cloud) w chmurze AWS
resource "aws_vpc" "tic_tac_toe_vpc" {
  cidr_block = "10.0.0.0/16"  # Zakres adresow IP dla VPC
  enable_dns_support = true  # Wlacza obsluge DNS w VPC
  enable_dns_hostnames = true  # Wlacza mozliwosc przypisania nazw DNS do instancji w VPC
  tags = {
    Name = "tic-tac-toe-vpc"
  }
}

# Podsiec VPC, w ktorej beda uruchamiane instancje
resource "aws_subnet" "tic_tac_toe_subnet" {
  vpc_id                  = aws_vpc.tic_tac_toe_vpc.id  # Przypisanie podsieci do odpowiedniego VPC
  cidr_block              = "10.0.1.0/24"  # Zakres IP dla tej podsieci
  availability_zone       = "us-east-1a"  # Strefa dostepnosci
  map_public_ip_on_launch = true  # Umozliwia przypisanie publicznego IP dla instancji w tej podsieci
  tags = {
    Name = "tic-tac-toe-subnet"
  }
}

# Brama internetowa umozliwiajaca dostep do Internetu
resource "aws_internet_gateway" "tic_tac_toe_igw" {
  vpc_id = aws_vpc.tic_tac_toe_vpc.id  # Przypisanie Internet Gateway do naszej VPC
  tags = {
    Name = "tic-tac-toe-igw"
  }
}

# Tabela trasowania (routingu), ktora kontroluje jak pakiety sa przesylane w VPC
resource "aws_route_table" "tic_tac_toe_route_table" {
  vpc_id = aws_vpc.tic_tac_toe_vpc.id

  # Dodanie trasy dla ruchu wychodzacego do Internetu
  route {
    cidr_block = "0.0.0.0/0"  # Ruch do wszystkich adresów
    gateway_id = aws_internet_gateway.tic_tac_toe_igw.id  # Przesylanie ruchu przez Internet Gateway
  }
  tags = {
    Name = "tic-tac-toe-route-table"
  }
}

# Przypisanie Route Table do Subnet - aby ruch przechodzil przez odpowiednia tabele trasowania
resource "aws_route_table_association" "tic_tac_toe_route_association" {
  subnet_id      = aws_subnet.tic_tac_toe_subnet.id
  route_table_id = aws_route_table.tic_tac_toe_route_table.id
}

# Tworzenie grupy zabezpieczen kontrolujacej, jaki ruch jest dozwolony do instancji EC2
resource "aws_security_group" "tic_tac_toe_sg" {
  name        = "tic-tac-toe-sg"
  description = "Security group for Tic-Tac-Toe EC2 instance"
  vpc_id      = aws_vpc.tic_tac_toe_vpc.id  # Przypisanie grupy zabezpieczeń do odpowiedniego VPC

  # Reguly dla przychodzacego ruchu (np. port 80 dla HTTP, port 443 dla HTTPS)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Pozwolenie na dostep z kazdego adresu IP
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Pozwolenie na dostep z kazdego adresu IP
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Pozwolenie na dostep z kazdego adresu IP (np. backend)
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Pozwolenie na dostep z kazdego adresu IP (np. backend)
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Reguly dla wychodzacego ruchu (dozwolony dostep do Internetu)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Pozwolenie na wszelkie protokoly
    cidr_blocks = ["0.0.0.0/0"]  # Pozwolenie na dostep do wszystkich adresow
  }

  tags = {
    Name = "tic-tac-toe-sg"
  }
}

# Instancja EC2 (komputer w chmurze AWS), ktora bedzie uruchamiala aplikacje
resource "aws_instance" "tic_tac_toe_instance" {
  ami                          = "ami-0c02fb55956c7d316"  # Identyfikator AMI
  instance_type                = "t2.micro"              # Typ instancji
  vpc_security_group_ids       = [aws_security_group.tic_tac_toe_sg.id]  # Użyj ID grupy zabezpieczeń
  associate_public_ip_address  = true                   # Przydzielenie publicznego IP
  subnet_id                    = aws_subnet.tic_tac_toe_subnet.id        # Przypisanie do podsieci
  key_name 					   = aws_key_pair.tic_tac_toe_key.key_name

  tags = {
    Name = "TicTacToeAppInstance"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y docker
              sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              sudo chmod +x /usr/local/bin/docker-compose
              sudo service docker start
              sudo systemctl enable docker
              sleep 5  # Opóźnienie na uruchomienie usługi Docker
              sudo yum install -y git
              sleep 5  # Czas na instalację GIT
              git clone https://github.com/MonikaJung/tic-tac-toe-2024.git
              cd tic-tac-toe-2024
              sleep 10  # Czas na pobranie repozytorium

              # Pętla sprawdzająca, czy docker-compose jest dostępny
              MAX_RETRIES=5
              COUNTER=0
              while ! docker-compose --version > /dev/null 2>&1; do
                if [ $COUNTER -ge $MAX_RETRIES ]; then
                  echo "Instalacja docker-compose po $MAX_RETRIES próbach nie powiodła się."
                  exit 1
                fi
                sleep 10  # Czekaj 10 sekund, aby spróbować ponownie
                COUNTER=$((COUNTER+1))
                echo "Dodatkowy czas na instalację docker-compose..."
              done
              
              sudo usermod -aG docker $(whoami)
              newgrp docker
              docker-compose up --build -d

              echo "Aplikacja została uruchomiona za pomocą Docker Compose."
            EOF

  depends_on = [aws_security_group.tic_tac_toe_sg]  # Upewnienie się, że najpierw tworzy się SG
}
