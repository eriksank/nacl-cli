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

## 4. Installation

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


## 5. Similar programs

This is not the first attempt at replacing the venerable PGP program with a simpler command line tool that automatically defaults to modern elliptic-curve cryptography, with its much shorter keys. We are indeed trying to abandon ancient, semi-prime cryptography such as RSA.

* Salty: [carlos8f/salty](https://github.com/carlos8f/salty)
* pdp: [stef/pbp](https://github.com/stef/pbp)
 
What is the problem with these alternatives?

`Salty` forcibly harasses the user into installing `nodejs` and `npm`. Javascript is definitely a commendable scripting language, but why does the user have to deal with painstakingly installing javascript infrastructure? Furthermore, `nodejs` is a whopping 14 MB of code, just to produce a "hello world" example. Hence, `nodejs` is barely or even not suitable for distributing programs to the end user.

`pdp` suffers from the same problem. Why harass the user with installing the entire python programming language platform, possible in its two incompatible versions (2.7 and 3.5)? Does the user really have to know and consider that half of the python world refuses to upgrade to version 3.5? The user is not trying to join the fragmented python world. He just wants run a program.

Therefore, say no to program platformization.

The user does not need to know that I have programmed the tool in lua. He can just download the executable program and be done with it.


## 6. Usage summary

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


### 7.1. Alice generates her keys


```
alice $ nacl-cli genseckey
nacl.cryp.sec.vhooeDeX4pckXxrA5wRCxU8EeU4NexgxQVjz2QhhDQ1n.uzw


alice $ seckey=nacl.cryp.sec.vhooeDeX4pckXxrA5wRCxU8EeU4NexgxQVjz2QhhDQ1n.uzw nacl-cli calcpubkey
nacl.cryp.pub.Hdkh4LrtMb2KfnLAqviyBqpmz4ntKcDCiJh8Pk5kZ89E.yPG
```

Now Alice can send her public key to Bob.


### 7.2. Bob encrypts a message for Alice


```
bob $ echo "this is my secret message" | nacl-cli enc pubkey=nacl.cryp.pub.Hdkh4LrtMb2KfnLAqviyBqpmz4ntKcDCiJh8Pk5kZ89E.yPG
--nacl-crypt--begin--
eph-pub:nacl.cryp.pub.DAnrM3apTQ7pBsZYx6sPkxRtQhWs9pa7taAnnE9NY6jw.Nd9
nonce:nacl.cryp.nonce.FrvHS6NNNndv44LySunkKE8Q5u6f5NRaL.2eU
.
8URzXs0ErZ8TqqMZsddai2a+/mRiuTa6BUxkPubMMtsihsPYchtGNxTq
--nacl-crypt--end--
```

The message is encrypted with an ephemeral secret. Alice can read it, but it does not authenticate the sender. 
The sender could actually be anybody who knows Alice's key.
If Bob wanted to guarantee to Alice that the message came from him, he would have had to sign it first.
Hence, this message is Off-The-Record (OTR).

### 7.3. Alice decrypts Bob's message with her secret key

```
alice $ echo "--nacl-crypt--begin--
> eph-pub:nacl.cryp.pub.DAnrM3apTQ7pBsZYx6sPkxRtQhWs9pa7taAnnE9NY6jw.Nd9
> nonce:nacl.cryp.nonce.FrvHS6NNNndv44LySunkKE8Q5u6f5NRaL.2eU
> .
> 8URzXs0ErZ8TqqMZsddai2a+/mRiuTa6BUxkPubMMtsihsPYchtGNxTq
> --nacl-crypt--end--
> " | seckey=nacl.cryp.sec.vhooeDeX4pckXxrA5wRCxU8EeU4NexgxQVjz2QhhDQ1n.uzw ./nacl-cli dec
this is my secret message
```

Alice could also have stored the message in a file mymess.txt and then decrypt it:

```
alice $ cat mymess.txt | seckey=nacl.cryp.sec.vhooeDeX4pckXxrA5wRCxU8EeU4NexgxQVjz2QhhDQ1n.uzw ./nacl-cli dec
this is my secret message
```

### 7.4. Note about using secrets on the command line

When a program parameter is not security-sensitive, you can simply supply it as an argument. Example:

```
$ nacl-cli enc pubkey=$nacl.cryp.pub
```

This is ok for public keys. It is recommended to transmit secret keys as environment variables:

```
$ pubkey=$nacl.cryp.sec nacl-cli enc
```

If you put the argument before the `nacl-cli` it will be transmitted through the environment.
If you put the argument after the `nacl-cli` command, it will be transmitted as a normal argument.

Only the user's (other) programs (and root) can query a program's environment.
All users can see the program's normal command line arguments.

This problem has been discussed umpteen times:

* [Is it safe to store critical passwords in server environment variables?](https://superuser.com/questions/708355/is-it-safe-to-store-critical-passwords-in-server-environment-variables)

* [Is it secure to store passwords as environment variables (rather than as plain text) in config files?](https://stackoverflow.com/questions/12461484/is-it-secure-to-store-passwords-as-environment-variables-rather-than-as-plain-t)

* [How to pass a password to a child process?](https://unix.stackexchange.com/questions/296297/how-to-pass-a-password-to-a-child-process)

* [how to use Environment Variables keep your secret keys safe & secure!](https://hackernoon.com/how-to-use-environment-variables-keep-your-secret-keys-safe-secure-8b1a7877d69c)

Still, it is possible to do a lot of things wrong. The following mistakes can impair the security of your secrets:

[Why you shouldn't use ENV variables for secret data](https://diogomonica.com/2017/03/27/why-you-shouldnt-use-env-variables-for-secret-data)

Still, there is not really an alternative either.

Conclusion: as usual, it is only safe, if you know what you are doing.


## 8. Reusing and embedding the script in your own program

TO DO

## 9. License

**nacl-cli**
Written by Erik Poupaert, Cambodia
(c) 2018
Licensed under the LGPL

