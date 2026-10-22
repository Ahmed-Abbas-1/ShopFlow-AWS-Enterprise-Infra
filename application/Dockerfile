FROM nginx:alpine

# Copy the custom web page into the Nginx server
COPY src/index.html /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
