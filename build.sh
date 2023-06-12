#!/bin/sh

set -e

rm -f Dockerfile;
building=false;
if [ "$1" = "omz" ]; then
    cp ./Dockerfiles/omz.Dockerfile Dockerfile;
    building=true;
elif [ "$1" = "zi" ]; then
    cp ./Dockerfiles/zi.Dockerfile Dockerfile;
    building=true;
else
    echo "Usage: $0 zi|omz"
fi

if [ "$building" = "true" ]; then
    docker build -t shaes-home .
fi
