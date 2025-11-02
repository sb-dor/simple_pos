# install docker then run this command in terminal
#   docker build \
  #  --file ./dockerfiles/flutter_web_nginx.dockerfile \
  #  -t flutter-pos-web-nginx \
  #  .
#docker run --rm -p 8080:80 flutter-pos-web-nginx

# Stage 1: Build Flutter Web
FROM debian:bookworm-slim AS build-env

RUN apt-get update && apt-get install -y curl git unzip xz-utils zip libglu1-mesa libgtk-3-dev libnss3 libxss1 libasound2 sudo wget

ARG FLUTTER_SDK=/usr/local/flutter
ARG FLUTTER_VERSION=3.35.5
ARG APP=/app

RUN git clone https://github.com/flutter/flutter.git $FLUTTER_SDK
RUN cd $FLUTTER_SDK && git fetch --tags && git checkout $FLUTTER_VERSION
ENV PATH="$FLUTTER_SDK/bin:$FLUTTER_SDK/bin/cache/dart-sdk/bin:${PATH}"

WORKDIR $APP
COPY .. $APP

RUN flutter doctor -v
RUN flutter precache web
RUN flutter clean && flutter pub get && flutter build web --release

# Stage 2: Serve with nginx
FROM nginx:alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]