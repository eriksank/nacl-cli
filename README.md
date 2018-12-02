# nacl-cli

## Temporary draft notice

The program is code-complete now.

However, I am still busy finishing up documentation and going through the publication procedure.

## 1. Synopsis

`nacl-cli` is a program that provides a text-based, serialization format for encrypting/decrypting with Daniel Bernstein's `tweetnacl` library by using the `philanc/luatweetnacl` bindings. I have called it "armour", similar to the option in PGP.

`nacl-cli` only handles encryption/decryption.

If you need signing and verification of signatures, you can use a tool like [minisign](https://github.com/jedisct1/minisign).

The program is a native, C-compiled executable, generated with `luastatic`, which embeds a (very) small lua interpreter.

Internally, the program is a mixture between native code and lua scripts. However, this is of no importance to the user, who just sees one, small, single native binary.

## 2. Cryptographic note

The page [NaCl: Networking and Cryptography library](https://nacl.cr.yp.to/valid.html) clarifies the following:

"The following report specifies NaCl's default mechanism for public-key authenticated encryption, and along the way specifies NaCl's default mechanisms for scalar multiplication (Curve25519), secret-key authenticated encryption, secret-key encryption (Salsa20), and one-time authentication (Poly1305): 

Daniel J. Bernstein, "Cryptography in NaCl", 45pp."

Here a [link](https://cr.yp.to/highspeed/naclcrypto-20090310.pdf) to Daniel Bernstein's original publication.

## 3. Support for Microsoft Windows

It would undoubtedly be possible to generate a static executable for Windows.
However, Windows is not understood to be viable operating system for serious cryptography.
If you store or transmit sensitive information in that kind of context, encrypting it, looks irrelevant.

## 6. Installation

The redistributable contains the following files:

* `nacl-cli` : the actual program
* `install.sh`: this script will install `nacl-cli` in `/usr/local/bin`. Must be executed as root ("sudo ./install.sh")
* `uninstall.sh`: this script will remove `nacl-cli` from `/usr/local/bin`. Must be executed as root  ("sudo ./uninstall.sh")

After installation, the program should be on your standard execution path. You can check this from your terminal:

```
$ nacl-cli
Usage:
...
```

It is not mandatory to install the program in a standard location.

However, it is considered bad practice to execute programs that are not owned by root. 
Root ownership of the programs prevent other programs that you would run as ordinary user, from modifying them.
This is undoubtedly the number-one reason why linux systems, unlike Windows, generally do not suffer from virus plagues.


## 4. Similar programs

This is not the first attempt at replacing the venerable PGP program with a simpler command line tool that automatically defaults to modern elliptic-curve cryptography, with its much shorter keys. We are indeed trying to abandon ancient, semi-prime cryptography such as RSA.

* Salty: [carlos8f/salty](https://github.com/carlos8f/salty)
* pdp: [stef/pbp](https://github.com/stef/pbp)
 
What is the problem with these alternatives?

`Salty` forcibly harasses the user into installing `nodejs` and `npm`. Javascript is definitely a commendable scripting language, but why does the user have to deal with painstakingly installing javascript infrastructure? Furthermore, `nodejs` is a whopping 14 MB of code, just to produce a "hello world" example. Hence, `nodejs` is barely or even not suitable for distributing programs to the end user.

`pdp` suffers from the same problem. Why harass the user with installing the entire python programming language platform, possible in its two incompatible versions (2.7 and 3.5)? Does the user really have to know and consider that half of the python world refuses to upgrade to version 3.5? The user is not trying to join the fragmented python world. He just wants run a program.

Therefore, say no to program platformization.

The user does not need to know that I have programmed the tool in lua. He can just download the executable program and be done with it.


## 5. Usage summary

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


## 7. Detailed usage

Alice wants to send an encrypted message to Bob. How does it go?

## 7.1. Alice 


## 8. Reusing and embedding scripts in your own program

TO DO


