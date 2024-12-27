#!/bin/bash

IMAGE=vicuna_docker_sample
TAG=latest
CONTAINER=vicuna_container

HOSTPATH=$PWD

# docker run -it --gpus all --rm --name $CONTAINER -v $HOSTPATH:/mnt $IMAGE:$TAG bash -c 'cd /mnt && python3 main.py' 
docker run -it --gpus all --rm --name $CONTAINER -v $HOSTPATH:/mnt $IMAGE:$TAG
