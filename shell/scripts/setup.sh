#!/usr/bin/env bash

BASEDIR=$(dirname "$0")

DEFAULT=$BASEDIR/../zsh/shae-ubuntu-zsh


if [ -z "$1-zshrc" ]
then
    echo "No argument supplied, using default: $DEFAULT"
    ZSHRC="${DEFAULT}rc"
    ZSHENV="${DEFAULT}env"
else
    ZSHRC="$1-zshrc"
    ZSHENV="$1-zshenv"
fi


if [ -f "$ZSHRC" ]
then
    echo "Sourcing $ZSHRC"
    source "$ZSHRC"
    cp "$ZSHRC" ~/.zshrc
    cp "$ZSHENV" ~/.zshenv
else
    echo "No zshrc found at $ZSHRC"
fi

mkdir ~/.config/
echo "$BASEDIR"
cp -r "$BASEDIR/apps/micro" ~/.config/