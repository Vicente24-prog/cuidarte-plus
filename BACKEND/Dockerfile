FROM node:18-alpine

WORKDIR /app

COPY package*.json ./

RUN npm ci --omit=dev --ignore-scripts

COPY src/ ./src/
COPY sql/ ./sql/
COPY uploads/ ./uploads/

RUN mkdir -p uploads/contracts uploads/documentos && \
    chown -R node:node /app

USER node

EXPOSE 3000

CMD ["node", "src/app.js"]