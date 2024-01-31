---
title: "DebianをKaliLinuxにする"
tags: ["linux", "kali"]
---

## 前置き
[How to install Kali Linux apps in Debian](https://www.addictivetips.com/ubuntu-linux-tips/kali-linux-apps-in-debian/) に沿ってToolsをダウンロードできないかチャレンジしたが、断念した。

## チャレンジ
[Convert Debian to Kali](https://gist.github.com/warecrash/f35d4f9a822c452b0c54bbdb47c0c9a5) に沿って進める。

## 実行していく
すんなりと進む。

```
apt update
apt -y install wget gnupg dirmngr
wget -q -O - https://archive.kali.org/archive-key.asc | gpg --import
gpg --keyserver hkp://keys.gnupg.net --recv-key 44C6513A8E4FB3D30875F758ED444FF07D8D0BF6
echo "deb http://http.kali.org/kali kali-rolling main non-free contrib" >> /etc/apt/sources.list
gpg -a --export ED444FF07D8D0BF6 | sudo apt-key add -
apt update
```
※ `gpg --keyserver hkp://keys.gnupg.net --recv-key 44C6513A8E4FB3D30875F758ED444FF07D8D0BF6`は正常に終わっていないように見えた（だけど、皇族のコマンドで問題にはなっていないそう）

時間がかかります。
また途中で質問されます（文字コード、iPerf3のデフォルト起動、リスタートの有無、sudoers、sshd...）

```
apt -y upgrade
...
Running hooks in /etc/ca-certificates/update.d...
done.
Processing triggers for initramfs-tools (0.142) ...
```

割とすんなりと終わる

```
apt -y dist-upgrade
apt -y autoremove --purge
```

何度か選択を迫られます。
```
apt -y install kali-linux-headless
...
Adding debian:emSign_ECC_Root_CA_-_G3.pem
Adding debian:emSign_Root_CA_-_C1.pem
Adding debian:emSign_Root_CA_-_G1.pem
Adding debian:vTrus_ECC_Root_CA.pem
Adding debian:vTrus_Root_CA.pem
done.
Setting up default-jre-headless (2:1.17-75) ...
Setting up openjdk-17-jre:arm64 (17.0.10~6ea-1) ...
Setting up default-jre (2:1.17-75) ...
Setting up patator (1.0-2) ...
Setting up kali-linux-headless (2024.1.0) ...
Processing triggers for php8.2-cli (8.2.12-1+b1) ...
Processing triggers for libapache2-mod-php8.2 (8.2.12-1+b1) ...
```

とりあえず`nmap -h`が動いているのでOKとする。

## Tips
```
apt -y install kali-linux-everything
```

よくわからないエラーが発生した。断念した。
```
The following packages have unmet dependencies:
 chromium-x11 : Conflicts: chromium but 120.0.6099.224-1~deb11u1 is to be installed
                Conflicts: chromium-common but 120.0.6099.224-1~deb11u1 is to be installed
 gstreamer1.0-opencv : Depends: libopencv-contrib4.5 (>= 4.5.1+dfsg) but it is not going to be installed
                       Depends: libopencv-imgcodecs4.5 (>= 4.5.1+dfsg) but it is not going to be installed
 libgstreamer-plugins-bad1.0-dev : Depends: libopencv-dev (>= 2.3.0) but it is not going to be installed
 libqt6multimedia6 : Depends: libgstreamer1.0-0 (>= 1.20.0) but 1.18.5-1 is to be installed
 xserver-xephyr : Depends: xserver-common (>= 2:21.1.10-1) but 2:1.20.11-1 is to be installed
 xvfb : Depends: xserver-common (>= 2:21.1.10-1) but 2:1.20.11-1 is to be installed
```