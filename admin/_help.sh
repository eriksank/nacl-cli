#!/usr/bin/env bash
#-------------------------------------------------------
#      nacl-cli
#      Written by Erik Poupaert, Cambodia
#      (c) 2018
#      Licensed under the LGPL
#-------------------------------------------------------
cat <<EOF
Usage
    ./admin.sh [cmd]

    == develop ==

        push                    update github
        build                   produce nacl-cli executable
                                   update rockspec file

    == publish ==

        release                 produce binary tar.gz file
        tag + upload binary tar.gz to github (do this manually)    
        rock                    send rock to luarocks repo
EOF

