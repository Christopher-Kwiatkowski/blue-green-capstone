FROM nginx:1.19

## Step 1:
RUN rm /usr/share/nginx/html/index.html

## Step 2:
# Copy source code to working directory
COPY blue/index.html /usr/share/nginx/html
EXPOSE 80