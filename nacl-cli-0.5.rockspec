package = "nacl-cli"
version = "0.5"
source = {
   url = "*** please add URL for source tarball, zip or repository here ***"
}
description = {
   summary = "A serialization format ('armour') for nacl encryption",
   homepage = "*** please enter a project homepage ***",
   license = "LGPL",
   maintainer="Erik Poupaert <erik@sankuru.biz>"
}
dependencies = {
    'lua >= 5.1',
    'tweetnacl',
    'base58',
    'lbase64', 
    'sha2',
    'inspect',
    'f-strings',
    'luastatic'
}
build = {
   type = "builtin",
   modules = {
      armour = "armour.lua",
      cli = "cli.lua",
      ["cli-cmds"] = "cli-cmds.lua",
      ["ext-string"] = "ext-string.lua",
      ["nacl-cli"] = "nacl-cli.lua",
      smoketest = "smoketest.lua",
      util = "util.lua"
   },
  install = {
    bin = {
      ["nacl-cli"] = "nacl-cli.lua",
    }
  }
}

