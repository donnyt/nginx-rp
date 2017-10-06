# FORGE CONFIG (DOT NOT REMOVE!)
include forge-conf/kustomable.com/before/*;

# FORGE CONFIG (DOT NOT REMOVE!)
include upstreams/kustomable.com;

server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name .kustomable.com;

    # FORGE SSL (DO NOT REMOVE!)
    ssl_certificate /etc/nginx/ssl/kustomable.com/254848/server.crt;
    ssl_certificate_key /etc/nginx/ssl/kustomable.com/254848/server.key;

    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;

    charset utf-8;

    access_log off;
    error_log  /var/log/nginx/kustomable.com-error.log error;

    # FORGE CONFIG (DOT NOT REMOVE!)
    include forge-conf/kustomable.com/server/*;

    location / {
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Host $http_host;
        proxy_set_header X-NginX-Proxy true;

        proxy_pass http://411833_app;
        proxy_redirect off;

        # Handle Web Socket Connections
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}

# FORGE CONFIG (DOT NOT REMOVE!)
include forge-conf/kustomable.com/after/*;
