![Banner](https://github.com/11notes/defaults/blob/main/static/img/banner.png?raw=true)

# 🏔️ Alpine - APK build
![size](https://img.shields.io/docker/image-size/11notes/apk-build/latest?color=0eb305) ![version](https://img.shields.io/docker/v/11notes/apk-build/latest?color=eb7a09) ![pulls](https://img.shields.io/docker/pulls/11notes/apk-build?color=2b75d6) ![activity](https://img.shields.io/github/commit-activity/m/11notes/docker-apk-build?color=c91cb8) ![commit-last](https://img.shields.io/github/last-commit/11notes/docker-apk-build?color=c91cb8) ![stars](https://img.shields.io/docker/stars/11notes/apk-build?color=e6a50e)

**Build custom APK's with Docker**

# SYNOPSIS
What can I do with this? Well simply put, you can build your own APK for Alpine within Docker in a build layer. This gives you the ability to use your custom APK with the normal installer.

# EXAMPLES
## amd64.dockerfile
```shell
# :: Build
  FROM 11notes/apk-build:stable as build
  ENV APK_NAME="custom"

  RUN set -ex; \
    cd ~; \
    newapkbuild ${APK_NAME};

  COPY ./build /apk/${APK_NAME}

  RUN set -ex; \
    cd ~/${APK_NAME}; \
    abuild checksum; \
    abuild -r;

# :: Header
  FROM 11notes/alpine:stable
  COPY --from=build /apk/packages/apk /apk/custom <sup>1</sup>
  RUN set -ex; \
    apk add --no-cache --allow-untrusted --repository /apk/custom \
      custom; \
```

# DEFAULT SETTINGS
| Parameter | Value | Description |
| --- | --- | --- |
| `user` | docker | user docker |
| `uid` | 1000 | user id 1000 |
| `gid` | 1000 | group id 1000 |
| `home` | /apk | home directory of user docker |

# ENVIRONMENT
| Parameter | Value | Default |
| --- | --- | --- |
| `TZ` | [Time Zone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) | |
| `DEBUG` | Show debug information | |

# PARENT IMAGE
* [11notes/alpine:stable](https://hub.docker.com/r/11notes/alpine)

# BUILT WITH
* [alpine](https://alpinelinux.org)

# TIPS
* Only use rootless container runtime (podman, rootless docker)
* Allow non-root ports < 1024 via `echo "net.ipv4.ip_unprivileged_port_start=53" > /etc/sysctl.d/ports.conf`
* Use a reverse proxy like Traefik, Nginx to terminate TLS with a valid certificate
* Use Let’s Encrypt certificates to protect your SSL endpoints

# DISCLAIMERS
* <sup>1</sup> Only use this image as a build layer in your project!

# ElevenNotes<sup>™️</sup>
This image is provided to you at your own risk. Always make backups before updating an image to a new version. Check the changelog for breaking changes.
    