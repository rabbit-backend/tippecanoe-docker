FROM alpine:3.14 AS tippecanoe-builder

RUN apk add --no-cache \
    build-base \
    sqlite-dev \
    zlib-dev \
    git \
    bash

WORKDIR /tmp/tippecanoe-src

RUN git clone https://github.com/felt/tippecanoe.git .

RUN make

FROM alpine:3.14

RUN apk update && apk add \
    sqlite-libs \
    zlib \
    gcc \
    g++

COPY --from=tippecanoe-builder /tmp/tippecanoe-src/tippecanoe* /usr/local/bin/
COPY --from=tippecanoe-builder /tmp/tippecanoe-src/tile-join /usr/local/bin/

WORKDIR /app

ENTRYPOINT [ "tippecanoe" ]