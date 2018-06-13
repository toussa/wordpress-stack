# wordpress-stack

Optimised (but old) docker-compose stack for wordpress with NGINX and MariaDB.

__This project is not maintained anymore and is here for history only__

This is the stack I used, back in 2016, for all my wordpress deployments.
At that time, docker swarm did not exist and I was looking for a solid stack for wordpress, with Nginx.

This stack is made to be used behind the reverse proxy [jwilder/nginx-proxy ](https://github.com/jwilder/nginx-proxy) and the associated let's encrypt automation [alastaircoote/docker-letsencrypt-nginx-proxy-companion](https://github.com/alastaircoote/docker-letsencrypt-nginx-proxy-companion)

The nginx configuration is modified to work well with the wordpress cache plugin: [W3 Total Cache](https://fr.wordpress.org/plugins/w3-total-cache/); and SEO plugin[Yoast SEO](https://fr.wordpress.org/plugins/wordpress-seo/)

TODO (but wasn't): add redis or memcache

## Structure

-conf:  
 |-db  
 | |-mysql.env: mariadb related environment variable.  
 |  
 |-nginx  
 | |-nginx.conf: *Template. Entrypoint for nginx's config*  
 | |-website.conf: *Template. Nginx website config*  
 | |-restrictions.conf: *Template. nginx rules to restrict file access*  
 | |-wordpress.conf: *Template. All config rules for wordpress, and its cache plugin W3TC*  
 | |-start-nginx.sh : *wait for php-fpm, detemplatize config files and run nginx.*  
 |  
 |-tools  
 | |-detemplatize.sh: *script to replace env variables in given template*  
 | |-wait-for-it.sh: *wait for a container to be up and ready to network.*  
 |  
 |-wp  
 | |-uploads.ini: *php config (upload limit, ...)*  
 | |-wordpress.env: *Worpress related environment variable.*  
 |  
-docker-compose.yml  
-docker-images: *contains images to build*  
 | |-php-wp: *wrapper of the wordpress image to include php libmemcached extension.*  
 | | |-Dockerfile  

## Prepare and launch

Before starting the stack, you need to:
- set environement variables in conf/db/mysql.env and conf/wp/wordpress.env to suit your needs.
- if you want, you can also change php config in conf/wp/uploads.ini
- in docker-compose.yml, change environment variables in the nginx service
  - VIRTUAL_HOST: virtual host to use with jwilder/nginx-proxy
  - LETSENCRYPT_HOST and LETSENCRYPT_EMAIL: env variable to automatically set let's encrypt, thanks to alastaircoote/docker-letsencrypt-nginx-proxy-companion  
  - NGINX_SERVER_NAME: nginx will listen to this server name.

Then, launch with the classic `docker-compose up -d` and watch logs with `docker-compose logs -f`
