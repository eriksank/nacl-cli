-------------------------------------------------------
--      nacl-cli
--      Written by Erik Poupaert, Cambodia
--      (c) 2018
--      Licensed under the LGPL
-------------------------------------------------------
local F=require("F")
local util=require("util")

local cli={}

cli.error=function (msg)
    io.stderr:write(F"Error:{msg}\n")
    os.exit(1)
end

cli.required=function(argName,argValue)
    if not argValue then
        cli.error(F"{argName} required")
    end
end

cli.splitArgs=function(table)
    if not table then return nil end
    local params={}
    for _,value in pairs(table) do
        local row=string.split(value,"=")
        if #row == 2 then
            params[row[1]]=row[2]
        end
    end
    return params
end

cli.cmdArg=function(argName)
    local argValue=os.getenv(argName)
    if argValue then return argValue end
    local args=cli.splitArgs(util.tail(arg))
    if not args then return nil end
    return args[argName]
end

return cli

