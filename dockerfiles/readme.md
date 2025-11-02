hello.dockerfile is a test file that you do not have ot write

so if you want to run specific dockerfile for ex: flutter_web_nginx.dockerfile
write this command

    docker build \
    --file ./dockerfiles/flutter_web_nginx.dockerfile \
    -t flutter-pos-web-nginx \
    .

