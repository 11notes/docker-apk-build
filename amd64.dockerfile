# :: Header
  FROM 11notes/alpine:stable
  ENV APP_ROOT="/apk"

# :: Run
  USER root

  # :: update image
    RUN set -ex; \
      apk --no-cache add \
        curl \
        tzdata \
        shadow \
        alpine-sdk \
        doas; \
      apk --no-cache upgrade; \
      apk update;

  # :: change home
    RUN set -ex; \
      mkdir -p ${APP_ROOT}; \
      usermod -d ${APP_ROOT} docker; \
      chown -R 1000:1000 ${APP_ROOT};


  # :: setup groups
    RUN set -ex; \
      addgroup docker wheel; \
      addgroup docker abuild; \
      mkdir -p /var/cache/distfiles; \
      chmod a+w /var/cache/distfiles; \
      chgrp abuild /var/cache/distfiles; \
      chmod g+w /var/cache/distfiles;

  # :: config git
    RUN set -ex; \
      git config --global user.name "docker"; \
      git config --global user.email "docker@home.arpa";
  
  USER docker
    RUN set -ex; \
      abuild-keygen -a -n;

  USER root
    RUN set -ex; \
      find ${APP_ROOT}/.abuild -name '*.pub' -exec cp "{}" /etc/apk/keys \;  

  USER docker