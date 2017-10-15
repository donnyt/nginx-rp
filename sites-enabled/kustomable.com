proxy_cache_path /var/nginx/cache levels=1:2 keys_zone=static_cache:100m max_size=20g
                 inactive=5h use_temp_path=off;


# FORGE CONFIG (DOT NOT REMOVE!)
#include forge-conf/kustomable.com/before/*;

# FORGE CONFIG (DOT NOT REMOVE!)
include upstreams/kustomable.com;

server {
    listen 80;
    server_name kustomable.com www.kustomable.com;
    return 301 https://kustomable.com$request_uri;
}

server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name kustomable.com;

    # FORGE SSL (DO NOT REMOVE!)
    ssl_certificate /etc/nginx/ssl/kustomable.com/254848/server.crt;
    ssl_certificate_key /etc/nginx/ssl/kustomable.com/254848/server.key;

    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;

    charset utf-8;


    # FORGE CONFIG (DOT NOT REMOVE!)
    include forge-conf/kustomable.com/server/*;

    location / {
	#include static_cache.inc;
        proxy_pass http://411833_app;
	include proxy_params;
	add_header Pragma "no-cache";
    }


    location ~* ^.+\.(jpg|jpeg|gif|png|ico|svg|css|zip|tgz|gz|rar|bz2|doc|xls|exe|pdf|ppt|txt|odt|ods|odp|odf|tar|wav|bmp|rtf|js|mp3|avi|mpeg|flv|html|htm|woff|woff2|ttf)$ {
        include static_cache.inc;
        proxy_pass http://411833_app;
        include proxy_params;
	proxy_ignore_headers Cache-Control;
    }


}

# FORGE CONFIG (DOT NOT REMOVE!)
include forge-conf/kustomable.com/after/*;
