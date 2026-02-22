#!/bin/bash

echo "Docker disk usage before cleanup"
docker system df

echo ""
echo "Removing unused images"
docker image prune -f
docker container prune -f

echo ""
echo "Docker disk usage after cleanup"
docker system df
