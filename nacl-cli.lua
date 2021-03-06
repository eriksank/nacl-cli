#!/usr/bin/env lua
-------------------------------------------------------
--      nacl-cli
--      Written by Erik Poupaert, Cambodia
--      (c) 2018
--      Licensed under the LGPL
-------------------------------------------------------
armour=require("lnacl-cli.armour")
util=require("lnacl-cli.util")
cli=require("lnacl-cli.cli")
--
local cmds=require("lnacl-cli.cli-cmds")
-------------------------------------------------------
-- program entry script
-------------------------------------------------------

-- store arguments of the type key=value
-- en provenance from the global variable "arg"
-- inside the global variable "_params"

_params=cli.splitArgs(arg)

-- command is mandatory
if #arg==0 then 
    io.stderr:write(cmds.helptext.."\n\n")
    cli.error("missing command")
end

-- invoke the function associated with the command
local cmd=arg[1];
if not cmds[cmd] then cli.error("unknown command") end
cmds[cmd]()

