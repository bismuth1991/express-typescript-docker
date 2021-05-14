##
# Base stage for all future stages, with only prod dependencies, no code yet
##

FROM node:14-alpine as base

RUN apk update \
    && apk add --no-cache curl

ENV NODE_ENV=production

EXPOSE 6789

WORKDIR /node

COPY --chown=node:node package.json package-lock.json* ./

RUN mkdir app && chown -R node:node .

USER node

RUN npm config list \
    && npm ci \
    && npm cache clean --force

ENV PATH /node/node_modules/.bin:$PATH


##
# Development stage, install dev dependencies. We don't need to copy any code in
# since we bind-mount it
##

FROM base as dev

ENV NODE_ENV=development

RUN npm config list \
    && npm install --only=development

WORKDIR /node/app

CMD ["nodemon"]


##
# Security & Audit stage, potentially run test here
##

FROM dev as audit

COPY --chown=node:node . .

RUN npm audit


##
# Build stage. Compile typescript
##

FROM audit as build

RUN npm run build


##
# Production stage. Only contains minimal deps & files
##
FROM base as prod

COPY --from=build /node/app/dist .

HEALTHCHECK --interval=10s \
    --timeout=3s \
    --retries=3 \
    CMD curl -f http://localhost:6789/healthcheck || exit 1

CMD ["node", "index.js"]
