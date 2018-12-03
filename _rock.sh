#!/usr/bin/env bash
#-------------------------------------------------------
#      nacl-cli
#      Written by Erik Poupaert, Cambodia
#      (c) 2018
#      Licensed under the LGPL
#-------------------------------------------------------
API_KEY=$(cat API-KEY)
VERSION=$(cat VERSION)
luarocks upload --api-key=$API_KEY --force nacl-cli-$VERSION.rockspec

