FROM node:latest AS node
# Set working directory
WORKDIR /app

# copy app contents, install deps, generate prod build
COPY . .
RUN npm install
RUN npm run build --prod

# nginx state for serving content
FROM nginx:alpine
# Set working directory to nginx asset directory
WORKDIR /usr/share/nginx/html
# Remove default nginx static assets
RUN rm -rf ./*
# Copy static assets from builder stage
COPY --from=node /app/dist/angular18test /usr/share/nginx/html

# Copy static assets from builder stage
RUN echo $(ls /usr/share/nginx/html)

# Containers run nginx with global directives and daemon off
ENTRYPOINT ["nginx", "-g", "daemon off;"]
