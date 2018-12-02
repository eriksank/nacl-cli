#!/usr/bin/env bash
#-------------------------------------------------------
#      nacl-cli
#      Written by Erik Poupaert, Cambodia
#      (c) 2018
#      Licensed under the LGPL
#-------------------------------------------------------
function check_errcode {
    echo -n "$1 ... "
    if [ "$2" -eq 0 ] ; then
        echo "SUCCESS"
    else
        echo "FAIL"
        exit 1
    fi
}

#PROGRAM="lua nacl-cli.lua"
PROGRAM="./nacl-cli"

echo "[generating secret] ..."
seckey=$($PROGRAM genseckey)
echo "seckey=$seckey"

echo "[calculating public key] ..."
pubkey=$(seckey=$seckey $PROGRAM calcpubkey)
check_errcode "calcpubkey" $?
echo "pubkey=$pubkey"

echo "[encrypting message] ..."
crypttext=$(echo "this is a test message" | $PROGRAM enc pubkey=$pubkey)
check_errcode "encrypt" $?
echo "[crypttext]"
echo "$crypttext"


echo "[decrypting message] ..."
plaintext=$(echo "$crypttext" | seckey=$seckey $PROGRAM dec)
check_errcode "decrypt" $?
echo "[plaintext]"
echo "$plaintext"
 
