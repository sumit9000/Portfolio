#!/bin/bash

# AWS deployment script for Portfolio Website
# Usage: ./deploy-aws.sh [environment-name]

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install it first."
    exit 1
fi

# Set default environment name if not provided
ENV_NAME=${1:-portfolio-prod}
APP_NAME="portfolio-website"
VERSION_LABEL="v$(date +%Y%m%d%H%M%S)"
S3_BUCKET="portfolio-deployments-$(aws sts get-caller-identity --query Account --output text)"
ZIP_FILE="deploy.zip"

echo "==== Portfolio Website AWS Deployment ===="
echo "Environment: $ENV_NAME"
echo "Version: $VERSION_LABEL"

# Build the application
echo "Building application..."
./build.sh

# Check if S3 bucket exists, create if not
if ! aws s3 ls "s3://$S3_BUCKET" &> /dev/null; then
    echo "Creating S3 bucket for deployments..."
    aws s3 mb "s3://$S3_BUCKET" --region us-east-1
fi

# Upload deployment package to S3
echo "Uploading deployment package to S3..."
aws s3 cp "$ZIP_FILE" "s3://$S3_BUCKET/$ZIP_FILE"

# Check if application exists, create if not
if ! aws elasticbeanstalk describe-applications --application-names "$APP_NAME" &> /dev/null; then
    echo "Creating Elastic Beanstalk application..."
    aws elasticbeanstalk create-application --application-name "$APP_NAME" --description "Portfolio Website"
fi

# Create a new application version
echo "Creating new application version..."
aws elasticbeanstalk create-application-version \
    --application-name "$APP_NAME" \
    --version-label "$VERSION_LABEL" \
    --source-bundle S3Bucket="$S3_BUCKET",S3Key="$ZIP_FILE" \
    --description "Deployment on $(date)"

# Check if environment exists
if aws elasticbeanstalk describe-environments --application-name "$APP_NAME" --environment-names "$ENV_NAME" --query "Environments[0].Status" --output text &> /dev/null; then
    # Update existing environment
    echo "Updating existing environment..."
    aws elasticbeanstalk update-environment \
        --application-name "$APP_NAME" \
        --environment-name "$ENV_NAME" \
        --version-label "$VERSION_LABEL"
else
    # Create new environment
    echo "Creating new environment..."
    aws elasticbeanstalk create-environment \
        --application-name "$APP_NAME" \
        --environment-name "$ENV_NAME" \
        --solution-stack-name "64bit Amazon Linux 2 v5.8.0 running Node.js 18" \
        --option-settings file://.ebextensions/options.config \
        --version-label "$VERSION_LABEL"
fi

echo "Deployment initiated. You can check status with:"
echo "aws elasticbeanstalk describe-environments --environment-names $ENV_NAME --query 'Environments[0].{Status:Status, Health:Health}' --output table"

# Wait for deployment to complete
echo "Waiting for deployment to complete..."
aws elasticbeanstalk wait environment-updated --environment-name "$ENV_NAME"

# Show environment URL
ENVIRONMENT_URL=$(aws elasticbeanstalk describe-environments \
    --environment-names "$ENV_NAME" \
    --query "Environments[0].CNAME" \
    --output text)

echo "==== Deployment Complete ===="
echo "Your application is now live at: http://$ENVIRONMENT_URL"
echo "===============================