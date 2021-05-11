FROM node:14-alpine

EXPOSE 6789

WORKDIR /node

COPY --chown=node:node package*.json ./

RUN mkdir app && chown -R node:node .

USER node

RUN npm install && npm cache clean --force

WORKDIR /node/app

COPY --chown=node:node . .

CMD ["node", ".bin/www"]
