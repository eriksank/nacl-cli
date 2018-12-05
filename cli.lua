-------------------------------------------------------
--      nacl-cli
--      Written by Erik Poupaert, Cambodia
--      (c) 2018
--      Licensed under the LGPL
-------------------------------------------------------

-------------------------------------------------------
-- This module implements a few generic command line
-- argument processing functions
-------------------------------------------------------
local cli={}


-- terminate the program with an error message

cli.error=function (msg)
    io.stderr:write(string.format("Error: %s\n",msg))
    os.exit(1)
end

-- terminate the program with an error message
-- when an argument is missing

cli.required=function(argName,argValue)
    if not argValue then
        cli.error(string.format("%s required",argName))
    end
end

-- stores cli arguments of the type key=value found
-- in the global table "arg" in the table returned

cli.splitArgs=function(table)
    if not table then return {} end
    local params={}
    for _,value in pairs(table) do
        local row=string.split(value,"=")
        if #row == 2 then
            params[row[1]]=row[2]
        end
    end
    return params
end

-- first tries to find a cli argument in the environment
-- if not, it looks in the global _params variable

cli.cmdArg=function(argName)
    local argValue=os.getenv(argName)
    if argValue then return argValue end
    return _params[argName]
end

return cli

