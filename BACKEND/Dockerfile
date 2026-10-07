FROM node:20-alpine

WORKDIR /app

COPY package*.json ./

RUN npm ci --omit=dev --ignore-scripts

COPY src/ ./src/
COPY sql/ ./sql/
COPY uploads/ ./uploads/

RUN mkdir -p uploads/contracts uploads/documentos && \
    chown -R node:node /app

USER node

EXPOSE 4000

CMD ["node", "src/app.js"]