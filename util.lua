-------------------------------------------------------
--      nacl-cli
--      Written by Erik Poupaert, Cambodia
--      (c) 2018
--      Licensed under the LGPL
-------------------------------------------------------
local util={}

-- lifted from stack exchange somewhere
util.count=function(table)
    local n = 0
    for k,v in pairs(table) do
        n=n+1
    end
    return n
end

return util


