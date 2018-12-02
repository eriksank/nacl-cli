#nacl-cli

##temporary draft notice

The program is code-complete now.

However, I am still busy finishing up documentation and going through the publication procedure.

##Synopsis

`nacl-cli` is a program that provides a text-based, serialization format for Daniel Bernstein's `tweetnacl` library by using the `philanc/luatweetnacl` bindings. I called it "armour", similar to the option in PGP.

The program is a native, C-compiled executable, generated with `luastatic`, which embeds a (very) small lua interpreter.

Internally, the program is a mixture between native code and lua scripts. However, this is of no importance to the user, who just sees one, small, single native binary.


