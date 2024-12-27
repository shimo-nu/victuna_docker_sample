#!/bin/bash

CONTAINER=victuna_container

docker exec -it $CONTAINER bash -c 'cd /mnt && python3 main.py'
