FROM node:18-alpine
WORKDIR /app

COPY package.json server.js ./
RUN npm install

COPY db.json ./seed.json

EXPOSE 10000

CMD cp seed.json db.json && node server.js
