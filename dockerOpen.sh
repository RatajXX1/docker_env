#!/bin/bash

# name="${1?needs one argument}"

name="docker_env-server"

containerId=$(docker ps | awk -v app="docker_env-server" '$2 ~ app{print $1}')
if [[ -n "$containerId" ]]; then
    docker exec -it $containerId bash
else
    echo "No docker container with name: $name is running"
fi
