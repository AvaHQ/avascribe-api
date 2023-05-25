FROM node:16.20-slim

WORKDIR /app

COPY package.json ./package.json
COPY yarn.lock ./yarn.lock

RUN yarn install --frozen

COPY generate-types.js ./generate-types.js
# to use this container, we'll want to mount the /output and the /schema directories

CMD node ./generate-types.js /schemas/* > /output/index.d.ts
