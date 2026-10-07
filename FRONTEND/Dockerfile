# Etapa 1: Construcción
FROM node:20 AS builder

WORKDIR /app

ARG VITE_API_URL=http://localhost:4000

COPY package*.json ./

RUN npm ci --ignore-scripts

COPY . .

ENV VITE_API_URL=${VITE_API_URL}

RUN npm run build


# Etapa 2: Producción
FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

RUN sed -i 's/listen 80;/listen 8080;/g' /etc/nginx/conf.d/default.conf && \
    sed -i 's#pid /var/run/nginx.pid;#pid /tmp/nginx.pid;#' /etc/nginx/nginx.conf && \
    chown -R nginx:nginx /var/cache/nginx \
        /var/log/nginx \
        /etc/nginx/conf.d \
        /usr/share/nginx/html

USER nginx

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]