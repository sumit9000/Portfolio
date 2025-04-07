# Docker Deployment Guide

This guide explains how to deploy the portfolio website using Docker.

## Prerequisites

- Docker installed on your system
- Docker Compose installed on your system

## Quick Start with Docker Compose

The easiest way to run the application is using Docker Compose:

```bash
# Start the application and database
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the application
docker-compose down
```

This will start both the web application and PostgreSQL database in containers.

## Manual Docker Commands

If you prefer to manage containers manually:

### Build the Docker image

```bash
./docker-build.sh
# Or manually:
docker build -t portfolio-website:latest .
```

### Run the Docker container

```bash
./docker-run.sh
# Or manually:
docker run -p 5000:5000 -e NODE_ENV=production portfolio-website:latest
```

## Environment Variables

The following environment variables are set in docker-compose.yml:

- `NODE_ENV=production`: Sets the Node.js environment to production
- `DATABASE_URL=postgresql://postgres:postgres@db:5432/portfolio`: Connection string for the PostgreSQL database

## Database Persistence

The PostgreSQL database data is persisted in a Docker volume named `portfolio_data`.

## Customizing Deployment

You can customize the Docker deployment by modifying the following files:

- `Dockerfile`: Configure the Docker image build
- `docker-compose.yml`: Adjust service configuration and environment variables
- `.dockerignore`: Specify files to exclude from the Docker build context

## Pushing to Docker Hub

To share your Docker image, you can push it to Docker Hub:

```bash
# Log in to Docker Hub
docker login

# Tag your image
docker tag portfolio-website:latest yourusername/portfolio-website:latest

# Push the image
docker push yourusername/portfolio-website:latest
```

## Deploying to a Server

To deploy to a remote server:

1. Copy the docker-compose.yml file to your server
2. Run `docker-compose up -d` on the server

Or pull the published image:

```bash
docker pull yourusername/portfolio-website:latest
docker run -p 5000:5000 -e NODE_ENV=production yourusername/portfolio-website:latest
```
