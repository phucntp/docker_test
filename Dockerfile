# Base image
FROM node:20

# Set working directory
WORKDIR /app

# Copy package files and install dependencies using Yarn
COPY package.json yarn.lock ./
RUN yarn install

# Copy the rest of the application
COPY . .

# Build the app
RUN yarn build

# Expose port
EXPOSE 3000

# Start the app
CMD ["node", "dist/main"]
