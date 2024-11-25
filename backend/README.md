# Tic Tac Toe Spring Boot Maven backend app

To start the project locally open it in IntelliJ and run the Application file.

To build the docker image run command:

### `docker image build -t backend:latest .`

To start the container run:

### `docker run -p 8080:8080 --name backend backend:latest`

To stop the container run:

### `docker stop backend`

To remove the container run:

### `docker rm backend`

To see logs if there are any problems:

### `docker logs backend`