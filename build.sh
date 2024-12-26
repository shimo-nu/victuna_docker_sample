#!/bin/bash

IMAGE=victuna_docker_sample
TAG=latest

if type "docker buildx" > /dev/null 2>&1; then
  docker buildx build -t $IMAGE:$TAG .
else
  docker build -t $IMAGE:$TAG .
fi
