##
# Base stage for all future stages, with only prod dependencies, no code yet
##

FROM node:14-alpine as base

ENV NODE_ENV=production

EXPOSE 6789

WORKDIR /node

COPY --chown=node:node package.json package-lock.json* ./

RUN mkdir app && chown -R node:node .

USER node

RUN npm install --only=production && npm cache clean --force

ENV PATH /node/node_modules/.bin:$PATH


##
# Development stage, install dev dependencies. We don't need to copy any code in
# since we bind-mount it
##

FROM base as dev

ENV NODE_ENV=development

RUN npm install --only=development

WORKDIR /node/app

CMD ["nodemon"]


##
# Build stage. Compile typescript, potentially run test here
##

FROM dev as build

COPY --chown=node:node . .

RUN npm run build


##
# Production stage. Only contains minimal deps & files
##
FROM base as prod

COPY --from=build /node/app/dist .

CMD ["node", "./index.js"]
