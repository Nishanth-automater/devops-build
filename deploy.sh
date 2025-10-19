#!/bin/bash
set -e

BRANCH=${1:-dev}

DEV_IMAGE="nishanth420/capstone-dev:$BRANCH"
PROD_IMAGE="nishanth420/capstone-prod:$BRANCH"

echo "Stopping old container if exists..."
docker compose down || true

if [ "$BRANCH" == "dev" ]; then
    sed -i "s|image: .*|image: $DEV_IMAGE|" docker-compose.yml
elif [ "$BRANCH" == "main" ]; then
    sed -i "s|image: .*|image: $PROD_IMAGE|" docker-compose.yml
fi

echo "Starting container..."
docker compose up -d

echo "Deployment completed for branch $BRANCH!"

