# Sources:
# 1. https://blog.logrocket.com/containerized-development-nestjs-docker/
# 2. https://hub.docker.com/r/mhart/alpine-node/
# 3. https://habr.com/ru/post/448480/

# BUILDER stage
FROM mhart/alpine-node:12 AS builder

WORKDIR /usr/src/app

# Install development dependencies
COPY ./*.json ./
RUN npm ci

# Generate dist
COPY ./src ./src
RUN npm run build

# PRODUCTION stage
FROM mhart/alpine-node:12 AS production

# Set NODE_ENV to production mode
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /usr/src/app

# Install production dependencies
COPY package*.json ./
RUN npm install pm2 -g && npm ci --only=production && npm cache clean --force && addgroup -g 2000 node && adduser -u 2000 -G node -s /bin/sh -D node

# Final result
COPY --from=builder /usr/src/app/dist ./dist

# Application
USER node
ENV PORT=8080
EXPOSE 8080

CMD ["pm2-runtime", "dist/main.js"]
