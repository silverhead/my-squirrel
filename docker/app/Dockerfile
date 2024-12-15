# Alpine configuration for use Caddy with Symfony
FROM dunglas/frankenphp:1-builder-php8.4-alpine AS builder

# Copy xcaddy in the builder image
COPY --from=caddy:builder /usr/bin/xcaddy /usr/bin/xcaddy

# CGO must be enabled to build FrankenPHP
ENV CGO_ENABLED=1 XCADDY_SETCAP=1 XCADDY_GO_BUILD_FLAGS=$'-ldflags "-w -s -extldflags \'-Wl,-z,stack-size=0x80000\'"'
RUN xcaddy build \
	--output /usr/local/bin/frankenphp \
	--with github.com/dunglas/frankenphp=./ \
	--with github.com/dunglas/frankenphp/caddy=./caddy/ \
	--with github.com/dunglas/caddy-cbrotli \
	# Mercure and Vulcain are included in the official build, but feel free to remove them
	--with github.com/dunglas/mercure/caddy \
	--with github.com/dunglas/vulcain/caddy
	# Add extra Caddy modules here

# Debian source
# FROM dunglas/frankenphp:1-php8.4 AS upstream

# Alpine source
FROM dunglas/frankenphp:1-php8.4-alpine AS upstream

FROM upstream AS base

ARG GROUP_NAME=www-data
ARG USER_NAME=www-data
ARG USER_ID=1000
ARG GROUP_ID

WORKDIR /app

COPY --link app/Caddyfile /etc/caddy/Caddyfile

# Debian rights
# RUN groupadd --g ${GROUP_ID} ${USER_NAME}; \
# 	useradd -u ${USER_ID} -g ${USER_NAME} -g ${GROUP_NAME} -m ${USER_NAME}; \
# 	setcap CAP_NET_BIND_SERVICE=+eip /usr/local/bin/frankenphp; \
# 	chown -R ${USER_NAME}:${USER_NAME} /data/caddy && chown -R ${USER_NAME}:${USER_NAME} /config/caddy	

# Alpine rights
RUN \
	# Utilisez "adduser -D ${USER_NAME}" pour les distributions basées sur Alpine
	# useradd -D ${USER_NAME}; \
	adduser -D ${USER_NAME} -u ${USER_ID} -G ${GROUP_NAME}; \
	addgroup ${USER_NAME} ${GROUP_NAME}; \
	# Ajouter la capacité supplémentaire de se lier aux ports 80 et 443
	setcap CAP_NET_BIND_SERVICE=+eip /usr/local/bin/frankenphp; \
	# Donner l'accès en écriture à /data/caddy et /config/caddy
	# chown -R ${USER_NAME}:${USER_NAME} /data/caddy && chown -R ${USER_NAME}:${USER_NAME} /config/caddy
	chown -R ${USER_NAME}:${GROUP_NAME} /data/caddy && chown -R ${USER_NAME}:${GROUP_NAME} /config/caddy

# Debian extensions
# RUN apt-get update && apt-get install -y --no-install-recommends \
# 	acl \
# 	file \
# 	gettext \
# 	git \
#     wget \
# 	&& rm -rf /var/lib/apt/lists/*

# Alpine extensions
RUN apk update && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS git && apk add --no-cache git && apk del -f .build-deps

# ajoutez des extensions supplémentaires ici :
RUN set -eux; \
    install-php-extensions \
        @composer \
        apcu \
        intl \
        opcache \
        zip \
        pdo_mysql \
    ;

FROM base AS dev

RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS bash && curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.alpine.sh' | bash \
    && apk add symfony-cli && apk del -f .build-deps

# Alpine extensions Xdebug
# Add xdebug
RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS && apk add --update linux-headers \
	&& pecl install xdebug-3.4.0 && docker-php-ext-enable xdebug && apk del -f .build-deps

# Configure Xdebug
RUN echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.log=/app/var/log/xdebug.log" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.discover_client_host=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.client_port=9000" >> /usr/local/etc/php/conf.d/xdebug.ini

USER ${USER_NAME}

CMD [ "frankenphp", "run", "--config", "/etc/caddy/Caddyfile", "--watch" ]

FROM base AS prod

COPY --link app/worker.Caddyfile /etc/caddy/worker.Caddyfile

ENV APP_ENV=prod
ENV FRANKENPHP_CONFIG="import worker.Caddyfile"

USER ${USER_NAME}

CMD [ "frankenphp", "run", "--config", "/etc/caddy/Caddyfile" ]
