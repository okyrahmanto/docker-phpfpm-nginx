docker container create --name nginx-fpm-8.1 -e PORT=8080 -e INSTANCE_ID="my first instance" -p 8080:8080 nginx-fpm-alpine-8.0:0.1