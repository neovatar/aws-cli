# AWS CLI Docker Image

Containerized AWS CLI on alpine to avoid requiring the aws cli to be installed on CI machines.

## Build

```
docker build -t neovatar/aws-cli .
```

Automated build on Docker Hub

[![DockerHub Badge](http://dockeri.co/image/neovatar/aws-cli)](https://hub.docker.com/r/neovatar/aws-cli/)

## Usage

Configure:

```
export AWS_ACCESS_KEY_ID="<id>"
export AWS_SECRET_ACCESS_KEY="<key>"
export AWS_DEFAULT_REGION="<region>"
```

Run example:

```
docker run -ti \
  -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
  -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
  -e AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION} \
  neovatar/aws-cli ec2 describe-instances
```
