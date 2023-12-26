# KanBan App Documentation

This is a deployment documentaion for the KanBan Application designed and created by [Trananhtuat](https://github.com/trananhtuat). This documentation shows you how to deploy the application locally. 

The two methods for deploying locally are;

a. Deploying directly on a Linux Ubuntu machine

b. Deploying using docker-compose.

Also, in addition to showing how it is deployed, the following DevOps principle will be applied on this project;

a. Containerization of the applications i.e Frontedn, Backend and Database.

b. Creation of a Jenkins pipeline to build image, test image and subsequently push image to a public container register. This pipeline will have notification functionality integrated into it.

c. create a infrastructures needed for a Kubernetes cluster using Terraform.

d. Use Ansible to automate the creation of the Kubernetes cluster in the created infrastructure.

e. Create an Helm Package for the application

f. Finally integrate GitOps using ArgoCD for the application deployment.

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
    npm install
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

    
