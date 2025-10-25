# 1. Start with a Node.js base image
FROM node:18-alpine

# 2. Set the working directory inside the container
WORKDIR /app

# 3. Copy the package.json file to install dependencies
COPY package*.json ./

# 4. Run the install command
RUN npm install

# 5. Copy the rest of your app (server.js and the 'public' folder)
COPY . .

# 6. Tell Docker what port the app runs on
EXPOSE 3000

# 7. The command to run when the container starts
CMD [ "node", "server.js" ]