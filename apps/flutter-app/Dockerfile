# Build stage
FROM ghcr.io/cirruslabs/flutter:stable AS build

ARG API_URL=http://localhost:3000

WORKDIR /app
COPY . .

# Inject API URL into the source before building
RUN sed -i "s|http://localhost:3000|${API_URL}|g" lib/core/network/api_client.dart

RUN flutter pub get
RUN flutter build web --release

# Serve stage
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80

CMD sed -i "s/listen 80/listen ${PORT:-80}/g" /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'
