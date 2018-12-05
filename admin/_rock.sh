#!/usr/bin/env bash
#-------------------------------------------------------
#      admin
#      Written by Erik Poupaert, Cambodia
#      (c) 2018
#      Licensed under the LGPL
#-------------------------------------------------------
PROGRAM=$(cat PROGRAM)
VERSION=$(cat VERSION)
API_KEY=$(cat API-KEY)
luarocks upload --api-key=$API_KEY --force $PROGRAM-$VERSION.rockspec

