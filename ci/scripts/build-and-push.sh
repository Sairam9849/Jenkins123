#!/bin/bash
set -e
SERVICE=$1
REGISTRY=$2
CRED_ID=$3
IMAGE="$REGISTRY/$SERVICE:latest"
docker build -t $IMAGE $SERVICE
docker push $IMAGE
