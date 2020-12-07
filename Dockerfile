# Sources:
# 1. https://blog.logrocket.com/containerized-development-nestjs-docker/
# 2. https://hub.docker.com/r/mhart/alpine-node/

FROM mhart/alpine-node:12 as development

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

FROM mhart/alpine-node:12 as production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install --only=production

COPY . .

COPY --from=development /usr/src/app/dist ./dist

# # Base
# FROM alpine:3.12

# WORKDIR /app

# # Dependencies
# RUN apk add --update nodejs nodejs-npm
# COPY package*.json ./
# RUN npm install

# # Build
# COPY . .
# RUN npm run build

# # Remove unnecessary packages
# RUN npm prune --production

# Application
USER node
ENV PORT=8080
EXPOSE 8080

CMD ["node", "dist/main.js"]
