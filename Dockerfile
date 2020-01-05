FROM islamicnetwork/php74:latest

ARG VERSION

RUN echo "Version number: $VERSION" > /var/www/html/index.php

