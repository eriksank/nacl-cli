-------------------------------------------------------
--      nacl-cli
--      Written by Erik Poupaert, Cambodia
--      (c) 2018
--      Licensed under the LGPL
-------------------------------------------------------
local util={}

-- lifted from stack exchange somewhere
util.tail=function(table)
    if not table then return nil end
    local function helper(head, ...) 
        return #{...} > 0 and {...} or nil 
    end
    return helper((table.unpack or unpack)(table))
end

-- lifted from stack exchange somewhere
util.count=function(table)
    local n = 0
    for k,v in pairs(table) do
        n=n+1
    end
    return n
end

return util


