FROM ubuntu:15.10
MAINTAINER Stephen Johnson <stevej@ucla.edu>

ENV DEBIAN_FRONTEND="noninteractive" \
    TERM="xterm"

RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup && \
    apt-get install -qy --force-yes curl && \
    echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache && \
    echo "deb http://shell.ninthgate.se/packages/debian plexpass main" > /etc/apt/sources.list.d/plexmediaserver.list && \
    curl http://shell.ninthgate.se/packages/shell-ninthgate-se-keyring.key | apt-key add - && \
    apt-get -q update && \
    apt-get -qy --force-yes dist-upgrade && \
    apt-get install -qy --force-yes \
        apt-utils \
        ca-certificates \
        openssl \
        openssh-server openssh-client \
        sudo \
        plexmediaserver 

# Expose our volumes
VOLUME ["/config","/data"]

# Expose the Plex media server port
EXPOSE 32400

# Enable ssh (mostly for debug)
# RUN mkdir /var/run/sshd
# RUN echo 'root:screencast' | chpasswd
# RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# 
# SSH login fix. Otherwise user is kicked off after login
# RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
#     sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config && \
#     sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config && \
#     sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config 
# 
# ENV NOTVISIBLE "in users profile"
# RUN echo "export VISIBLE=now" >> /etc/profile
# RUN (pgrep sshd && \
#     kill -9 $(pgrep sshd) && \
#     /usr/sbin/sshd) || echo
# EXPOSE 22


# Permissions setup
ENV RUN_AS_ROOT="true" \
    CHANGE_DIR_RIGHTS="false" \
    CHANGE_CONFIG_DIR_OWNERSHIP="true" \
    HOME="/config"


# Cleanup apt
RUN apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*


### GO GO GO! ###
ADD ./start.sh /start.sh
RUN chmod u+x  /start.sh
CMD ["/start.sh"]
