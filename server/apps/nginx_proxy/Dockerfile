FROM nginx:latest
ENV TZ=Africa/Johannesburg
RUN rm /etc/nginx/conf.d/default.conf

COPY ./apps/nginx_proxy/localhost/ /cert/localhost/
COPY ./apps/nginx_proxy/verified.byteestudio.com/ /cert/verified.byteestudio.com/

COPY ./apps/nginx_proxy/verified-za.id/ /cert/verified-za.id/
COPY ./apps/nginx_proxy/json.verified-za.id/ /cert/json.verified-za.id/
COPY ./apps/nginx_proxy/api.verified-za.id/ /cert/api.verified-za.id/
COPY ./apps/nginx_proxy/demo.verified-za.id/ /cert/demo.verified-za.id/

COPY ./apps/nginx_proxy/reusable_locations.conf /etc/nginx/includes/reusable_locations.conf
COPY ./apps/nginx_proxy/nginx.conf /etc/nginx/conf.d/default.conf

#