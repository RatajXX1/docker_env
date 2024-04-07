FROM debian:bookworm

SHELL [ "/bin/bash", "-c" ]

# enivroments

ENV MYSQL_VERSION="8.0"
ENV MYSQL_PASSWORD="ROOT"
ENV MYSQL_DATABASE="DB"

# Install mysql
RUN apt-get -qq update
RUN apt-get -qq install --no-install-recommends --no-install-suggests -y \
    apt-transport-https \
    ca-certificates \
    bzip2 \
    curl \
    git \
    gnupg \
    less \
    lsb-release \
    procps \
    tree \
    vim \
    wget \
    clang \
    autoconf


# RUN DEBIAN_FRONTEND=noninteractive dpkg -i /tmp/mysql-apt-config.deb && rm /tmp/mysql-apt-config.deb
# RUN debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/repo-codename select bookworm' \
#     debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/repo-distro select debian' \
#     debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/repo-url string http://repo.mysql.com/apt/' \
#     debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-preview select ' \
#     debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-product select Ok' \
#     debconf-set-selections <<< "mysql-apt-config mysql-apt-config/select-server select mysql-$MYSQL_VERSION" \
#     debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-tools select ' \
#     debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/unsupported-platform select abort'
# RUN wget https://dev.mysql.com/get/mysql-apt-config_0.8.29-1_all.deb -O /tmp/mysql-apt-config.deb
# RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
# RUN dpkg -i  /tmp/mysql-apt-config.deb
# RUN wget -qO /etc/apt/trusted.gpg.d/mysql.gpg https://repo.mysql.com/RPM-GPG-KEY-mysql-2023 && \
#     chmod 644 /etc/apt/trusted.gpg.d/mysql.gpg

# RUN gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys B7B3B788A8D3785C
# RUN rm /usr/share/keyrings/mysql-apt-config.gpg
# RUN gpg  --output /usr/share/keyrings/mysql-apt-config.gpg --export B7B3B788A8D3785C
# RUN echo 'deb [ signed-by=/usr/share/keyrings/mysql-apt-config.gpg ] http://repo.mysql.com/apt/debian/ bookworm mysql-8.0' > /etc/apt/sources.list.d/mysql.list

RUN set -eux; \
    # pub   rsa4096 2023-10-23 [SC] [expires: 2025-10-22]
    #       BCA4 3417 C3B4 85DD 128E  C6D4 B7B3 B788 A8D3 785C
    # uid           [ unknown] MySQL Release Engineering <mysql-build@oss.oracle.com>
    # sub   rsa4096 2023-10-23 [E] [expires: 2025-10-22]
    key='BCA4 3417 C3B4 85DD 128E C6D4 B7B3 B788 A8D3 785C'; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key"; \
    mkdir -p /etc/apt/keyrings; \
    gpg --batch --export "$key" > /etc/apt/keyrings/mysql.gpg; \
    gpgconf --kill all; \
    rm -rf "$GNUPGHOME"

RUN { \
    echo mysql-community-server mysql-community-server/data-dir select ''; \
    echo mysql-community-server mysql-community-server/root-pass password ''; \
    echo mysql-community-server mysql-community-server/re-root-pass password ''; \
    echo mysql-community-server mysql-community-server/remove-test-db select false; \
    } | debconf-set-selections \
    && apt-get update \
    && apt-get install -y \
    mysql-community-client="${MYSQL_VERSION}" \
    mysql-community-server-core="${MYSQL_VERSION}" \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/lib/mysql && mkdir -p /var/lib/mysql /var/run/mysqld \
    && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
    # ensure that /var/run/mysqld (used for socket and lock files) is writable regardless of the UID our mysqld instance ends up having at runtime
    && chmod 1777 /var/run/mysqld /var/lib/mysql

VOLUME /var/lib/mysql

RUN DEBIAN_FRONTEND=noninteractiv apt-get -qq update
RUN apt search mysql-comuni
RUN apt-get -qq install --no-install-recommends --no-install-suggests -y mysql-server

EXPOSE 3306
CMD [ "mysqld" ]
