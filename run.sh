#!/bin/bash

IMAGE=victuna_docker_sample
TAG=latest
CONTAINER=victuna_container

HOSTPATH=$PWD

# docker run -it --gpus all --rm --name $CONTAINER -v $HOSTPATH:/mnt $IMAGE:$TAG bash -c 'cd /mnt && python3 main.py' 
docker run -it --gpus all --rm --name $CONTAINER -v $HOSTPATH:/mnt $IMAGE:$TAG
