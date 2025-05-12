# Use official Nginx image as the base image
FROM nginx:stable-alpine

# Set environment variable to prevent prompts from Nginx
ENV NGINX_PORT=80

# Remove default Nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy the build output to the Nginx HTML directory
COPY build/ /usr/share/nginx/html

# Optional: Copy a custom Nginx config (uncomment next line if you add nginx.conf)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]

