#!/bin/sh

#Build docker container
Build()
{
    docker build -t safe-crossing-backend .
}

while getopts ":d" option; do
  case $option in
    d) #run in detached mode
      Build
      docker run -p 3000:3000 -p 8888:8888 -d safe-crossing-backend
      exit;;
      \?) #Invalid option
        echo "Error: Invalid option"
        echo "Syntax: run.sh [-d]"
        echo "options:"
        echo "d   run docker container in detached mode"
        exit;;
  esac
done

Build
docker run -p 3000:3000 -p 8888:8888 safe-crossing-backend
