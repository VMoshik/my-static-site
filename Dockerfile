# Use official NGINX image
FROM nginx:alpine

# Clean default nginx files
RUN rm -rf /usr/share/nginx/html/*

# Copy your website files to nginx default directory
COPY . /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start NGINX in foreground
CMD ["nginx", "-g", "daemon off;"]
