# Build stage
FROM node:18-alpine AS build

ARG API_URL=http://localhost:3000

WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm ci
COPY . .

# Inject API URL into the source before building
RUN sed -i "s|http://localhost:3000|${API_URL}|g" src/app/core/http/api-client.service.ts

RUN npx ng build --configuration=production

# Serve stage
FROM nginx:alpine
COPY --from=build /app/dist/angular-app/browser /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80

CMD sed -i "s/listen 80/listen ${PORT:-80}/g" /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'
