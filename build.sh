#!/bin/bash

# Build script for Portfolio Website
# This script prepares the application for deployment to AWS Elastic Beanstalk

echo "==== Building Portfolio Website for Deployment ===="

# Install production dependencies
echo "Installing production dependencies..."
npm ci --production

# Build the frontend
echo "Building frontend..."
npm run build

# Create deployment package
echo "Creating deployment package..."
zip -r deploy.zip . -x "client/src/*" "node_modules/*" ".git/*" ".github/*" ".vscode/*" "*.log" ".DS_Store" "Thumbs.db"

echo "Deployment package created: deploy.zip"
echo "Build completed successfully!"