#!/bin/sh

set -e

DEFAULT=blog-template
NAME=""
TYPE=blog
building=false;
BASE_URL="https://github.com/twitter-econ-pol"

if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <type> <name>"
    echo "Where <type> is one of blog, viz and <name> is your project username"
    exit 1
elif [ "$#" -ge 1 ]; then
    TYPE="$1"
    if [ "$#" -ge 2 ]; then
        NAME="$2"
    fi
    building=true;
fi

if [ "$building" = true ]; then
    if [ "$TYPE" = "blog" ]; then
        if [ "$NAME" != "" ]; then
            URL="$BASE_URL/blog-$NAME";
        else
            URL="$BASE_URL/blog-template";
        fi
        git clone $URL blog-template
        cd blog-template
        pnpm i
    else
        echo "Type $TYPE not yet supported"
        exit 1
        
else
    echo "Usage: $0 <type> <name>"
    echo "Where <type> is one of blog, viz and <name> is your project username"
    exit 1
fi