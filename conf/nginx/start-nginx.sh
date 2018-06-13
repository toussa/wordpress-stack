#!/bin/bash

/tools/wait-for-it.sh php-wp:9000 -t 60

cd /nginx;
mkdir -p ${NGINX_CONFIG_ROOT};

for i in `ls *.conf`
do
  /tools/detemplatize-it.sh /nginx/$i:${NGINX_CONFIG_ROOT}/$i
done

nginx -c ${NGINX_CONFIG_ROOT}/nginx.conf -p /etc/nginx
