FROM php:7.4-cli-alpine

RUN set -eux ; \
  apk add --no-cache \
    bash \
    coreutils \
    git \
    make \
    openssh-client \
    patch \
    tini \
    unzip \
    zip

# install https://github.com/mlocati/docker-php-extension-installer
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN set -eux ; \
  # install necessary/useful extensions not included in base image
  install-php-extensions \
    @composer \
    bz2 \
    zip \
    gd \
  ; \
  # composer mirror
  composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

WORKDIR /app

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["composer"]