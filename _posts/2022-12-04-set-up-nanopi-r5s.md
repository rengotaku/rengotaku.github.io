---
title: "[WIP][NanoPi R5S] Set up NanoPi R5S"
tags: ["nanopi", "router", "openwrt"]
---

# How
Environments as below:
* macOS Monterey

## Download image
[02_SD-to-eMMC images - Google Drive](https://drive.google.com/drive/folders/1--rZoPJ3AI0ulwI6msCBIzZG0Ep3c6V6)
```
$ md5sum -b rk3568-eflasher-friendlywrt-22.03-docker-20221123.img.gz
17e13a37fe84dc7277cfb5c5bf14e9df *rk3568-eflasher-friendlywrt-22.03-docker-20221123.img.gz
```
I would rather use OpenWRT than FriendlyWRT which are build up for NanoPi. In case of R4S, I used OpenWRT that I downloaded from [this](https://downloads.openwrt.org/snapshots/targets/rockchip/armv8/)(`friendlyarm_nanopi-r4s-ext4-sysupgrade.img.gz` was worked for me).
In case of R5S, I couldn't find and figure out there aren't similar file now.

## Flush image to Micro SD Card
I use [balenaEtcher - Flash OS images to SD cards & USB drives](https://www.balena.io/etcher/) for flushing image.

Start-up application, choose downloaded image and storage(Micro SD Card), then flush it.

## Power on Insert NanoPi
Insert Micro SD Card in NanoPi's card slot and plug cable in its PD. You can find to turn red LED of SYS WAN.
You could find "Installation Done" and you shutdown belows and pull Micro SD Card from NanoPi, then reboot again:
* Enter the "Services" -> "Terminal", enter the "poweroff" command and hit enter, wait until the led light is off, and then unplug the power supply.
* Plug cable out its PD

| Progress                 | SYS LED(Red)  | LAN LED(Green) | WAN LED(Green) |
|--------------------------|---------------|----------------|----------------|
| Power On                 | Solid On      | Off            | Off            |
| System Boot              | Slow Flashing | Off            | Off            |
| Installation in Progress | Fast Flashing | Off            | Off            |
| Installation Done        | Slow Flashing | Solid On       | Solid On       |

Slow Flashing seems turn LED 2 time per a second.

## Login FriendlyWrt
Put internet cable to LAN port of NanoPi

Check your default gate IP like below:
```
$ arp -a
friendlywrt.lan (192.168.2.1) at fe:f1:6c:21:9d:b9 on en5 ifscope [ethernet]
```

Open http://192.168.2.1/ and input default password "password" in the form, then you'll see FriendlyWrt's pages.

## Set up configuration
You can SSH to use `ssh root@192.168.2.1`

### Change password
"Services" -> "Administration" -> "Router Password"

### Restrict IP to access FriendlyWrt
Edit `/etc/config/uhttpd` as below:

After:
```
config uhttpd 'main'
        list listen_http '192.168.2.1:80'
        list listen_http '[fd00:ab:cd::1]:80'
        list listen_https '192.168.2.1:443'
        list listen_https '[fd00:ab:cd::1]:443'
```

Before:
```
config uhttpd 'main'
        list listen_http '0.0.0.0:80'
        list listen_http '[::]:80'
        list listen_https '0.0.0.0:443'
        list listen_https '[::]:443'
```

### Register SSH-Keys
Generate key files.
`ssh-keygen -t ed25519 -C "hoge@gmail.com"`

"Services" -> "Administration" -> "SSH-Keys"
Check your key to open `~/.ssh/id_ed25519.pub`, then Add key `ssh-ed25519 xxxxx hoge@gmail.com`.

Edit `~/.ssh/config` to append a setting as below:
```
Host homerouter
  HostName 192.168.2.1
  User root
  Port 22
  IdentityFile ~/.ssh/id_ed25519
```

You can access via SSH.
```
$ ssh homerouter
 ___    _             _ _    __      __   _
| __| _(_)___ _ _  __| | |_  \ \    / / _| |_
| _| '_| / -_) ' \/ _` | | || \ \/\/ / '_|  _|
|_||_| |_\___|_||_\__,_|_|\_, |\_/\_/|_|  \__|
                          |__/
 -----------------------------------------------------
 FriendlyWrt 22.03.2, rxxx-xxxxxxx
 -----------------------------------------------------
root@FriendlyWrt:~#
```

### Restrict to connect only LAN
"Services" -> "Administration" -> "SSH Access"
Select "lan" from Interface, if you don't public your server to internet.

### No use password authentication
"Services" -> "Administration" -> "SSH Access"
Uncheck the box "Password authentication", then you won't be able to access.
```
$ ssh root@192.168.2.1
root@192.168.2.1: Permission denied (publickey).
```

### Timezone
"System" -> "System" -> "General settings"
Select `Asia/Tokyo` from the Timezone select-box.

### NTP Server
"System" -> "System" -> "Time Synchronization"
Input `0.jp.pool.ntp.org ~ 3.jp.pool.ntp.org` in NTP server candidates.

# References
* [NanoPi R5S - FriendlyELEC WiKi](https://wiki.friendlyelec.com/wiki/index.php/NanoPi_R5S)
* [Is the nanopi R5S supported : openwrt](https://www.reddit.com/r/openwrt/comments/wmpcp2/is_the_nanopi_r5s_supported/)
* [pool.ntp.org: NTP Servers in Japan, jp.pool.ntp.org](https://www.pool.ntp.org/zone/jp)