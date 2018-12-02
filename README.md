# nacl-cli

## Temporary draft notice

The program is code-complete now.

However, I am still busy finishing up documentation and going through the publication procedure.

## Synopsis

`nacl-cli` is a program that provides a text-based, serialization format for encrypting/decrypting with Daniel Bernstein's `tweetnacl` library by using the `philanc/luatweetnacl` bindings. I have called it "armour", similar to the option in PGP.

`nacl-cli` only handles encryption/decryption.

If you need signing and verification of signatures, you can use a tool like [minisign](https://github.com/jedisct1/minisign).

The program is a native, C-compiled executable, generated with `luastatic`, which embeds a (very) small lua interpreter.

Internally, the program is a mixture between native code and lua scripts. However, this is of no importance to the user, who just sees one, small, single native binary.

## Cryptography note

The page [NaCl: Networking and Cryptography library](https://nacl.cr.yp.to/valid.html) clarifies the following:

"The following report specifies NaCl's default mechanism for public-key authenticated encryption, and along the way specifies NaCl's default mechanisms for scalar multiplication (Curve25519), secret-key authenticated encryption, secret-key encryption (Salsa20), and one-time authentication (Poly1305): 

Daniel J. Bernstein, "Cryptography in NaCl", 45pp."

Here a [link](https://cr.yp.to/highspeed/naclcrypto-20090310.pdf) to Daniel Bernstein's original publication.


## Similar programs

This is not the first attempt at replacing the venerable PGP program with a simpler command line tool that automatically defaults to modern elliptic-curve cryptography, with its much shorter keys. We are indeed trying to abandon ancient, semi-prime cryptography such as RSA.

* Salty: [carlos8f/salty](https://github.com/carlos8f/salty)
* pdp: [stef/pbp](https://github.com/stef/pbp)
 
What is the problem with these alternatives?

`Salty` forcibly harasses the user into installing `nodejs` and `npm`. Javascript is definitely a commendable scripting language, but why does the user have to deal with painstakingly installing javascript infrastructure? Furthermore, `nodejs` is a whopping 14 MB of code, just to produce a "hello world" example. Hence, `nodejs` is barely or even not suitable for distributing programs to the end user.

`pdp` suffers from the same problem. Why harass the user with installing the entire python programming language platform, possible in its two incompatible versions (2.7 and 3.5)? Does the user really have to know and consider that half of the python world refuses to upgrade to version 3.5? The user is not trying to join the fragmented python world. He just wants a program.

Therefore, say no to program platformization.

The user does not need to know that I have programmed the tool in lua. He can just download the executable and be done with it.


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


