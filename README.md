# Alpine - APK build
![size](https://img.shields.io/docker/image-size/11notes/apk-build/3.18?color=0eb305) ![version](https://img.shields.io/docker/v/11notes/apk-build?color=eb7a09) ![pulls](https://img.shields.io/docker/pulls/11notes/apk-build?color=2b75d6) ![activity](https://img.shields.io/github/commit-activity/m/11notes/docker-apk-build?color=c91cb8) ![commit-last](https://img.shields.io/github/last-commit/11notes/docker-apk-build?color=c91cb8)

Run Alpine build tools as build layer. Small, lightweight, secure and fast 🏔️

## amd64.dockerfile
```shell
# :: Build
  FROM 11notes/apk-build:stable as build
  ENV APK_NAME="bind"

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
  COPY --from=build /apk/packages/apk /tmp
```

## Defaults
| Parameter | Value | Description |
| --- | --- | --- |
| `user` | docker | user docker |
| `uid` | 1000 | user id 1000 |
| `gid` | 1000 | group id 1000 |
| `home` | /home/docker | home directory of user docker |

## Parent
* [alpine](https://hub.docker.com/_/alpine)

## Built with and thanks to
* [Alpine Linux](https://alpinelinux.org)

## Tips
* Only use this image as a build layer in your setup to build custom apk for your images