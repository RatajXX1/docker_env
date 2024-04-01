#!/bin/bash

# name="${1?needs one argument}"

name="mag_dok-php"

containerId=$(docker ps | awk -v app="mag_dok-php" '$2 ~ app{print $1}')
if [[ -n "$containerId" ]]; then
    docker exec -it $containerId bash
else
    echo "No docker container with name: $name is running"
fi
