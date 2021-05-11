FROM node:14-alpine as prod

ENV NODE_ENV=production

EXPOSE 6789

WORKDIR /node

COPY --chown=node:node package.json package-lock.json* ./

RUN mkdir app && chown -R node:node .

USER node

RUN npm install --only=production && npm cache clean --force

ENV PATH /node/node_modules/.bin/:$PATH

WORKDIR /node/app

COPY --chown=node:node . .

CMD ["node", ".bin/www"]

FROM prod as dev

WORKDIR /node

ENV NODE_ENV=development

RUN npm install --only=development

WORKDIR /node/app

CMD ["nodemon", "./bin/www"]
