#!/usr/bin/env bash
#-------------------------------------------------------
#      admin
#      Written by Erik Poupaert, Cambodia
#      (c) 2018
#      Licensed under the LGPL
#-------------------------------------------------------
cmd=$1

if [ -z "$cmd" ] ; then
    >&2 echo "Error: command mandatory"
    exit 1
fi

cmdfile=admin/_$cmd.sh

if [ ! -e "$cmdfile" ] ; then
    >&2 echo "Error: command file '$cmdfile' does not exist"
    exit 1
fi

shift
$cmdfile "$@"

