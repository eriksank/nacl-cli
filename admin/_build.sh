#!/usr/bin/env bash
#-------------------------------------------------------
#      admin
#      Written by Erik Poupaert, Cambodia
#      (c) 2018
#      Licensed under the LGPL
#-------------------------------------------------------
PROGRAM=$(cat PROGRAM)
VERSION=$(cat VERSION)
cat $PROGRAM.rockspec.template | \
    sed "s/=VERSION=/$VERSION/g" > $PROGRAM-$VERSION.rockspec
luapak make $PROGRAM-$VERSION.rockspec \
    --lua-lib=/usr/lib/x86_64-linux-gnu/liblua5.1.a \
    --entry-script=$PROGRAM.lua

