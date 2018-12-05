#!/usr/bin/env lua
-------------------------------------------------------
--      nacl-cli
--      Written by Erik Poupaert, Cambodia
--      (c) 2018
--      Licensed under the LGPL
-------------------------------------------------------
local verify=function(val1,val2)
    if val1==val2 then
        print("CHECK: ok")
    else
        print("CHECK: error")
    end
end

local title=function(header)
    print ("-------------------")
    print (header)
    print ("-------------------")
end

armour=require("lnacl-cli.armour")
base58=require("base58")

title("checking key generation")
local pubkey_b58,seckey_b58=armour.box_keypair()
pubkey_b58=armour.format_headerfield(pubkey_b58,"pub")
seckey_b58=armour.format_headerfield(seckey_b58,"sec")
local pubkey2_b58=armour.calcpubkey(seckey_b58)
print("calculation pubkey")
verify(pubkey_b58,pubkey2_b58)

title("checking encryption/decryption")
local plaintext1="hello, this is just a test"
local crypttext,debug_context1=armour.encrypt(pubkey_b58,plaintext1)
local eph_pubkey1=debug_context1.eph_pubkey
local eph_seckey1=debug_context1.eph_seckey
local nonce1=debug_context1.nonce
print(crypttext)
local plaintext2,errMsg,debug_context2=armour.decrypt(seckey_b58,crypttext)
if(plaintext2==nil) then
    print(string.format("ERROR: decryption failed: %s",errMsg))
end
local eph_pubkey2=debug_context2.eph_pubkey
local nonce2=debug_context2.nonce
print("transmission eph_pubkey")
verify(eph_pubkey1,eph_pubkey2)
print("transmission nonce")
verify(nonce1,nonce2)
print("decryption")
verify(plaintext1,plaintext2)

