# syntax=docker/dockerfile:1.3-labs

FROM alpine:latest AS compilation

ARG BUILD_CLIENT="0"
ARG BUILD_SERVER="1"

ARG USE_CURL="1"
ARG USE_CODEC_OPUS="1"
ARG USE_VOIP="1"

ARG MAKE_OPTS="-j2"

RUN apk --no-cache --update add curl g++ gcc make git sdl2-dev unzip zip

# Get the point release from ID Software (holds the pk3 files)
RUN wget https://www.lvlworld.com/misc-files/Point-Release-1.32-Linux.zip

# Get OSP Tourney Q3A mod without maps
RUN wget http://osp.dget.cc/orangesmoothie/downloads/osp-Quake3-1.03a-without_maps.zip

# Get ioquake3 source code
RUN git clone https://github.com/ioquake/ioq3.git /ioq3

# Compile ioquake3
RUN <<EOF
BUILD_DIR="$(mktemp -d)"
cd /ioq3
make $MAKE_OPTS
cd /ioq3/build
mv release-* release
cd /ioq3/build/release
mv ioq3ded* ioq3ded
EOF

# Install point release
RUN <<EOF
unzip Point-Release-1.32-Linux.zip
sh linuxq3apoint-1.32b-3.x86.run --nox11 --target /ioq3/build/release
EOF

# Install bare OSP Tourney Q3A mod (only VM)
RUN <<EOF
unzip osp-Quake3-1.03a-without_maps.zip
mkdir -p /ioq3/build/release/osp
mv osp/vm /ioq3/build/release/osp/vm
EOF

# ------------------------------------------------------------------------------

FROM alpine:latest AS ioquake3

# Add non-root user
RUN adduser --system ioq3

USER ioq3

COPY --chown=ioq3 --from=compilation /ioq3/build/release /opt/ioq3

ENTRYPOINT ["/opt/ioq3/ioq3ded"]

CMD ["+dedicated", "1", "+map", "q3dm1"]
