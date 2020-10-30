# Docker Notes

## To Get a Docker image from the repo (just to download)
```
docker pull [image]
```

## To List all the downloaded/created images
```
docker images
```

## To delete a downloaded/created images
Need to delete the container before the image
```
docker rm [container ID]
docker rmi [image ID]
```

## To Create a Docker Container from an Image
```
docker run [image]
```

## To Start/Restart a Docker Container
```
docker run [container ID]
```

## To Stop a Docker Container
```
docker stop [container ID]
```

## To check docker containers
```
docker ps
```

To check all containers (including stopped)
```
docker ps -a
```

## To get inside the container with bash/sh
```
docker exec -it [container ID] /bin/bash
docker exec -it [container ID] /bin/sh
```

## To Get Logs of a Docker Container
```
docker logs [container ID] -f
```

## Docker Network 
To have one or more containers in the same network

### Listing Network
```
docker network ls
```

### To Create
```
docker network create [network-name]
```

### To run mongo and mongo-express in the same network
```
docker run -d \
-p27017:27017 \
-e MONGO_INITDB_ROOT_USERNAME=admin \
-e MONGO_INITDB_ROOT_PASSWORD=password \
--network mongo-network \
--name mongodb \
-v mongo-data:/data/db \ 
mongo
```

```
docker run -it -d --rm \
-p 8081:8081 \ 
-e ME_CONFIG_MONGODB_ADMINUSERNAME=admin \ 
-e ME_CONFIG_MONGODB_ADMINPASSWORD=password  \ 
-e ME_CONFIG_MONGODB_SERVER="mongodb" \  
--network mongo-network \ 
--name mongo-express \ 
mongo-express
```


## Docker Compose
This is to have individual commands setup in a single config file.

**Docker Compose takes care of creating a common network!**


### mongo-docker-compose.yaml

```
# version of docker-compose
version: '3'
services:
    # container name
    mongodb:
        image: mongo
        ports:
            - 27017:27017
        volumes:
            - mongo-data:/data/db
        environment:
            - MONGO_INITDB_ROOT_USERNAME=admin
            - MONGO_INITDB_ROOT_PASSWORD=password

    mongo-express:
        image: mongo-express
        ports:
            - 8081:8081
        environment:
            - ME_CONFIG_MONGODB_ADMINUSERNAME=admin
            - ME_CONFIG_MONGODB_ADMINPASSWORD=password
            - ME_CONFIG_MONGODB_SERVER=mongodb

# list all the volumes used by all the containers
volumes:
    mongo-data:
        driver: local
```

### How to start / Shutdown Docker Compose
```
docker-compose -f mongo-docker-compose.yaml up -d
```
```
docker-compose -f mongo-docker-compose.yaml down -d
```

### Docker Volume Locations

3 Different types of volumes:

-v host_path:container_path    (host volumes)

-v container_path              (anonymous volumes)

-v named_path:container_path   (named volumes, *use in production*)

```
Win  : C:\ProgramData\docker\volumes
Linux: /var/lib/docker/volumes
Mac  : /var/lib/docker/volumes
```


## Docker Commit
Commit is to make a new image from a container

```
docker commit [container ID] [new image name]
```


## Dockerfile
A blueprint for building images


```
# start by basing it on another image
FROM node:13-alpine

ENV MONGO_DB_USERNAME=admin \ 
    MONGO_DB_PWD=password

# run will exec a linux command inside the container
# can have many RUN commands
RUN mkdir -p /home/app

# copy command copies from the host to the container
COPY ./app /home/app

# execute node server.js inside the container
# can only have one CMD command, this is the entry point
CMD ["node", "/home/app/server.js"]

```

## How to build a Dockerfile
```
docker build -t [image name]:[version] [Dockerfile]

E.g. docker build -t my-app:1.0 .

.....
.....
Successfully built 313422855d43  <-- is the image ID
Successfully tagged my-app:1.0

.....
.....
docker run my-app:1.0
```