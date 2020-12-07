# Base
FROM alpine:3.12

WORKDIR /app

# Dependencies
RUN apk add --update nodejs nodejs-npm
COPY package*.json ./
RUN npm install

# Build
COPY . .
RUN npm run build

# Remove unnecessary packages
RUN npm prune --production

# Application
USER node
ENV PORT=8080
EXPOSE 8080

CMD ["node", "dist/main.js"]
