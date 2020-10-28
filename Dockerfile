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