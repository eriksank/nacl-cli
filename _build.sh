#!/usr/bin/env bash
#-------------------------------------------------------
#      nacl-cli
#      Written by Erik Poupaert, Cambodia
#      (c) 2018
#      Licensed under the LGPL
#-------------------------------------------------------
luastatic nacl-cli.lua armour.lua cli.lua cli-cmds.lua ext-string.lua util.lua \
    /usr/lib/x86_64-linux-gnu/liblua5.1.a -I/usr/include/lua5.1
rm nacl-cli.lua.c

