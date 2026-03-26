FROM node:18-alpine
WORKDIR /app

COPY package.json ./
RUN npm install

COPY db.json ./seed.json

EXPOSE 10000

CMD cp seed.json db.json && npx json-server db.json --port ${PORT:-10000} --host 0.0.0.0
