#!/bin/bash

# Run the Docker container
docker run -p 5000:5000 -e NODE_ENV=production portfolio-website:latest

echo "Docker container is running on http://localhost:5000"
