#!/usr/bin/env bash
#-------------------------------------------------------
#      admin
#      Written by Erik Poupaert, Cambodia
#      (c) 2018
#      Licensed under the LGPL
#-------------------------------------------------------
PROGRAM=$(cat PROGRAM)
VERSION=$(cat VERSION)
rm -f $PROGRAM
rm -f *.src.rock
rm -f *.tar.gz
rm -f *.rockspec

