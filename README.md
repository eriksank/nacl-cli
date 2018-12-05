# nacl-cli

## 1. Synopsis

`nacl-cli` is a program that provides a text-based, serialization format for encrypting/decrypting with Daniel Bernstein's `tweetnacl` library by using the [philanc/luatweetnacl](https://github.com/philanc/luatweetnacl) bindings. I have called it "armour", similar to the option in PGP.

`nacl-cli` only handles encryption/decryption.

If you need signing and verification of signatures, you can use a tool like [minisign](https://github.com/jedisct1/minisign).


## 2. Cryptographic note

The page [NaCl: Networking and Cryptography library](https://nacl.cr.yp.to/valid.html) clarifies the following:

"The following report specifies NaCl's default mechanism for public-key authenticated encryption, and along the way specifies NaCl's default mechanisms for scalar multiplication (Curve25519), secret-key authenticated encryption, secret-key encryption (Salsa20), and one-time authentication (Poly1305): 

Daniel J. Bernstein, "Cryptography in NaCl", 45pp."

Here a [link](https://cr.yp.to/highspeed/naclcrypto-20090310.pdf) to Daniel Bernstein's original publication.


## 3. A single, self-contained executable program

The program is a native, C-compiled executable, generated with [luapak](https://github.com/jirutka/luapak), which embeds a (very) small lua interpreter.

```
$ ls -lh /usr/lib/x86_64-linux-gnu/liblua5.1.so.0.0.0
-rw-r--r-- 1 root root 184K Apr 14  2016 /usr/lib/x86_64-linux-gnu/liblua5.1.so.0.0.0
```

This is the dynamically-linked version of the lua embedded scripting engine. It is not big, is it?

Internally, the program is a mixture between native code and lua scripts. However, this is of no importance to the user, who just sees one, small, single native binary.

When it makes sense to do that, the code tends to get moved from lua scripts to native modules, written in C:

```
$ ls -lh /usr/local/lib/lua/5.1
total 172K
-rwxr-xr-x 1 root root 13K Nov 26 08:24 base64.so
-rwxr-xr-x 1 root root 14K Dec  1 16:23 brieflz.so
-rwxr-xr-x 1 root root 25K Dec  1 16:23 lfs.so
-rwxr-xr-x 1 root root 51K Dec  2 16:45 lpeg.so
-rwxr-xr-x 1 root root 36K Nov 23 06:08 luatweetnacl.so
-rwxr-xr-x 1 root root 23K Nov 23 14:41 sha2.so

```

The `luapak` tool will produce statically-linked versions of these native modules, suitable for inclusion in the single, executable program. That spares you from dragging around lots of little files to be installed in different locations. It tremendously simplifies software packaging.


## 4. Support for Microsoft Windows

It would undoubtedly be possible to generate a static executable for Windows.
However, Windows is not understood to be viable operating system for serious cryptography.
If you store or transmit sensitive information in that kind of context, encrypting it, looks irrelevant.

## 5. Installation

Download the latest release from the [releases](https://github.com/eriksank/nacl-cli/releases/latest).
The redistributable file looks like `nacl-cli-linux-64bit-0.5.tar.gz`. The "0.5" is the version number of the release.
A newer release will have a higher version number.

Next, you can decompress the redistributable. You may have a desktop program for that purpose, but you can also do it from the command line:

```
$ tar xvzf nacl-cli-linux-64bit-0.5.tar.gz
```

The redistributable contains the following files:

* `nacl-cli` : the actual program
* `install.sh`: this script will install `nacl-cli` in `/usr/local/bin`. Must be executed as root ("sudo ./install.sh")
* `uninstall.sh`: this script will remove `nacl-cli` from `/usr/local/bin`. Must be executed as root  ("sudo ./uninstall.sh")
* `_smoketest.sh`: this script tests `nacl-cli`.

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


## 6. Similar programs

This is not the first attempt at replacing the venerable PGP program with a simpler command line tool that automatically defaults to modern elliptic-curve cryptography, with its much shorter keys. We are indeed trying to abandon ancient, semi-prime cryptography such as RSA.

* Salty: [carlos8f/salty](https://github.com/carlos8f/salty)
* pdp: [stef/pbp](https://github.com/stef/pbp)
 
What is the problem with these alternatives?

`Salty` forcibly harasses the user into installing `nodejs` and `npm`. Javascript is definitely a commendable scripting language, but why does the user have to deal with painstakingly installing javascript infrastructure? Furthermore, `nodejs` is a whopping 14 MB of code, just to produce a "hello world" example. Hence, `nodejs` is barely or even not suitable for distributing programs to the end user.

`pdp` suffers from the same problem. Why harass the user with installing the entire python programming language platform, possible in its two incompatible versions (2.7 and 3.5)? Does the user really have to know and consider that half of the python world refuses to upgrade to version 3.5? The user is not trying to join the fragmented python world. He just wants run a program.

Therefore, say no to program platformization.

The user does not need to know that I have programmed the tool in lua. He can just download the executable program and be done with it.


## 7. Usage summary

`nacl-cli` supports the following commands:

* `genseckey`: generates a new secret key
* `calcpubkey`: calculates the public key that goes with a secret key
* `enc`: encrypts plaintext and outputs crypttext encrypted to the public key of the recipient
* `dec`: decrypts crypttext and outputs plaintext using your secret key
* `help`: lists each command with its arguments

```bash

$ nacl-cli help
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


## 8. Detailed usage

Alice wants to send an encrypted message to Bob. How does it go?


### 8.1. Alice generates her keys


```
alice $ nacl-cli genseckey
nacl.cryp.sec.vhooeDeX4pckXxrA5wRCxU8EeU4NexgxQVjz2QhhDQ1n.uzw


alice $ seckey=nacl.cryp.sec.vhooeDeX4pckXxrA5wRCxU8EeU4NexgxQVjz2QhhDQ1n.uzw nacl-cli calcpubkey
nacl.cryp.pub.Hdkh4LrtMb2KfnLAqviyBqpmz4ntKcDCiJh8Pk5kZ89E.yPG
```

Now Alice can send her public key to Bob.


### 8.2. Bob encrypts a message for Alice


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

### 8.3. Alice decrypts Bob's message with her secret key

```
alice $ echo "--nacl-crypt--begin--
> eph-pub:nacl.cryp.pub.DAnrM3apTQ7pBsZYx6sPkxRtQhWs9pa7taAnnE9NY6jw.Nd9
> nonce:nacl.cryp.nonce.FrvHS6NNNndv44LySunkKE8Q5u6f5NRaL.2eU
> .
> 8URzXs0ErZ8TqqMZsddai2a+/mRiuTa6BUxkPubMMtsihsPYchtGNxTq
> --nacl-crypt--end--
> " | seckey=nacl.cryp.sec.vhooeDeX4pckXxrA5wRCxU8EeU4NexgxQVjz2QhhDQ1n.uzw nacl-cli dec
this is my secret message
```

Alice could also have stored the message in a file mymess.txt and then decrypt it:

```
alice $ cat mymess.txt | seckey=nacl.cryp.sec.vhooeDeX4pckXxrA5wRCxU8EeU4NexgxQVjz2QhhDQ1n.uzw nacl-cli dec
this is my secret message
```

## 9. Note about using secrets on the command line

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

* [Why you shouldn't use ENV variables for secret data](https://diogomonica.com/2017/03/27/why-you-shouldnt-use-env-variables-for-secret-data)

Still, there is not really an alternative either. Conclusion: as usual, it is only safe, if you know what you are doing.

## 10. Running the built-in tests on nacl-cli

The program `_smoketest.sh` tests all commands through the commandline interface:

```
 $ ./_smoketest.sh 
[generating secret] ...
seckey=nacl.cryp.sec.aeaZWHmi7KkDQGDK7McxLySASLCuuYfY1wfdD9uLZrVB.Zyw
[calculating public key] ...
calcpubkey ... SUCCESS
pubkey=nacl.cryp.pub.XjVox6UgdoZYs9y5ed63qCE8jBXBRt5k4k12FDJUmiME.h3E
[encrypting message] ...
encrypt ... SUCCESS
[crypttext]
--nacl-crypt--begin--
eph-pub:nacl.cryp.pub.AcWC9RTbDMSLZwqaj49Pi6REuqvjKcc9t2xja5AGiY3B.nqs
nonce:nacl.cryp.nonce.2kpfHnn8aMoHbUFNEcq1DrUdmzMg42HGG.2nE
.
PtBifjLjh77sX25NAmJaVm3qwcpKCkBiYoxebtYOrd2UfuNf6/LT
--nacl-crypt--end--
[decrypting message] ...
decrypt ... SUCCESS
[plaintext]
this is a test message

```

The program `_smoketest.lua` tests all commands by loading the armour as a lua module while bypassing the commandline interface:

```
$ ./_smoketest.lua 
-------------------
checking key generation
-------------------
calculation pubkey
CHECK: ok
-------------------
checking encryption/decryption
-------------------
--nacl-crypt--begin--
eph-pub:nacl.cryp.pub.9NFDpQ5uNZuiqBCEFHCFqEgQwBT7vypa2M3ASuzneB73.Rwn
nonce:nacl.cryp.nonce.NpoE93JCChTBN7TeZokHZ67koLkFisZE4.Xa9
.
B/GPfuHpxAFI9DojoQ8YEkRkbfwI0K1lbFXociccHb0SMP0Zb8qfT7pZ
--nacl-crypt--end--
transmission eph_pubkey
CHECK: ok
transmission nonce
CHECK: ok
decryption
CHECK: ok

```

## 11. Reusing and embedding the script in your own program

### 11.1. Chaining nacl-cli as an external program

Approximately every programming language worth its salt can fork off a child process to start running another program in it.
`nacl-cli` operates as a filter. It accepts its input on `stdin` and produces output on `stdout`.
If the program terminates successfully, it will exit with result code `0`.
Otherwise, it will exit with result code `1`.
In case of errors, you will find the error message on `stderr`.

### 11.2. Loading nacl-cli as a lua module

You can install `nacl-cli` in your lua environment with:

```
$ luarocks install nacl-cli
```

You can require it in your own script using:

```
local armour=require("lnacl-cli.armour")
```

You can use the following functions:
```
armour.genseckey()
armour.calcpubkey(seckey_b58)
armour.encrypt(pubkey_b58,plaintext)
armour.decrypt(seckey_b58,crypttext)
armour.isvalid_seckey(seckey_b58)
armour.isvalid_pubkey(pubkey_b58)
```

## 12. Security verifiables

### 12.1 Operating system platform security

The program routs its system calls through the `libc` system library and hence forth through the kernel.

The kernel itself is always a system security auditable:

```
$ ls -lh /boot/vmlinuz*
-rw-r--r-- 1 root root 7.0M Jun 28  2017 /boot/vmlinuz-4.8.0-53-generic
```

### 12.2 General user-space security

The program has two native, dynamically linked system dependencies (the other ones are virtual, linker scripts):

```
$ ldd nacl-cli
	linux-vdso.so.1 =>  (0x00007fff7189a000)
	libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f1012003000)
	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f1011c3a000)
	/lib64/ld-linux-x86-64.so.2 (0x0000561fdee9d000)

```
Therefore, the libraries `libc.so.6` and `libm.so.6` are platform-wide security auditables. Your program can never be safer than these two libraries.

### 12.3 Specific user-space security

**= scripting engine =**

The program embeds a scripting engine:

```
$ ls -lh /usr/lib/x86_64-linux-gnu/liblua5.1.a
-rw-r--r-- 1 root root 330K Apr 14  2016 /usr/lib/x86_64-linux-gnu/liblua5.1.a
```
for which you can find the source code at [lua/lua](https://github.com/lua/lua).

If you obtain this native archive through your linux distribution, you may need to verify its byte-for-byte [reproducible build](https://wiki.debian.org/ReproducibleBuilds) status.

The source code for the scripting engine is a security auditable.

**= external, third-party lua modules =**

You can find the external dependencies in the `.luapak` subfolder in the buidl folder.

The scripts will be in the `share` subfolder:

```
$ ls .luapak/share/lua/5.1/
armour.lua    cli.lua         hmac.lua  nacl_cli_0_5_1-armour.lua
    nacl_cli_0_5_1-ext-string.lua  nacl-cli.lua
...
```

The native archives will be in the `lib` subfolder:

```
$ ls .luapak/lib/lua/5.1
base64.a  lpeg.a  luatweetnacl.a  sha2.a
```

Unfortunately, the `luapak` tool seems to remove the source code that went into building these native archives.
This creates a reproducible build problem.

_[TO DO: I have raised the [issue](https://github.com/jirutka/luapak/issues/4) with the luapak author.]_

The source code of these application dependencies are security auditables.

### 12.4 Verification responsibility

Yes, even a rather small program generally causes a relatively large security audit issue.

When deploying the program for handling security-sensitive data, it is the user's own responsibility to commission version-specific, source-code level audits of the security auditables.

## 13. admin scripts

The `admin.sh` facilitates developing, building, and publishing the program.
You can use `./admin.sh help` to view the commands available.

It builds the executable using `luapack`.
It pushes the source code changes to the github publication platform.
It produces the binary release tarball, to be uploaded and tagged manually at github.
It pushes the lua module to the luarocks distribution platform.

## 14. Issues and feedback

Feel free to post a message on the [issue list](https://github.com/eriksank/nacl-cli/issues).

## 15. License

```
Written by Erik Poupaert
Cambodia,(c) 2018
Licensed under the LGPL
```

