-------------------------------------------------------
--      nacl-cli
--      Written by Erik Poupaert, Cambodia
--      (c) 2018
--      Licensed under the LGPL
-------------------------------------------------------
require("lnacl-cli/ext-string")
local util=require("lnacl-cli/util")
local nacl = require("luatweetnacl")
local base58 = require("base58")
local base64 = require("base64")
local sha2 = require("sha2")

local armour = {}

function armour.box_keypair()
    local pubkey, seckey = nacl.box_keypair() 
    local pubkey_b58=base58.encode_base58(pubkey)
    local seckey_b58=base58.encode_base58(seckey)
    return pubkey_b58,seckey_b58
end

function armour.calcpubkey(seckey_b58)
    local key_parts=armour.key_parts(seckey_b58)
    local seckey=base58.decode_base58(key_parts['key'])
    if seckey == nil then return nil end
    local pubkey=nacl.box_getpk(seckey)
    return armour.format_headerfield(base58.encode_base58(pubkey),'pub')
end

function armour.sha256_checkstring(str)
    local hash=sha2.sha256(str)
    local hash_b58=base58.encode_base58(hash)
    local check=string.sub(hash_b58,-3)
    return check
end

function armour.genseckey()
    local box_pubkey_b58, box_seckey_b58 = armour.box_keypair() 
    local check_b58=armour.sha256_checkstring(box_seckey_b58)
    local seckey_b58=string.format("nacl.cryp.sec.%s.%s",box_seckey_b58,check_b58)
    return seckey_b58
end

function armour.key_parts(key_b58)
    local parts=key_b58:split("%.")
    if #parts ~= 5 then return {} end
    key_parts={}
    key_parts['prefix'] = parts[1]
    key_parts['optype'] = parts[2]
    key_parts['keytype'] = parts[3]
    key_parts['key'] = parts[4]
    key_parts['check'] = parts[5]
    return key_parts
end

function armour.isvalid_key(key_b58,expected_keytype,expected_byte_len)
    local key_parts=armour.key_parts(key_b58)
    local count=util.count(key_parts)
    if count == 0 then return false end
    if key_parts['prefix'] ~= 'nacl' then return false end
    if key_parts['optype'] ~= 'cryp' then return false end
    if key_parts['keytype'] ~= expected_keytype then return false end
    local check_again_b58=armour.sha256_checkstring(key_parts['key'])
    if key_parts['check'] ~= check_again_b58 then return false end
    local box_key=base58.decode_base58(key_parts['key'])
    if not box_key then return false end
    if string.len(box_key)~=expected_byte_len then return false end
    return true
end

function armour.isvalid_seckey(seckey_b58)
    return armour.isvalid_key(seckey_b58,'sec',32)
end

function armour.isvalid_pubkey(pubkey_b58)
    return armour.isvalid_key(pubkey_b58,'pub',32)
end

function armour.isvalid_nonce(nonce_b58)
    return armour.isvalid_key(nonce_b58,'nonce',24)
end

function armour.format_headerfield(key_b58,keytype)
    local check_b58=armour.sha256_checkstring(key_b58)
    local formatted=string.format("nacl.cryp.%s.%s.%s",keytype,key_b58,check_b58)
    return formatted
end

function armour.format_crypttext(eph_pubkey_b58,nonce_b58,crypttext_b64)
    local template=
[[--nacl-crypt--begin--
eph-pub:%s
nonce:%s
.
%s
--nacl-crypt--end--]]
    local formatted=string.format(template,eph_pubkey_b58,nonce_b58,crypttext_b64)
    return formatted
end

function armour.getbinkey(key_b58)
    local key_parts=armour.key_parts(key_b58)
    return base58.decode_base58(key_parts['key'])
end

function armour.encrypt(pubkey_b58,plaintext)
    local pubkey=armour.getbinkey(pubkey_b58)
    local eph_pubkey,eph_seckey = nacl.box_keypair()
    local nonce=nacl.randombytes(24)
    local crypttext=nacl.box(plaintext,nonce,pubkey,eph_seckey)
    local eph_pubkey_b58=armour.format_headerfield(base58.encode_base58(eph_pubkey),'pub')
    local crypttext_b64=base64.encode(crypttext)
    crypttext_b64=string.gsub(crypttext_b64,string.rep('.',68),'%1\n')
    local nonce_b58=armour.format_headerfield(base58.encode_base58(nonce),'nonce')
    local debug_context={eph_pubkey=eph_pubkey,eph_seckey=eph_seckey,nonce=nonce} 
    return armour.format_crypttext(eph_pubkey_b58,nonce_b58,crypttext_b64),debug_context
end


function armour.decrypt(seckey_b58,crypttext)

    if not armour.isvalid_seckey(seckey_b58) then
        return nil, string.format("invalid seckey: %s",seckey_b58)
    end

    local pattern=[[%-%-nacl%-crypt%-%-begin%-%-
eph%-pub:(.*)
nonce:(.*)
%.
(.*)
%-%-nacl%-crypt%-%-end%-%-]]

    local eph_pub_b58,nonce_b58,cryptmessage_b64=crypttext:match(pattern)
    if eph_pub_b58==nil then return nil,string.format("cannot parse eph_pubkey: %s",eph_pub_b58) end
    if nonce_b58==nil then return nil,string.format("cannot parse nonce: %s",nonce_b58) end
    local eph_pubkey=armour.getbinkey(eph_pub_b58)
    local nonce=armour.getbinkey(nonce_b58)
    local debug_context={eph_pubkey=eph_pubkey,nonce=nonce}
    if cryptmessage_b64==nil then return nil,"cannot parse cryptmessage",debug_context end
    if not armour.isvalid_pubkey(eph_pub_b58) then return nil,string.format("invalid eph_pubkey: %s",eph_pub_b58),debug_context end
    if not armour.isvalid_nonce(nonce_b58) then return nil,string.format("invalid nonce: %s",nonce_b58),debug_context end
    local seckey=armour.getbinkey(seckey_b58)
    local cryptmessage=base64.decode(cryptmessage_b64:gsub("\n", ""))
    if cryptmessage==nil then return nil,"invalid base64 cryptmessage",debug_context end
    local plaintext, errmsg = nacl.box_open(cryptmessage, nonce, eph_pubkey, seckey)
    if plaintext==nil then return nil, string.format("cannot decrypt cryptmessage: %s",errmsg),debug_context end
    return plaintext,"OK",debug_context
end

return armour

