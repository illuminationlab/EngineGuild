FROM nginx:alpine

# Copy site content into nginx document root
COPY . /usr/share/nginx/html

# Replace the default nginx server config with our static-site config
# (try_files so /contact serves /contact.html, /foo/ serves /foo/index.html, etc.)
COPY default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
