FROM nginx:latest
RUN rm /etc/nginx/conf.d/default.conf
COPY ./apps/nginx_proxy/localhost/ /cert/localhost/
COPY ./apps/nginx_proxy/verified.byteestudio.com/ /cert/verified.byteestudio.com/
COPY ./apps/nginx_proxy/nginx.conf /etc/nginx/conf.d/default.conf

#
ENV TZ=Africa/Johannesburg