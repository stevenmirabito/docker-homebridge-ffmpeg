###############################
# Build FFmpeg
FROM oznu/homebridge:latest as build

ARG FFMPEG_VERSION=ffmpeg-snapshot.tar.bz2

ARG PREFIX=/opt/ffmpeg
ARG PKG_CONFIG_PATH=/opt/ffmpeg/lib64/pkgconfig
ARG LD_LIBRARY_PATH=/opt/ffmpeg/lib
ARG MAKEFLAGS="-j4"

# FFmpeg build dependencies.
RUN apk add --update \
  build-base \
  cmake \
  freetype-dev \
  libtool \
  perl \
  pkgconf \
  pkgconfig \
  python3 \
  rtmpdump-dev \
  wget \
  x264-dev \
  yasm

# Install fdk-aac from testing.
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
  apk add --update fdk-aac-dev

# Get ffmpeg source.
RUN cd /tmp/ && \
  wget https://ffmpeg.org/releases/${FFMPEG_VERSION} && \
  tar xjvf ${FFMPEG_VERSION} && rm ${FFMPEG_VERSION}

# Compile ffmpeg.
RUN cd /tmp/ffmpeg && \
  ./configure \
  --enable-version3 \
  --enable-gpl \
  --enable-nonfree \
  --enable-small \
  --enable-libx264 \
  --enable-libfdk-aac \
  --enable-openssl \
  --disable-debug \
  --disable-doc \
  --disable-ffplay \
  --extra-cflags="-I${PREFIX}/include" \
  --extra-ldflags="-L${PREFIX}/lib" \
  --extra-libs="-lpthread -lm" \
  --prefix="${PREFIX}" && \
  make && make install && make distclean

# Cleanup.
RUN rm -rf /var/cache/apk/* /tmp/*

##########################
# Build release image
FROM oznu/homebridge:latest
LABEL MAINTAINER Steven Mirabito <steven@stevenmirabito.com>
ENV PATH=/opt/ffmpeg/bin:$PATH

RUN apk add --update \
  ca-certificates \
  openssl \
  pcre \
  rtmpdump \
  x264-dev

COPY --from=build /opt/ffmpeg /opt/ffmpeg
COPY --from=build /usr/lib/libfdk-aac.so.2 /usr/lib/libfdk-aac.so.2
