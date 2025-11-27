FROM jc21/nginx-proxy-manager:latest

ARG DEFAULT_PORT_HTTP=6080
ARG DEFAULT_PORT_PRODUCTTION=6081
ARG DEFAULT_PORT_HTTPS=6443

# ref: https://github.com/jlesage/docker-nginx-proxy-manager/blob/master/src/nginx-proxy-manager/build.sh

RUN \
    # Change the management interface port to the unprivileged port ${DEFAULT_PORT_PRODUCTTION}.
    sed -i "s|81 default|${DEFAULT_PORT_PRODUCTTION} default|" /etc/nginx/conf.d/production.conf \
    # Change the HTTP port 80 to the unprivileged port ${DEFAULT_PORT_HTTP}.
    && sed -i "s|80;|${DEFAULT_PORT_HTTP};|" /etc/nginx/conf.d/default.conf \
    && sed -i "s|\"80\";|"${DEFAULT_PORT_HTTP}";|" /etc/nginx/conf.d/default.conf \
    && sed -i "s|listen 80;|listen ${DEFAULT_PORT_HTTP};|" /app/templates/letsencrypt-request.conf \
    && sed -i "s|:80;|:${DEFAULT_PORT_HTTP};|" /app/templates/letsencrypt-request.conf \
    && sed -i "s|listen 80;|listen ${DEFAULT_PORT_HTTP};|" /app/templates/_listen.conf \
    && sed -i "s|:80;|:${DEFAULT_PORT_HTTP};|" /app/templates/_listen.conf \
    && sed -i "s|80 default;|${DEFAULT_PORT_HTTP} default;|" /app/templates/default.conf \
    # Change the HTTPs port 443 to the unprivileged port ${DEFAULT_PORT_HTTPS}.
    && sed -i "s|443 |${DEFAULT_PORT_HTTPS} |" /etc/nginx/conf.d/default.conf \
    && sed -i "s|\"443\";|"${DEFAULT_PORT_HTTPS}";|" /etc/nginx/conf.d/default.conf \
    && sed -i "s|listen 443 |listen ${DEFAULT_PORT_HTTPS} |" /app/templates/_listen.conf \
    && sed -i "s|:443 |:${DEFAULT_PORT_HTTPS} |" /app/templates/_listen.conf \
    && sed -i "s|:443;|:${DEFAULT_PORT_HTTPS};|" /app/templates/_listen.conf \
    && echo "done"

EXPOSE ${DEFAULT_PORT_HTTP} ${DEFAULT_PORT_HTTPS} ${DEFAULT_PORT_PRODUCTTION}
