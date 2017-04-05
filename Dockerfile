FROM mariadb:10.1

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
      curl \
      dos2unix \
    && rm -rf /tmp/* /var/cache/apk/* /var/lib/apt/lists/*

COPY conf.d/*                /etc/mysql/conf.d/
COPY *.sh                    /usr/local/bin/
COPY bin/galera-healthcheck  /usr/local/bin/galera-healthcheck
COPY primary-component.sql   /

RUN dos2unix /usr/local/bin/*.sh
RUN dos2unix /etc/mysql/conf.d/*
RUN dos2unix /primary-component.sql

EXPOSE 3306 4444 4567 4567/udp 4568 8080 8081

HEALTHCHECK CMD /usr/local/bin/healthcheck.sh

ENTRYPOINT ["start.sh"]
