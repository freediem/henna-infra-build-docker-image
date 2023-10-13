FROM nginx:1.24.0-alpine3.17
 
RUN chown -R nginx:nginx /etc/nginx
RUN chown -R nginx:nginx /var/log/nginx

RUN apk add libcap
RUN setcap 'cap_net_bind_Service=+ep' /usr/sbin/nginx
