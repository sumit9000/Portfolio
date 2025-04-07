# Deployment File Structure Guide

When deploying your portfolio website to AWS Elastic Beanstalk, you need to create a `deploy.zip` file containing the following structure:

```
deploy.zip/
├── .ebextensions/               # AWS Elastic Beanstalk configuration
│   ├── nodecommand.config       # Node.js command configuration
│   ├── options.config           # Environment options
│   ├── rds-postgresql.config    # Database setup scripts
│   └── s3-assets.config         # S3 configuration for assets
├── client/
│   └── dist/                    # Built frontend files (created by npm run build)
│       ├── index.html
│       ├── assets/
│       └── ...
├── server/                      # Server code
│   ├── index.js                 # Main server file (compiled JS)
│   ├── routes.js
│   ├── storage.js
│   └── ...
├── shared/                      # Shared code (models, etc.)
│   └── schema.js
├── node_modules/                # Production dependencies only
├── .ebignore                    # Files to ignore during deployment
├── Procfile                     # Process file for Elastic Beanstalk
├── package.json                 # Package configuration
└── package-lock.json            # Dependency lock file
```

## Steps to Create the Deployment File

1. **Build your application**:
   ```bash
   # Install production dependencies
   npm ci --production

   # Build the frontend
   npm run build
   ```

2. **Manually create a zip file** containing the above structure. Make sure to:
   - Include the built frontend files in `client/dist/`
   - Include the compiled server code
   - Include all required configuration files
   - Include only production dependencies in `node_modules/`

3. **Upload this zip file** to AWS Elastic Beanstalk through the AWS Console or using the AWS CLI.

## Commands to Generate the Deployment File

On a system with the `zip` command available:

```bash
# Create a temporary directory for deployment
mkdir -p deployment-package

# Copy necessary files (adjust paths as needed)
cp -r .ebextensions deployment-package/
cp -r client/dist deployment-package/client/
cp -r server deployment-package/
cp -r shared deployment-package/
cp -r node_modules deployment-package/
cp package.json package-lock.json Procfile .ebignore deployment-package/

# Create zip file
cd deployment-package
zip -r ../deploy.zip .
cd ..

# Clean up
rm -rf deployment-package
```

This will create a `deploy.zip` file with all the necessary files for deployment.

## Deploying with AWS Elastic Beanstalk Console

1. Login to the AWS Console
2. Navigate to Elastic Beanstalk
3. Create a new application or environment
4. Upload the `deploy.zip` file when prompted
5. Configure environment settings, including database connection
6. Launch the environment

The included `deploy-aws.sh` script automates this process using the AWS CLI.