# Use the official NGINX base image
FROM nginx:alpine

# Remove default page (optional, for cleanliness)
RUN rm -rf /usr/share/nginx/html/*

# Copy our custom HTML into the container
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80

