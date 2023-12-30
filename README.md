# KanBan App Documentation

This is a deployment documentaion for the KanBan Application designed and created by [Trananhtuat](https://github.com/trananhtuat). This documentation shows you how to deploy the application locally. 

The two methods for deploying locally are;

- Deploying directly on a Linux Ubuntu machine

- Deploying using docker-compose.

Also, in addition to showing how it is deployed, the following DevOps principle will be applied on this project;

- Containerization of the applications i.e Frontedn, Backend and Database.

- Creation of a Jenkins pipeline to build image, test image and subsequently push image to a public container register. This pipeline will have notification functionality integrated into it.

- Create a infrastructures needed for a Kubernetes cluster using Terraform.

- Use Ansible to automate the creation of the Kubernetes cluster in the created infrastructure.

- Create an Helm Package for the application

- Finally integrate GitOps using ArgoCD for the application deployment.

!["Full Stack Kanban App | React Node MongoDB Material-UI"](https://user-images.githubusercontent.com/67447840/177310317-3d9ad738-af83-4cc1-976a-c4a54c1033ff.png "Full Stack Kanban App | React Node MongoDB Material-UI")

# Video tutorial

    https://youtu.be/sqGowdB1tvY

# Reference

    - Create react app:https://create-react-app.dev/
    - React beautiful dnd: https://github.com/atlassian/react-beautiful-dnd/
    - Material-UI: https://mui.com/
    - Express: https://expressjs.com/

# Preview

!["Full Stack Kanban App | React Node MongoDB Material-UI"](https://user-images.githubusercontent.com/67447840/177310521-764f8ff7-5e3d-4644-ac0a-273cf83e48aa.gif "Full Stack Kanban App | React Node MongoDB Material-UI")

# Deploying Locally

## Deploying to Linux Ubuntu Machine
1. Clone the Kanban app code from github
    ```
    git clone https://github.com/Okeybukks/fullstack-kanban-app.git
    ```

2. Install node and npm for the applications
    ```
    sudo apt update
    sudo apt install nodejs
    sudo apt install npm
    
    # application requires >=10.2.5 version of npm.
    npm install -g npm@10.2.5

    ```

    Finally before installing the application dependencies, ensure the `const baseUrl = 'http://IP:5000/api/v1/'` is set with the proper IP. If you are using a vagrant box, this should be the IP of the machine.
3. Start the Client application
    ```
    cd fullstack-kanban-app/client
    npm install --force
    npm start
    ```

    The application when it starts runs on port 3000. Go to your `ip:3000` to see the application running. At the moment, the full functionality of the application will not be available because the backend server is not running which will be the next task.

4. Start the Client application
    ```
    cd fullstack-kanban-app/server
    ```
    For the backend server to work, some environment variables have to be set and a mongodb server running either locally or online.

    To setup a mongodb database locally;
    ```
    sudo apt-get install gnupg curl

    curl -fsSL https://pgp.mongodb.com/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor

    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

    sudo apt-get update


    sudo apt-get install -y mongodb-org
    ```

    To create a database for the application;
    ```
    mongosh

    use kanbandb
    ```
    With the database setup, create a `.env` file in the server folder with the follwing environment variables set.
    ```
    PORT=5000
    PASSWORD_SECRET_KEY=changeme
    TOKEN_SECRET_KEY=changeme
    MONGODB_URL="mongodb://127.0.0.1:27017/kanbandb"
    ```

    Install application dependencies and start it.
    ```
    npm install
    npm start
    ```
## Deploying locally with Docker Compose

Docker simplifies application deployment by eliminating concerns about dependencies and system environment issues. With Docker, deploying an application is as straightforward as running the docker-compose up command, parsing the Docker Compose file, and watching the application seamlessly come to life.

It's essential to have Docker Compose installed on your local system for the commands to work effectively.

Previously, I had all components—React application, Express application, and MongoDB—running from a single Docker Compose file. However, due to the frequent restarts during testing, I decided to separate the MongoDB deployment from this file. This separation ensures that the database experiences minimal interference and maintains stability, even when the applications are restarted for testing purposes.

For a trouble-free deployment of the application, it is crucial to confirm that the MongoDB service is running, and the application database is created with the appropriate user configured for necessary database operations. This preparation ensures the smooth interaction of the application with the database, contributing to a reliable deployment process.

1. Create docker volume and network.

    For data to persist, a docker volume has to be created;
    ```
    docker volume create kanban-volume
    ```
    For coomunications between the images in docker, a docker network is to be created;
    ```
    docker network create kanban-network
    ```
2. Deploy MongoDB Service
    ```
    docker compose -f monogo-compose.yaml up
    ```
3. Log into MongoDB

    To create the database need for the application, you use the values specified in the `MONGO_INITDB_ROOT_USERNAME` and `MONGO_INITDB_ROOT_PASSWORD` to login into the test database. 
    ```
    docker exec -it mongo bash

    # Login into test database
    mongosh -u admin -p password
    ```
    The `mongo` used in the above command is the name of the container specified in the doccker compose file of the MongoDB.
4. Create application database and user needed to interact with the database.

    ```
    # Create application database
    use kanbanDB

    # Create user
    db.createUser({user: "username",pwd: "password",roles: [{"role": "readWrite","db" : "kanbanDB"}]})
    ```
5. Start application.
    
    Before running the `compose.yaml` file for the frontend and backend application, change the following environment variables in the file.
    ```
    MONGODB_URL=mongodb://username:password@mongodb:27017/kanbanDB
    PASSWORD_SECRET_KEY=changeme
    TOKEN_SECRET_KEY=changeme
    REACT_APP_BACKEND_IP=<IP of system docker is installed>
    ```
    In my case, docker is installed in my vagrant box whose IP is `192.168.56.28`

    To start the application;
    ```
    docker compose up --build
    ```

    With the above commands you should be able to access your app with `IP:3000`.
    

    
