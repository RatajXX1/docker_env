#!/bin/bash

# name="${1?needs one argument}"

name="cde-server"

containerId=$(docker ps | awk -v app="$name" '$2 ~ app{print $1}')
if [[ -n "$containerId" ]]; then
    docker exec -it $containerId bash
else
    echo "No docker container with name: $name is running"
fi
