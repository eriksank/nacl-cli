#!/usr/bin/env bash
#-------------------------------------------------------
#      nacl-cli
#      Written by Erik Poupaert, Cambodia
#      (c) 2018
#      Licensed under the LGPL
#-------------------------------------------------------
if ~ [ -e ./nacl-cli ] ; then
    >&2 echo "Cannot find nacl-cli executable."
    exit 1
fi
cp -f ./nacl-cli /usr/local/bin
echo "nacl-cli installed in /usr/local/bin"

