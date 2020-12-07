# Sources:
# 1. https://blog.logrocket.com/containerized-development-nestjs-docker/
# 2. https://hub.docker.com/r/mhart/alpine-node/

# DEVELOPMENT stage
FROM mhart/alpine-node:12 as development

WORKDIR /usr/src/app

# Install development dependencies
COPY package*.json ./
RUN npm install

# Generate dist
COPY . .
RUN npm run build

# PRODUCTION stage
FROM mhart/alpine-node:12 as production

# Set NODE_ENV to production mode
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /usr/src/app

# Install production dependencies
COPY package*.json ./
RUN npm install --only=production

# Add user node
RUN addgroup -g 2000 node && adduser -u 2000 -G node -s /bin/sh -D node

# Final result
COPY . .
COPY --from=development /usr/src/app/dist ./dist

# Application
USER node
ENV PORT=8080
EXPOSE 8080

CMD ["node", "dist/main.js"]
