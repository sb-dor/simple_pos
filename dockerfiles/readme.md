hello.dockerfile is a test file that you do not have to use

so if you want to run specific dockerfile for ex: flutter_web.dockerfile write this command from the root of the project and
after "-t" write your image name

    docker build \
    --file ./dockerfiles/flutter_web.dockerfile \
    -t flutter-pos-web-nginx \
    .

