
#proxy_cache_bypass	$no_cache;
#proxy_no_cache		$no_cache
proxy_cache static_cache;
proxy_cache_revalidate on;
proxy_cache_min_uses 1;
proxy_cache_valid      200	24h;
proxy_cache_valid	404	1m;
proxy_cache_use_stale  error timeout invalid_header updating
                       http_500 http_502 http_503 http_504;
proxy_cache_lock on;
#add_header Pragma "no-cache";

