# nacl-cli

## Temporary draft notice

The program is code-complete now.

However, I am still busy finishing up documentation and going through the publication procedure.

## Synopsis

`nacl-cli` is a program that provides a text-based, serialization format for Daniel Bernstein's `tweetnacl` library by using the `philanc/luatweetnacl` bindings. I have called it "armour", similar to the option in PGP.

`nacl-cli` only handles encryption/decryption.

If you need signing and verification of signatures, you can use a tool like [minisign](https://github.com/jedisct1/minisign).

The program is a native, C-compiled executable, generated with `luastatic`, which embeds a (very) small lua interpreter.

Internally, the program is a mixture between native code and lua scripts. However, this is of no importance to the user, who just sees one, small, single native binary.

## Usage summary

`nacl-cli` supports the following commands:
* `genseckey`: generates a new secret key
* `calcpubkey`: calculates the public key that goes with a secret key
* `enc`: encrypts plaintext and outputs crypttext encrypted to the public key of the recipient
* `dec`: decrypts crypttext and outputs plaintext using your secret key
* `help`: lists each command with its arguments

```bash

$ ./nacl-cli help
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

        outputs this helptext
```


