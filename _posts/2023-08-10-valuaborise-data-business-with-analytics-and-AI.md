---
title: "Generating a new SSH key with passphrase, and no need to enter each access"
tags: ["github", "ssh"]
---

# Solution
```
$ ssh-keygen -t ed25519 -C "hoge@example.com"
Generating public/private ed25519 key pair.
Enter file in which to save the key (/Users/username/.ssh/id_ed25519):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /Users/username/.ssh/id_ed25519
Your public key has been saved in /Users/username/.ssh/id_ed25519.pub
The key fingerprint is:
SHA256:/xxxx/xxxx hoge@example.com
The key's randomart image is:
+--[ED25519 256]--+
...
|        S ..o+*  |
...
+----[SHA256]-----+
$ ssh-add
Enter passphrase for /Users/username/.ssh/id_ed25519:
Identity added: /Users/username/.ssh/id_ed25519 (hoge@example.com)
```

If you want to generate password in Mac machine
```
$ cat /dev/urandom | LC_CTYPE=C tr -dc A-Za-z0-9 | head -c 30 ; echo
VN7Ox8OfaHNbxsoJeGrGVNU0OfzfXZ
```

# References
* [ssh - How to avoid being asked passphrase each time I push to Bitbucket - Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/12195/how-to-avoid-being-asked-passphrase-each-time-i-push-to-bitbucket)

* [Generating a new SSH key and adding it to the ssh-agent - GitHub Docs](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

* [Working with SSH key passphrases - GitHub Docs](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/working-with-ssh-key-passphrases)