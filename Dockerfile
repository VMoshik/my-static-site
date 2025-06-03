FROM nginx:alpine

COPY . /usr/share/nginx/html

# Replace default index.html with index-demo.html (make demo the default homepage)
RUN mv /usr/share/nginx/html/index-demo.html /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
