# Tic Tac Toe React frontend app

To start the project locally run:

### `npm start`

Before first run use this command:

### `npm install`

To build docker image run command:

### `docker image build -t frontend:latest . `

And to start the image run:

### `docker run -dp 8000:3000 --name frontend frontend:latest`

Then open browser on website "http://localhost:8000/".

To stop the container run:

### `docker stop frontend`

To remove the container run:

### `docker rm frontend`

To see logs if there are any problems:

### `docker logs frontend`


The frontend to work properly requires active backend.