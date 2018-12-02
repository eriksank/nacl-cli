#!/usr/bin/env lua
-------------------------------------------------------
--      nacl-cli
--      Written by Erik Poupaert, Cambodia
--      (c) 2018
--      Licensed under the LGPL
-------------------------------------------------------
local cmds=require("cli-cmds")
local cli=require("cli")

if #arg==0 then 
    io.stderr:write(cmds.helptext.."\n\n")
    cli.error("missing command")
end
local cmd=arg[1];
if not cmds[cmd] then cli.error("unknown command") end
cmds[cmd]()

