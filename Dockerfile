FROM ubuntu:15.10
MAINTAINER Stephen Johnson <stevej@ucla.edu>

ENV DEBIAN_FRONTEND="noninteractive" \
    TERM="xterm"

RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup &&\
    echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache && \
    apt-get -q update && \
    apt-get install -qy --force-yes \
        apt-utils && \
    apt-get -qy --force-yes dist-upgrade && \
    apt-get install -qy --force-yes \
      ca-certificates \
      curl \
      openssl \
      sudo \
    && \
    echo "deb http://shell.ninthgate.se/packages/debian plexpass main" > /etc/apt/sources.list.d/plexmediaserver.list && \
    curl http://shell.ninthgate.se/packages/shell-ninthgate-se-keyring.key | apt-key add - && \
    apt-get -q update && \
    apt-get install -qy --force-yes plexmediaserver && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

#VOLUME ["/config","/data"]

#ADD ./start.sh /start.sh
#RUN chmod u+x  /start.sh

#ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#ENV RUN_AS_ROOT="true" \
#    CHANGE_DIR_RIGHTS="false" \
#    CHANGE_CONFIG_DIR_OWNERSHIP="true" \
#    HOME="/config"

EXPOSE 32400

RUN service plexmediaserver start

#CMD ["/start.sh"]
