FROM node:17.8.0 AS build

WORKDIR /app

COPY api/package.json api/package-lock.json ./
RUN npm install --only=prod

EXPOSE 3000

COPY api ./

#Runtime stage
FROM node:17.8.0-alpine3.15
WORKDIR /app
RUN npm install pm2@latest -g
RUN chown -R node:node /app \
  && chown -R node:node ../home/node
USER node
EXPOSE 3000
COPY --from=build /app ./
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["pm2-runtime", "server.js"]