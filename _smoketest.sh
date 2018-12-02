#!/usr/bin/env bash
#-------------------------------------------------------
#      nacl-cli
#      Written by Erik Poupaert, Cambodia
#      (c) 2018
#      Licensed under the LGPL
#-------------------------------------------------------
function check_errcode {
    echo -n "$1 ... "
    if [ $2=0 ] ; then
        echo "SUCCESS"
    else
        echo "FAIL"
    fi
}

echo "[generating secret] ..."
seckey=$(./nacl-cli genseckey)
echo "seckey=$seckey"

echo "[calculating public key] ..."
pubkey=$(seckey=$seckey ./nacl-cli calcpubkey)
check_errcode "calcpubkey" $?
echo "pubkey=$pubkey"

echo "[encrypting message] ..."
crypttext=$(echo "this is a test message" | ./nacl-cli enc pubkey=$pubkey)
check_errcode "encrypt" $?
echo "[crypttext]"
echo "$crypttext"


echo "[decrypting message] ..."
plaintext=$(echo "$crypttext" | seckey=$seckey ./nacl-cli dec)
check_errcode "decrypt" $?
echo "[plaintext]"
echo "$plaintext"
 
