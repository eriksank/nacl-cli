#!/usr/bin/env bash
#-------------------------------------------------------
#      nacl-cli
#      Written by Erik Poupaert, Cambodia
#      (c) 2018
#      Licensed under the LGPL
#-------------------------------------------------------
VERSION=$(cat VERSION)
cat nacl-cli.rockspec.template | \
    sed "s/=VERSION=/$VERSION/g" > nacl-cli-$VERSION.rockspec
luapak make nacl-cli-$VERSION.rockspec \
    --lua-lib=/usr/lib/x86_64-linux-gnu/liblua5.1.a \
    --entry-script=nacl-cli.lua

