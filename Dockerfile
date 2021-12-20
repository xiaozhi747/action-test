#FROM centos:8
FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN sed -i.bak 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list \
    && sed -i 's/security.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/' /etc/apt/sources.list \
    && apt-get update \
    && apt-get -y install \
        apt-utils locales gnupg \
        git gcc cmake p7zip p7zip-full jq wget automake gettext zip unzip openssl libssl-dev \
        curl perl cpio autoconf libtool bison build-essential libz-dev libjemalloc-dev \
        libssl-dev libyaml-dev libreadline6-dev zlib1g-dev ruby-dev sqlite3 libsqlite3-dev nodejs npm \
        libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev \
        libicu-dev pkg-config libmysqlclient-dev \
    && apt-get -y upgrade \
    && npm install -g yarn \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV RBENV_VERSION=3.0.2
ENV RUBY_BUILD_MIRROR_URL=https://cache.ruby-china.com
ENV RBENV_ROOT=/usr/local/rbenv
ENV PATH=$RBENV_ROOT/shims:$RBENV_ROOT/bin:$PATH
RUN git clone --depth=1 git://github.com/rbenv/rbenv.git $RBENV_ROOT \
    && git clone --depth=1 git://github.com/rbenv/ruby-build.git $RBENV_ROOT/plugins/ruby-build \
    && git clone --depth=1 git://github.com/jamis/rbenv-gemset.git  $RBENV_ROOT/plugins/rbenv-gemset \
    && git clone --depth=1 git://github.com/rkh/rbenv-update.git $RBENV_ROOT/plugins/rbenv-update \
    && git clone --depth=1 git://github.com/AndorChen/rbenv-china-mirror.git $RBENV_ROOT/plugins/rbenv-china-mirror \
    && eval "$(rbenv init -)" \
    && rbenv install 2.5.9 \
    && rbenv install 2.6.8 \
    && rbenv install 2.7.4 \
    && rbenv install 3.0.2

COPY "entrypoint.sh" "/entrypoint.sh"
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
