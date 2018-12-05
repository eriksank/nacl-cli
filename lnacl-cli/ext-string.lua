-------------------------------------------------------
--      nacl-cli
--      Written by Erik Poupaert, Cambodia
--      (c) 2018
--      Licensed under the LGPL
-------------------------------------------------------

-- The origin of this function is a comment on stackoverflow
-- It was contributed by its author to the public domain
 
function string:split(delimiter)
  local result = {}
  local from  = 1
  local delim_from, delim_to = string.find( self, delimiter, from  )
  while delim_from do
    table.insert( result, string.sub( self, from , delim_from-1 ) )
    from  = delim_to + 1
    delim_from, delim_to = string.find( self, delimiter, from  )
  end
  table.insert( result, string.sub( self, from  ) )
  return result
end

-- The origin of this function is a comment on stackoverflow
-- It was contributed by its author to the public domain

function string:trim()
   return self:match( "^%s*(.-)%s*$" )
end

