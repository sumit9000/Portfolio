#!/bin/bash

# Script to create Docker configuration for the portfolio website

# Create Dockerfile
cat > Dockerfile << 'EOF'
FROM node:18-alpine

# Create app directory
WORKDIR /app

# Install app dependencies
COPY package*.json ./
RUN npm ci --production

# Bundle app source
COPY . .

# Build the frontend
RUN npm run build

# Expose port
EXPOSE 5000

# Start the server
CMD ["npm", "start"]
EOF

# Create .dockerignore
cat > .dockerignore << 'EOF'
node_modules
npm-debug.log
.git
.gitignore
.env
.env.local
.env.development
*.md
!README.md
.vscode
.idea
*.log
deploy.zip
deploy-demo
deployed
EOF

# Create docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  app:
    build: .
    ports:
      - "5000:5000"
    environment:
      - NODE_ENV=production
    restart: always
    depends_on:
      - db
    
  db:
    image: postgres:14-alpine
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_DB=portfolio
    volumes:
      - portfolio_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

volumes:
  portfolio_data:
EOF

# Create Docker build script
cat > docker-build.sh << 'EOF'
#!/bin/bash

# Build Docker image
docker build -t portfolio-website:latest .

echo "Docker image 'portfolio-website:latest' built successfully."
EOF

# Create Docker run script
cat > docker-run.sh << 'EOF'
#!/bin/bash

# Run the Docker container
docker run -p 5000:5000 -e NODE_ENV=production portfolio-website:latest

echo "Docker container is running on http://localhost:5000"
EOF

# Make scripts executable
chmod +x docker-build.sh docker-run.sh

echo "Docker setup completed successfully!"
echo "You can now build and run your Docker image using:"
echo "./docker-build.sh"
echo "./docker-run.sh"
echo ""
echo "Or use docker-compose to start both the application and database:"
echo "docker-compose up -d"