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
