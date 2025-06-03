# Use an official lightweight image
FROM nginx:alpine

# Copy your static site files into Nginx's public folder
COPY . /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
