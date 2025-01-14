#!/bin/bash

CONTAINER=vicuna_container

docker exec -it $CONTAINER bash -c 'cd /mnt && python3 cuda_test.py'
