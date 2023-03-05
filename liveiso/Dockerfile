FROM debian:stable

RUN apt-get update
RUN apt-get full-upgrade -y
RUN apt-get install --no-install-recommends -y live-build

RUN mkdir /image
WORKDIR /image
RUN lb config \
  --archive-areas "main contrib non-free non-free-firmware" \
  --firmware-chroot false \
  --image-name debian-gsd \
  --distribution sid \
  --apt-recommends false

COPY build.sh /image
COPY packages.list.chroot /image/config/package-lists

RUN mkdir -p /image/config/includes.chroot/usr/local/bin
COPY gsd-get.sh /image/config/includes.chroot/usr/local/bin/gsd-get

CMD ["/image/build.sh"]
