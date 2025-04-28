FROM node:14

WORKDIR /usr/src/app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of your application code
COPY . .

# Install MongoDB client (if not already done via package.json)
RUN npm install mongodb

# Or if you're using Mongoose, you can install that instead
# RUN npm install mongoose

CMD ["node", "index.js"]
