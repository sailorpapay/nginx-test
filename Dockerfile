FROM ubuntu:18.04 AS nginx-build
ENV DEBIAN_FRONTEND noninteractive
ENV NGINX_VERSION 1.15.0

RUN apt-get update -qq && \
#apt install -y \
apt install  -qq -y --no-install-recommends --no-install-suggests \
autoconf        \
automake        \
build-essential \
libtool         \
wget            \
zlib1g-dev      \
unzip \
libpcre3-dev    \
make \
build-essential \
zlib1g-dev \
gcc


RUN wget --no-check-certificate -P /opt https://nginx.org/download/nginx-"$NGINX_VERSION".tar.gz
RUN tar xvzf /opt/nginx-"$NGINX_VERSION".tar.gz -C /opt


RUN cd /opt/nginx-1.15.0 && \
./configure \
        --prefix=/usr/local/nginx \
        --sbin-path=/usr/local/nginx/nginx \
        --modules-path=/usr/local/nginx/modules \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --pid-path=/run/nginx.pid \
        --lock-path=/var/lock/nginx.lock \
        --user=www-data \
        --group=www-data \
        --with-file-aio \
        --with-threads \
        --with-http_addition_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_random_index_module \
        --with-http_realip_module \
        --with-http_slice_module \
        --with-http_sub_module \
        --with-http_v2_module

RUN cd /opt/nginx-"$NGINX_VERSION"&& \
make && \
make install



FROM ubuntu:18.04
ENV DEBIAN_FRONTEND noninteractive

RUN apt clean && \
rm -rf /var/lib/apt/lists/*
RUN mkdir -p /var/log/nginx/
RUN touch /var/log/nginx/access.log
RUN touch /var/log/nginx/error.log

RUN ldconfig

COPY --from=nginx-build /usr/local/nginx/nginx /usr/local/nginx/nginx

COPY --from=nginx-build /etc/nginx /etc/nginx

COPY --from=nginx-build /usr/local/nginx/ /usr/local/nginx/
ADD index.html /usr/local/nginx/html/index.html

EXPOSE 80
RUN ln -s /usr/local/nginx/nginx /bin/nginx

CMD ["nginx", "-g", "daemon off;"]
