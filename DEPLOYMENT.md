# AWS Deployment Guide for Portfolio Website

This guide describes how to deploy your portfolio website to AWS Elastic Beanstalk with an RDS PostgreSQL database.

## Prerequisites
1. AWS Account
2. AWS CLI installed and configured
3. AWS Elastic Beanstalk CLI installed
4. Node.js and npm installed

## Deployment Steps

### 1. Build the Application
Run the build script to prepare the application for deployment:
```bash
./build.sh
```
This will create a `deploy.zip` file that contains all necessary files for deployment.

### 2. Create an Elastic Beanstalk Application
```bash
aws elasticbeanstalk create-application --application-name portfolio-website
```

### 3. Create an RDS Database
You can use the CloudFormation template provided in this repository:
```bash
aws cloudformation create-stack --stack-name portfolio-stack --template-body file://cloudformation-template.json --parameters ParameterKey=DBPassword,ParameterValue=YOUR_PASSWORD
```

### 4. Create an Elastic Beanstalk Environment
```bash
aws elasticbeanstalk create-environment \
  --application-name portfolio-website \
  --environment-name portfolio-prod \
  --solution-stack-name "64bit Amazon Linux 2 v5.8.0 running Node.js 18" \
  --option-settings file://.ebextensions/options.config
```

### 5. Deploy Your Application
```bash
aws elasticbeanstalk create-application-version \
  --application-name portfolio-website \
  --version-label v1 \
  --source-bundle S3Bucket=YOUR_S3_BUCKET,S3Key=deploy.zip

aws elasticbeanstalk update-environment \
  --application-name portfolio-website \
  --environment-name portfolio-prod \
  --version-label v1
```

### 6. Configure Environment Variables
Set up the required environment variables for your application:
```bash
aws elasticbeanstalk update-environment \
  --application-name portfolio-website \
  --environment-name portfolio-prod \
  --option-settings Namespace=aws:elasticbeanstalk:application:environment,OptionName=DATABASE_URL,Value=YOUR_DB_CONNECTION_STRING
```

### 7. Access Your Website
Once deployment is complete, you can access your website at the URL provided by Elastic Beanstalk:
```bash
aws elasticbeanstalk describe-environments \
  --application-name portfolio-website \
  --environment-names portfolio-prod \
  --query "Environments[0].CNAME" \
  --output text
```

## Custom Domain Setup (Optional)
1. Register a domain in Route 53 or use an existing domain
2. Create a CNAME record pointing to your Elastic Beanstalk environment URL
3. Configure SSL/TLS certificates using AWS Certificate Manager

## Continuous Deployment (Optional)
1. Set up a CodePipeline to automate deployments
2. Connect your GitHub repository
3. Configure build and deployment stages

## Monitoring and Maintenance
1. Set up CloudWatch alarms for monitoring
2. Configure auto-scaling policies
3. Schedule regular backups of your RDS database