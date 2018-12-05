#!/usr/bin/env bash
#-------------------------------------------------------
#      admin
#      Written by Erik Poupaert, Cambodia
#      (c) 2018
#      Licensed under the LGPL
#-------------------------------------------------------
if [ "$1"="" ] ; then
    msg=commit-$(date)
fi
git add .
git commit -m "$msg"
git push -u origin master

