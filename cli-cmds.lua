-------------------------------------------------------
--      nacl-cli
--      Written by Erik Poupaert, Cambodia
--      (c) 2018
--      Licensed under the LGPL
-------------------------------------------------------
local cmds={}

cmds.helptext=[[
Usage:

    nacl-cli genseckey

        generates a new secret key

    seckey=[seckey] nacl-cli calcpubkey    

        calculates the public key that goes with a secret key

    echo/cat plaintext | nacl-cli enc pubkey=[pubkey]

        encrypts plaintext and outputs crypttext encrypted to
        the public key of the recipient

    echo/cat crypttext | seckey=[seckey] nacl-cli dec

        decrypts crypttext and outputs plaintext using your secret key

    nacli-cli help

        outputs this helptext]]

-------------------------------------------------------
-- each function corresponds to a command supplied as
-- first argument on the commandline
-- adding a new function creates a new command
-------------------------------------------------------

cmds.help=function() 
    print(cmds.helptext)
end

cmds.genseckey=function() 
    print(armour.genseckey())
end


cmds.calcpubkey=function()
    local seckey_b58=cli.cmdArg('seckey')
    cli.required("seckey",seckey_b58)
    if not armour.isvalid_seckey(seckey_b58) then
        cli.error("bad seckey")
    end
    print(armour.calcpubkey(seckey_b58))
end


cmds.enc=function()
    local pubkey_b58=cli.cmdArg('pubkey')
    cli.required("pubkey",pubkey_b58)
    if not armour.isvalid_pubkey(pubkey_b58) then
        cli.error("bad pubkey")
    end
    local stdin = io.read("*all")
    local crypttext=armour.encrypt(pubkey_b58,stdin)
    print(crypttext)
end

cmds.dec=function()
    local seckey_b58=cli.cmdArg('seckey')
    cli.required("seckey",seckey_b58)
    if not armour.isvalid_seckey(seckey_b58) then
        cli.error("bad seckey")
    end
    local stdin = io.read("*all")
    local plaintext, errmsg = armour.decrypt(seckey_b58,stdin)
    if plaintext==nil then 
        cli.error(errmsg)
    else 
        io.write(plaintext)
    end
end

return cmds

