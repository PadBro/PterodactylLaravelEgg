FROM php:8.3.7

RUN apt update \
    && apt -y install ffmpeg iproute2 git python3 python3-dev ca-certificates dnsutils tzdata zip tar curl build-essential libtool iputils-ping libnss3 tini libicu-dev libonig-dev \
    && docker-php-ext-install pdo pdo_mysql intl \
    && useradd -m -d /home/container container

RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

STOPSIGNAL SIGINT

COPY --chown=container:container ./start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/usr/bin/tini", "-g", "--"]

CMD ["/start.sh"]
