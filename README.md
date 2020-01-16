# Docker Homebridge FFmpeg

[oznu/docker-homebridge](https://github.com/oznu/docker-homebridge) + FFmpeg


This image builds a minimal version of FFmpeg with only the necessary codecs for camera streaming with [homebridge-dafang](https://github.com/sahilchaddha/homebridge-dafang):

```
configuration: --enable-version3 --enable-gpl --enable-nonfree --enable-small --enable-libx264 --enable-libfdk-aac --enable-openssl --disable-debug --disable-doc --disable-ffplay --extra-cflags=-I/opt/ffmpeg/include --extra-ldflags=-L/opt/ffmpeg/lib --extra-libs='-lpthread -lm' --prefix=/opt/ffmpeg
```

## Motivation

At the time of writing, the version of FFmpeg that Alpine distributes did not include `libfdk-aac` which is required for proper audio encoding with [homebridge-dafang](https://github.com/sahilchaddha/homebridge-dafang).

## Contributing

Feel free to make a pull request if you have a use case that requires additional FFmpeg codecs.
