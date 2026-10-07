# =========================
# Etapa 1: Build
# =========================
FROM node:20 AS builder

WORKDIR /app

ARG VITE_API_URL=http://localhost:4444

COPY package*.json ./

RUN npm ci --ignore-scripts

COPY . .

ENV VITE_API_URL=${VITE_API_URL}

RUN npm run build


# =========================
# Etapa 2: Producción
# =========================
FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

RUN sed -i 's|^user .*;|# user nginx;|' /etc/nginx/nginx.conf && \
    sed -i 's|^pid .*;|pid /tmp/nginx.pid;|' /etc/nginx/nginx.conf && \
    chown -R nginx:nginx \
      /usr/share/nginx/html \
      /var/cache/nginx \
      /var/log/nginx \
      /etc/nginx/conf.d

USER nginx

EXPOSE 8080

ENTRYPOINT []

CMD ["nginx", "-g", "daemon off;"]