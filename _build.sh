#!/usr/bin/env bash
#-------------------------------------------------------
#      nacl-cli
#      Written by Erik Poupaert, Cambodia
#      (c) 2018
#      Licensed under the LGPL
#-------------------------------------------------------
#rm -rf ./.luapak
rm ./nacl-cli
luapak make nacl-cli-0.5-1.rockspec \
    --lua-lib=/usr/lib/x86_64-linux-gnu/liblua5.1.a \
    --entry-script=nacl-cli.lua
#rm -rf ./.luapak

