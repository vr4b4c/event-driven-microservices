## Build
```bash
docker build -t ruby-lambda:latest .
```
## Run
```bash
docker run -p 9000:8080 ruby-lambda:latest
```
## Deploy

aws ecr get-login-password --profile private-dev | docker login --username AWS --password-stdin 827018390108.dkr.ecr.eu-north-1.amazonaws.com/event-microservices/ecommerce

docker tag ruby-lambda:latest 827018390108.dkr.ecr.eu-north-1.amazonaws.com/event-microservices/ecommerce:latest



docker push 827018390108.dkr.ecr.eu-north-1.amazonaws.com/event-microservices/ecommerce:latest

arn:aws:iam::827018390108:role/lambda-ex
