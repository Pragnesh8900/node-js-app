#Getting node image
FROM node:13-alpine 
#setting up your working directory
WORKDIR /app
#copying package json files
COPY package.json package-lock.json ./
#running npm inside the docker container and installing dependencies
RUN npm install --production 
#copying everything into the docker environment
COPY . .
#exposing port
EXPOSE 3000
#running node app on port 3000
CMD node index.js
