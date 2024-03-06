# :: QEMU
  FROM multiarch/qemu-user-static:x86_64-aarch64 as qemu

# :: Header
  FROM 11notes/alpine:arm64v8-stable
  COPY --from=qemu /usr/bin/qemu-aarch64-static /usr/bin
  ENV APP_ROOT=/apk-build

# :: Run
  USER root

  # :: update image
    RUN set -ex; \
      apk --no-cache add \
        curl \
        tzdata \
        shadow \
        alpine-sdk \
        git \
        doas; \
      apk --no-cache upgrade; \
      apk update;

  # :: change home
    RUN set -ex; \
      mkdir -p ${APP_ROOT}; \
      mkdir -p /apk; \
      mkdir -p /src; \
      usermod -d ${APP_ROOT} docker; \
      chown -R 1000:1000 \
        /apk \
        /src \
        ${APP_ROOT};

    COPY ./rootfs /
    RUN set -ex; \
      chmod +x -R /usr/local/bin

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