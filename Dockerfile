# Use official Node.js base image
FROM node:20-alpine

# Set working directory inside container
WORKDIR /app

# Copy application source code to the container
COPY src/ .

# Install Node.js dependencies
RUN npm install

# Expose port 3000 (the app listens on this port)
EXPOSE 3000

# Start the Node.js app
CMD ["npm", "start"]
