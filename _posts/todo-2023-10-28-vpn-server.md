---
title: "Conohaと自宅鯖をVPNでつないで大容量ストレージサーバーを構築にトライ"
tags: ["softeather", "vpn", "linux", "centos"]
---

[CentOS 7 firewalld よく使うコマンド #centos7 - Qiita](https://qiita.com/kenjjiijjii/items/1057af2dddc34022b09e)

Conohaの接続許可ポートを`全て許可`

```
# systemctl start firewalld.service
# firewall-cmd --add-service=https --zone=public --permanent
# firewall-cmd --add-service=http --zone=public --permanent
# firewall-cmd --add-port=22/tcp --zone=public --permanent
# firewall-cmd --list-all-zones --permanent
```


[Conohaと自宅鯖をVPNでつないで大容量ストレージサーバーを構築した話 #centos7 - Qiita](https://qiita.com/salt_field/items/5969f7d7a8612e150bda)

```
# wget https://jp.softether-download.com/files/softether/v4.43-9799-beta-2023.08.31-tree/Linux/SoftEther_VPN_Server/64bit_-_Intel_x64_or_AMD64/softether-vpnserver-v4.43-9799-beta-2023.08.31-linux-x64-64bit.tar.gz

# tar xvfz softether-vpnserver-v4.43-9799-beta-2023.08.31-linux-x64-64bit.tar.gz
# cd vpnserver/
# make
```

```
# cd ..
# mv vpnserver /usr/local/
# cd /usr/local/vpnserver
```

**VPSでの作業**
[自宅サーバをInternet公開にするためSoftEther VPNをVPS上に設定する(1) - Hexo](http://the.netaro.info/_blog_/2021/10/03/2021-1003_softether-server/)

[Conohaと自宅鯖をVPNでつないで大容量ストレージサーバーを構築した話 #centos7 - Qiita](https://qiita.com/salt_field/items/5969f7d7a8612e150bda#%E5%90%84%E3%82%B5%E3%83%BC%E3%83%90%E3%83%BC%E3%81%AE%E5%BD%B9%E5%89%B2)
```
[admin@vm-18a3d3e4-1c ~]$ sudo /opt/vpnserver/vpncmd
vpncmd command - SoftEther VPN Command Line Management Utility
SoftEther VPN Command Line Management Utility (vpncmd command)
Version 4.41 Build 9782   (English)
Compiled 2022/11/17 16:36:25 by buildsan at crosswin with OpenSSL 3.0.7
Copyright (c) 2012-2022 SoftEther VPN Project. All Rights Reserved.

By using vpncmd program, the following can be achieved.

1. Management of VPN Server or VPN Bridge
2. Management of VPN Client
3. Use of VPN Tools (certificate creation and Network Traffic Speed Test Tool)

Select 1, 2 or 3: 1

Specify the host name or IP address of the computer that the destination VPN Server or VPN Bridge is operating on.
By specifying according to the format 'host name:port number', you can also specify the port number.
(When the port number is unspecified, 443 is used.)
If nothing is input and the Enter key is pressed, the connection will be made to the port number 8888 of localhost (this computer).
Hostname of IP Address of Destination: 160.251.203.242

If connecting to the server by Virtual Hub Admin Mode, please input the Virtual Hub name.
If connecting by server admin mode, please press Enter without inputting anything.
Specify Virtual Hub Name:
Connection has been established with VPN Server "160.251.203.242" (port 443).

You have administrator privileges for the entire VPN Server.

VPN Server>hubdelete
HubDelete command - Delete Virtual Hub
Name of Virtual Hub to delete: DEFAULT

The command completed successfully.

VPN Server>HubCreate vpnhub
HubCreate command - Create New Virtual Hub
Please enter the password. To cancel press the Ctrl+D key.

Password: ********************
Confirm input: ********************


The command completed successfully.

VPN Server>HUB vpnhub
Hub command - Select Virtual Hub to Manage
The Virtual Hub "vpnhub" has been selected.
The command completed successfully.

VPN Server/vpnhub>UserCreate takuya.kishira /Group:none /REALNAME:none /NOTE:none
UserCreate command - Create User
The command completed successfully.

VPN Server/vpnhub>UserPasswordSet takuya.kishira
UserPasswordSet command - Set Password Authentication for User Auth Type and Set Password
Please enter the password. To cancel press the Ctrl+D key.

Password: ********************
Confirm input: ********************


The command completed successfully.

VPN Server/vpnhub>IPsecEnable /L2TP:yes /L2TPRAW:no /ETHERIP:no /
IPsecEnable command - Enable or Disable IPsec VPN Server Function
The parameter "/" has been specified. It is not possible to specify this parameter when using the command "IPsecEnable". Input "IPsecEnable /HELP" to see the list of what parameters can be used.
VPN Server/vpnhub>IPsecEnable /L2TP:yes /L2TPRAW:no /ETHERIP:no /DEFAULTHUB:vpnhub
IPsecEnable command - Enable or Disable IPsec VPN Server Function
Pre Shared Key for IPsec (Recommended: 9 letters at maximum): 7p%B78j~3

The command completed successfully.

VPN Server/vpnhub>SecureNatEnable
SecureNatEnable command - Enable the Virtual NAT and DHCP Server Function (SecureNat Function)
The command completed successfully.

VPN Server/vpnhub>exit
[admin@vm-18a3d3e4-1c ~]$ sudo systemctl status vpnserver
● vpnserver.service - Softether VPN Server Service
     Loaded: loaded (/etc/systemd/system/vpnserver.service; enabled; preset: disabled)
     Active: active (running) since Sun 2023-11-26 11:09:26 JST; 16min ago
   Main PID: 107520 (vpnserver)
      Tasks: 38 (limit: 3355442)
     Memory: 26.0M
        CPU: 3.311s
     CGroup: /system.slice/vpnserver.service
             ├─107520 /opt/vpnserver/vpnserver execsvc
             └─107521 /opt/vpnserver/vpnserver execsvc

Nov 26 11:09:25 vm-18a3d3e4-1c.novalocal systemd[1]: Starting Softether VPN Server Service...
Nov 26 11:09:25 vm-18a3d3e4-1c.novalocal vpnserver[107516]: The SoftEther VPN Server service has been started.
Nov 26 11:09:26 vm-18a3d3e4-1c.novalocal vpnserver[107516]: Let's get started by accessing to the following URL from your PC:
Nov 26 11:09:26 vm-18a3d3e4-1c.novalocal vpnserver[107516]: https://160.251.203.242:5555/
Nov 26 11:09:26 vm-18a3d3e4-1c.novalocal vpnserver[107516]:   or
Nov 26 11:09:26 vm-18a3d3e4-1c.novalocal vpnserver[107516]: https://160.251.203.242/
Nov 26 11:09:26 vm-18a3d3e4-1c.novalocal vpnserver[107516]: Note: IP address may vary. Specify your server's IP address.
Nov 26 11:09:26 vm-18a3d3e4-1c.novalocal vpnserver[107516]: A TLS certificate warning will appear because the server uses self signed certificate by default. That is natural. Continue with ignoring the TLS warning.
Nov 26 11:09:26 vm-18a3d3e4-1c.novalocal systemd[1]: Started Softether VPN Server Service.
[admin@vm-18a3d3e4-1c ~]$ ifconfig
-bash: ifconfig: command not found
[admin@vm-18a3d3e4-1c ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,PROMISC,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether fa:16:3e:c2:d4:2d brd ff:ff:ff:ff:ff:ff
    altname enp0s3
    altname ens3
    inet 160.251.203.242/23 brd 160.251.203.255 scope global noprefixroute eth0
       valid_lft forever preferred_lft forever
    inet6 2400:8500:2002:3173:160:251:203:242/64 scope global noprefixroute
       valid_lft forever preferred_lft forever
    inet6 fe80::f816:3eff:fec2:d42d/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
[admin@vm-18a3d3e4-1c ~]$ tail -f /var/lo
local/ lock/  log/
[admin@vm-18a3d3e4-1c ~]$ tail -f /var/log/
anaconda/              cloud-init.log         dnf.rpm.log            private/               secure
audit/                 cloud-init-output.log  firewalld              qemu-ga/               sssd/
boot.log               cron                   hawkey.log             README                 tallylog
btmp                   dnf.librepo.log        lastlog                rhsm/                  tuned/
chrony/                dnf.log                messages               samba/                 wtmp
[admin@vm-18a3d3e4-1c ~]$ tail -f /opt/vpnserver/
Authors.txt                            lib/                                   security_log/
backup.vpn_server.config/              Makefile                               server_log/
chain_certs/                           packet_log/                            .VPN-37ED18A7E4
code/                                  .pid_6F02B52EDB7D7933E1F47910FE10DD90  vpncmd
.ctl_6F02B52EDB7D7933E1F47910FE10DD90  ReadMeFirst_Important_Notices_cn.txt   vpnserver
hamcore.se2                            ReadMeFirst_Important_Notices_en.txt   vpn_server.config
.install.sh                            ReadMeFirst_Important_Notices_ja.txt
lang.config                            ReadMeFirst_License.txt
[admin@vm-18a3d3e4-1c ~]$ client_loop: send disconnect: Broken pipe
kishiratakuya@Kishiras-MBP ~ % ssh myvpn
Enter passphrase for key '/Users/kishiratakuya/.ssh/id_ed25519_conohav3':
Last login: Sun Nov 26 11:28:09 2023 from 122.16.192.175
[admin@vm-18a3d3e4-1c ~]$ ls
softether-vpnserver-v4.41-9782-beta-2022.11.17-linux-x64-64bit.tar.gz
[admin@vm-18a3d3e4-1c ~]$ firewall-cmd --state
Authorization failed.
    Make sure polkit agent is running or run the application as superuser.
[admin@vm-18a3d3e4-1c ~]$ sudo firewall-cmd --state
running
[admin@vm-18a3d3e4-1c ~]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: eth0
  sources:
  services: cockpit dhcpv6-client ssh
  ports:
  protocols:
  forward: yes
block
  target: %%REJECT%%
  icmp-block-inversion: no
  interfaces:
  sources:
  services:
  ports:
  protocols:
  forward: yes
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:

dmz
  target: default
  icmp-block-inversion: no
  interfaces:
  sources:
  services: ssh
  ports:
  protocols:
  forward: yes
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:

drop
  target: DROP
  icmp-block-inversion: no
  interfaces:
  sources:
  services:
  ports:
  protocols:
  forward: yes
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:

external
  target: default
  icmp-block-inversion: no
  interfaces:
  sources:
  services: ssh
  ports:
  protocols:
  forward: yes
  masquerade: yes
  forward-ports:
...skipping...
block
  target: %%REJECT%%
  icmp-block-inversion: no
  interfaces:
  sources:
  services:
  ports:
  protocols:
  forward: yes
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:

dmz
  target: default
  icmp-block-inversion: no
  interfaces:
  sources:
  services: ssh
  ports:
  protocols:
  forward: yes
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:

drop
  target: DROP
  icmp-block-inversion: no
  interfaces:
  sources:
  services:
  ports:
  protocols:
  forward: yes
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:

external
  target: default
  icmp-block-inversion: no
  interfaces:
  sources:
  services: ssh
  ports:
  protocols:
  forward: yes
  masquerade: yes
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:

home
  target: default
  icmp-block-inversion: no
  interfaces:
  sources:
  services: cockpit dhcpv6-client mdns samba-client ssh
  ports:
  protocols:
  forward: yes
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:

internal
  target: default
  icmp-block-inversion: no
  interfaces:
  sources:
  services: cockpit dhcpv6-client mdns samba-client ssh
  ports:
  protocols:
  forward: yes
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:

nm-shared
  target: ACCEPT
  icmp-block-inversion: no
  interfaces:
  sources:
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
[admin@vm-18a3d3e4-1c ~]$ iptables -L
iptables v1.8.8 (nf_tables): Could not fetch rule set generation id: Permission denied (you must be root)

[admin@vm-18a3d3e4-1c ~]$ sudo iptables -L
Chain INPUT (policy ACCEPT)
target     prot opt source               destination

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
DROP       icmp -- !127.131.195.167     !127.87.64.209        icmp port-unreachable connmark match ! 0x71ecdd55
DROP       tcp  -- !127.190.213.158     !127.253.195.88       tcp spts:61001:65535 flags:RST/RST connmark match ! 0x46285b4e
[admin@vm-18a3d3e4-1c ~]$ sudo firewall-cmd --get-services
RH-Satellite-6 RH-Satellite-6-capsule afp amanda-client amanda-k5-client amqp amqps apcupsd audit ausweisapp2 bacula bacula-client bb bgp bitcoin bitcoin-rpc bitcoin-testnet bitcoin-testnet-rpc bittorrent-lsd ceph ceph-mon cfengine checkmk-agent cockpit collectd condor-collector cratedb ctdb dhcp dhcpv6 dhcpv6-client distcc dns dns-over-tls docker-registry docker-swarm dropbox-lansync elasticsearch etcd-client etcd-server finger foreman foreman-proxy freeipa-4 freeipa-ldap freeipa-ldaps freeipa-replication freeipa-trust ftp galera ganglia-client ganglia-master git gpsd grafana gre high-availability http http3 https ident imap imaps ipfs ipp ipp-client ipsec irc ircs iscsi-target isns jenkins kadmin kdeconnect kerberos kibana klogin kpasswd kprop kshell kube-api kube-apiserver kube-control-plane kube-control-plane-secure kube-controller-manager kube-controller-manager-secure kube-nodeport-services kube-scheduler kube-scheduler-secure kube-worker kubelet kubelet-readonly kubelet-worker ldap ldaps libvirt libvirt-tls lightning-network llmnr llmnr-tcp llmnr-udp managesieve matrix mdns memcache minidlna mongodb mosh mountd mqtt mqtt-tls ms-wbt mssql murmur mysql nbd netbios-ns netdata-dashboard nfs nfs3 nmea-0183 nrpe ntp nut openvpn ovirt-imageio ovirt-storageconsole ovirt-vmconsole plex pmcd pmproxy pmwebapi pmwebapis pop3 pop3s postgresql privoxy prometheus prometheus-node-exporter proxy-dhcp ps3netsrv ptp pulseaudio puppetmaster quassel radius rdp redis redis-sentinel rpc-bind rquotad rsh rsyncd rtsp salt-master samba samba-client samba-dc sane sip sips slp smtp smtp-submission smtps snmp snmptls snmptls-trap snmptrap spideroak-lansync spotify-sync squid ssdp ssh steam-streaming svdrp svn syncthing syncthing-gui synergy syslog syslog-tls telnet tentacle tftp tile38 tinc tor-socks transmission-client upnp-client vdsm vnc-server wbem-http wbem-https wireguard ws-discovery ws-discovery-client ws-discovery-tcp ws-discovery-udp wsman wsmans xdmcp xmpp-bosh xmpp-client xmpp-local xmpp-server zabbix-agent zabbix-server zerotier
[admin@vm-18a3d3e4-1c ~]$ sudo firewall-cmd --list-ports

[admin@vm-18a3d3e4-1c ~]$ sudo firewall-cmd --get-zones
block dmz drop external home internal nm-shared public trusted work
[admin@vm-18a3d3e4-1c ~]$ sudo firewall-cmd --zone=home --list-all
home
  target: default
  icmp-block-inversion: no
  interfaces:
  sources:
  services: cockpit dhcpv6-client mdns samba-client ssh
  ports:
  protocols:
  forward: yes
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
[admin@vm-18a3d3e4-1c ~]$ sudo firewall-cmd --list-all-zones | less
[admin@vm-18a3d3e4-1c ~]$ sudo firewall-cmd --add-service=https --zone=public --permanent
success
[admin@vm-18a3d3e4-1c ~]$ firewall-cmd --add-port=992/tcp --zone=public --permanent
Authorization failed.
    Make sure polkit agent is running or run the application as superuser.
[admin@vm-18a3d3e4-1c ~]$ sudo firewall-cmd --add-port=992/tcp --zone=public --permanent
success
[admin@vm-18a3d3e4-1c ~]$ sudo firewall-cmd --add-port=1194/tcp --zone=public --permanent
success
[admin@vm-18a3d3e4-1c ~]$ sudo firewall-cmd --add-port=5555/tcp --zone=public --permanent
success
[admin@vm-18a3d3e4-1c ~]$ sudo firewall-cmd --add-port=500/udp --zone=public --permanent
success
[admin@vm-18a3d3e4-1c ~]$ sudo firewall-cmd --add-port=4500/udp --zone=public --permanent
success
[admin@vm-18a3d3e4-1c ~]$ sudo firewall-cmd --reload
success
[admin@vm-18a3d3e4-1c ~]$ cd /etc/
[admin@vm-18a3d3e4-1c etc]$ git status
fatal: not a git repository (or any of the parent directories): .git
[admin@vm-18a3d3e4-1c etc]$ git diff
warning: Not a git repository. Use --no-index to compare two paths outside a working tree
usage: git diff --no-index [<options>] <path> <path>

Diff output format options
    -p, --patch           generate patch
    -s, --no-patch        suppress diff output
    -u                    generate patch
    -U, --unified[=<n>]   generate diffs with <n> lines context
    -W, --function-context
                          generate diffs with <n> lines context
    --raw                 generate the diff in raw format
    --patch-with-raw      synonym for '-p --raw'
    --patch-with-stat     synonym for '-p --stat'
    --numstat             machine friendly --stat
    --shortstat           output only the last line of --stat
    -X, --dirstat[=<param1,param2>...]
                          output the distribution of relative amount of changes for each sub-directory
    --cumulative          synonym for --dirstat=cumulative
    --dirstat-by-file[=<param1,param2>...]
                          synonym for --dirstat=files,param1,param2...
    --check               warn if changes introduce conflict markers or whitespace errors
    --summary             condensed summary such as creations, renames and mode changes
    --name-only           show only names of changed files
    --name-status         show only names and status of changed files
    --stat[=<width>[,<name-width>[,<count>]]]
                          generate diffstat
    --stat-width <width>  generate diffstat with a given width
    --stat-name-width <width>
                          generate diffstat with a given name width
    --stat-graph-width <width>
                          generate diffstat with a given graph width
    --stat-count <count>  generate diffstat with limited lines
    --compact-summary     generate compact summary in diffstat
    --binary              output a binary diff that can be applied
    --full-index          show full pre- and post-image object names on the "index" lines
    --color[=<when>]      show colored diff
    --ws-error-highlight <kind>
                          highlight whitespace errors in the 'context', 'old' or 'new' lines in the diff
    -z                    do not munge pathnames and use NULs as output field terminators in --raw or --numstat
    --abbrev[=<n>]        use <n> digits to display object names
    --src-prefix <prefix>
                          show the given source prefix instead of "a/"
    --dst-prefix <prefix>
                          show the given destination prefix instead of "b/"
    --line-prefix <prefix>
                          prepend an additional prefix to every line of output
    --no-prefix           do not show any source or destination prefix
    --inter-hunk-context <n>
                          show context between diff hunks up to the specified number of lines
    --output-indicator-new <char>
                          specify the character to indicate a new line instead of '+'
    --output-indicator-old <char>
                          specify the character to indicate an old line instead of '-'
    --output-indicator-context <char>
                          specify the character to indicate a context instead of ' '

Diff rename options
    -B, --break-rewrites[=<n>[/<m>]]
                          break complete rewrite changes into pairs of delete and create
    -M, --find-renames[=<n>]
                          detect renames
    -D, --irreversible-delete
                          omit the preimage for deletes
    -C, --find-copies[=<n>]
                          detect copies
    --find-copies-harder  use unmodified files as source to find copies
    --no-renames          disable rename detection
    --rename-empty        use empty blobs as rename source
    --follow              continue listing the history of a file beyond renames
    -l <n>                prevent rename/copy detection if the number of rename/copy targets exceeds given limit

Diff algorithm options
    --minimal             produce the smallest possible diff
    -w, --ignore-all-space
                          ignore whitespace when comparing lines
    -b, --ignore-space-change
                          ignore changes in amount of whitespace
    --ignore-space-at-eol
                          ignore changes in whitespace at EOL
    --ignore-cr-at-eol    ignore carrier-return at the end of line
    --ignore-blank-lines  ignore changes whose lines are all blank
    -I, --ignore-matching-lines <regex>
                          ignore changes whose all lines match <regex>
    --indent-heuristic    heuristic to shift diff hunk boundaries for easy reading
    --patience            generate diff using the "patience diff" algorithm
    --histogram           generate diff using the "histogram diff" algorithm
    --diff-algorithm <algorithm>
                          choose a diff algorithm
    --anchored <text>     generate diff using the "anchored diff" algorithm
    --word-diff[=<mode>]  show word diff, using <mode> to delimit changed words
    --word-diff-regex <regex>
                          use <regex> to decide what a word is
    --color-words[=<regex>]
                          equivalent to --word-diff=color --word-diff-regex=<regex>
    --color-moved[=<mode>]
                          moved lines of code are colored differently
    --color-moved-ws <mode>
                          how white spaces are ignored in --color-moved

Other diff options
    --relative[=<prefix>]
                          when run from subdir, exclude changes outside and show relative paths
    -a, --text            treat all files as text
    -R                    swap two inputs, reverse the diff
    --exit-code           exit with 1 if there were differences, 0 otherwise
    --quiet               disable all output of the program
    --ext-diff            allow an external diff helper to be executed
    --textconv            run external text conversion filters when comparing binary files
    --ignore-submodules[=<when>]
                          ignore changes to submodules in the diff generation
    --submodule[=<format>]
                          specify how differences in submodules are shown
    --ita-invisible-in-index
                          hide 'git add -N' entries from the index
    --ita-visible-in-index
                          treat 'git add -N' entries as real in the index
    -S <string>           look for differences that change the number of occurrences of the specified string
    -G <regex>            look for differences that change the number of occurrences of the specified regex
    --pickaxe-all         show all changes in the changeset with -S or -G
    --pickaxe-regex       treat <string> in -S as extended POSIX regular expression
    -O <file>             control the order in which files appear in the output
    --rotate-to <path>    show the change in the specified path first
    --skip-to <path>      skip the output to the specified path
    --find-object <object-id>
                          look for differences that change the number of occurrences of the specified object
    --diff-filter [(A|C|D|M|R|T|U|X|B)...[*]]
                          select files by diff type
    --output <file>       output to a specific file

[admin@vm-18a3d3e4-1c etc]$ sudo git diff
diff --git a/firewalld/zones/public.xml b/firewalld/zones/public.xml
index 62bc751..fb37399 100644
--- a/firewalld/zones/public.xml
+++ b/firewalld/zones/public.xml
@@ -5,5 +5,11 @@
   <service name="ssh"/>
   <service name="dhcpv6-client"/>
   <service name="cockpit"/>
+  <service name="https"/>
+  <port port="992" protocol="tcp"/>
+  <port port="1194" protocol="tcp"/>
+  <port port="5555" protocol="tcp"/>
+  <port port="500" protocol="udp"/>
+  <port port="4500" protocol="udp"/>
   <forward/>
 </zone>
[admin@vm-18a3d3e4-1c etc]$ sudo etckeeper commit "firewalld"
[master 6adba65] firewalld
 Author: admin <admin@vm-18a3d3e4-1c.novalocal>
 4 files changed, 22 insertions(+)
 create mode 120000 systemd/system/multi-user.target.wants/vpnserver.service
 create mode 100755 systemd/system/vpnserver.service
[admin@vm-18a3d3e4-1c etc]$ sudo git diff
[admin@vm-18a3d3e4-1c etc]$ sudo git log
commit 6adba651d250da32457718e26a07de0077f6ae0a (HEAD -> master)
Author: admin <admin@vm-18a3d3e4-1c.novalocal>
Date:   Sun Nov 26 16:16:47 2023 +0900

    firewalld

commit e1e9703ba7b8675fe89ccb00b2ab8549a55d4c9c
Author: admin <admin@vm-18a3d3e4-1c.novalocal>
Date:   Sat Nov 25 23:51:30 2023 +0900

    First commit of my /etc directory
[admin@vm-18a3d3e4-1c etc]$
Session Contents Restored on Nov 26, 2023 16:22
Last login: Sun Nov 26 16:22:45 on console
kishiratakuya@Kishiras-MBP ~ % ssh myvpn
Enter passphrase for key '/Users/kishiratakuya/.ssh/id_ed25519_conohav3':
Last login: Sun Nov 26 16:01:59 2023 from 122.16.192.175
[admin@vm-18a3d3e4-1c ~]$ ls /opt/vpnserver/
Authors.txt                            lib/                                   security_log/
backup.vpn_server.config/              Makefile                               server_log/
chain_certs/                           packet_log/                            .VPN-37ED18A7E4
code/                                  .pid_6F02B52EDB7D7933E1F47910FE10DD90  vpncmd
.ctl_6F02B52EDB7D7933E1F47910FE10DD90  ReadMeFirst_Important_Notices_cn.txt   vpnserver
hamcore.se2                            ReadMeFirst_Important_Notices_en.txt   vpn_server.config
.install.sh                            ReadMeFirst_Important_Notices_ja.txt
lang.config                            ReadMeFirst_License.txt
[admin@vm-18a3d3e4-1c ~]$ ln -s /opt/vpnserver/vpn_server.config /etc/^C
[admin@vm-18a3d3e4-1c ~]$ sudo mkdir /etc/vpnserver
[admin@vm-18a3d3e4-1c ~]$ ln -s /opt/vpnserver/vpn_server.config /etc/vpnserver/vpn_server.config
ln: failed to create symbolic link '/etc/vpnserver/vpn_server.config': Permission denied
[admin@vm-18a3d3e4-1c ~]$ sudo ln -s /opt/vpnserver/vpn_server.config /etc/vpnserver/vpn_server.config
[admin@vm-18a3d3e4-1c ~]$ less /etc/vpnserver/vpn_server.config
/etc/vpnserver/vpn_server.config: Permission denied
[admin@vm-18a3d3e4-1c ~]$ sudo less /etc/vpnserver/vpn_server.config
[admin@vm-18a3d3e4-1c ~]$ cd /etc/
[admin@vm-18a3d3e4-1c etc]$ sudo git diff
[admin@vm-18a3d3e4-1c etc]$ sudo git status
On branch master
Untracked files:
  (use "git add <file>..." to include in what will be committed)
	vpnserver/

nothing added to commit but untracked files present (use "git add" to track)
[admin@vm-18a3d3e4-1c etc]$ sudo git add
Nothing specified, nothing added.
hint: Maybe you wanted to say 'git add .'?
hint: Turn this message off by running
hint: "git config advice.addEmptyPathspec false"
[admin@vm-18a3d3e4-1c etc]$ sudo git log
commit 6adba651d250da32457718e26a07de0077f6ae0a (HEAD -> master)
Author: admin <admin@vm-18a3d3e4-1c.novalocal>
Date:   Sun Nov 26 16:16:47 2023 +0900

    firewalld

commit e1e9703ba7b8675fe89ccb00b2ab8549a55d4c9c
Author: admin <admin@vm-18a3d3e4-1c.novalocal>
Date:   Sat Nov 25 23:51:30 2023 +0900

    First commit of my /etc directory
[admin@vm-18a3d3e4-1c etc]$ sudo etckeeper commit "softeather etc"
[master 2219c2d] softeather etc
 Author: admin <admin@vm-18a3d3e4-1c.novalocal>
 2 files changed, 2 insertions(+)
 create mode 120000 vpnserver/vpn_server.config
[admin@vm-18a3d3e4-1c etc]$ cd /opt/vpnserver/
[admin@vm-18a3d3e4-1c vpnserver]$ ls
Authors.txt               code         lib         ReadMeFirst_Important_Notices_cn.txt  ReadMeFirst_License.txt  vpncmd
backup.vpn_server.config  hamcore.se2  Makefile    ReadMeFirst_Important_Notices_en.txt  security_log             vpnserver
chain_certs               lang.config  packet_log  ReadMeFirst_Important_Notices_ja.txt  server_log               vpn_server.config
[admin@vm-18a3d3e4-1c vpnserver]$ sudo /opt/vpnserver/vpncmd
vpncmd command - SoftEther VPN Command Line Management Utility
SoftEther VPN Command Line Management Utility (vpncmd command)
Version 4.41 Build 9782   (English)
Compiled 2022/11/17 16:36:25 by buildsan at crosswin with OpenSSL 3.0.7
Copyright (c) 2012-2022 SoftEther VPN Project. All Rights Reserved.

By using vpncmd program, the following can be achieved.

1. Management of VPN Server or VPN Bridge
2. Management of VPN Client
3. Use of VPN Tools (certificate creation and Network Traffic Speed Test Tool)

Select 1, 2 or 3: 1

Specify the host name or IP address of the computer that the destination VPN Server or VPN Bridge is operating on.
By specifying according to the format 'host name:port number', you can also specify the port number.
(When the port number is unspecified, 443 is used.)
If nothing is input and the Enter key is pressed, the connection will be made to the port number 8888 of localhost (this computer).
Hostname of IP Address of Destination: 160.251.203.242

If connecting to the server by Virtual Hub Admin Mode, please input the Virtual Hub name.
If connecting by server admin mode, please press Enter without inputting anything.
Specify Virtual Hub Name:
Connection has been established with VPN Server "160.251.203.242" (port 443).

You have administrator privileges for the entire VPN Server.

VPN Server>HubCreate privatenethub
HubCreate command - Create New Virtual Hub
Please enter the password. To cancel press the Ctrl+D key.

Password: ********************
Confirm input: ********************


The command completed successfully.

VPN Server>HUB privatenethub
Hub command - Select Virtual Hub to Manage
The Virtual Hub "privatenethub" has been selected.
The command completed successfully.

VPN Server/privatenethub>UserCreate nanopct6 /Group:none /REALNAME:none /NOTE:none
UserCreate command - Create User
The command completed successfully.

VPN Server/privatenethub>UserPasswordSet nanopct6
UserPasswordSet command - Set Password Authentication for User Auth Type and Set Password
Please enter the password. To cancel press the Ctrl+D key.

Password: ********************
Confirm input: ********************


The command completed successfully.

VPN Server/privatenethub>DhcpGet
DhcpGet command - Get Virtual DHCP Server Function Setting of SecureNAT Function
Item                           |Value
-------------------------------+--------------
Use Virtual DHCP Function      |Yes
Start Distribution Address Band|192.168.30.10
End Distribution Address Band  |192.168.30.200
Subnet Mask                    |255.255.255.0
Lease Limit (Seconds)          |7200
Default Gateway Address        |192.168.30.1
DNS Server Address 1           |192.168.30.1
DNS Server Address 2           |None
Domain Name                    |
Save NAT and DHCP Operation Log|Yes
Static Routing Table to Push   |
The command completed successfully.

VPN Server/privatenethub>DhcpEnable
DhcpEnable command - Enable Virtual DHCP Server Function of SecureNAT Function
The command completed successfully.

VPN Server/privatenethub>Hub vpnhub
Hub command - Select Virtual Hub to Manage
The Virtual Hub "vpnhub" has been selected.
The command completed successfully.

VPN Server/vpnhub>DhcpGet
DhcpGet command - Get Virtual DHCP Server Function Setting of SecureNAT Function
Item                           |Value
-------------------------------+--------------
Use Virtual DHCP Function      |Yes
Start Distribution Address Band|192.168.30.10
End Distribution Address Band  |192.168.30.200
Subnet Mask                    |255.255.255.0
Lease Limit (Seconds)          |7200
Default Gateway Address        |192.168.30.1
DNS Server Address 1           |192.168.30.1
DNS Server Address 2           |None
Domain Name                    |
Save NAT and DHCP Operation Log|Yes
Static Routing Table to Push   |
The command completed successfully.

VPN Server/vpnhub>RouterList
RouterList command - Get List of Virtual Layer 3 Switches
Layer 3 Switch Name|Running Status|Interfaces|Routing Tables
-------------------+--------------+----------+--------------
The command completed successfully.

VPN Server/vpnhub>RouterAdd vpnrouter
RouterAdd command - Define New Virtual Layer 3 Switch
The command completed successfully.

VPN Server/vpnhub>RouterIfList
RouterIfList command - Get List of Interfaces Registered on the Virtual Layer 3 Switch
Name of Virtual Layer 3 Switch:

You cannot make a blank specification.
Name of Virtual Layer 3 Switch:

You cannot make a blank specification.
Name of Virtual Layer 3 Switch:

You cannot make a blank specification.
Name of Virtual Layer 3 Switch: q

Error occurred. (Error code: 93)
Specified Virtual Layer 3 Switch not found.
VPN Server/vpnhub>RouterIfAdd vpndefif /HUB:vpnhub /IP:192.168.255.10/255.255.255.0
RouterIfAdd command - Add Virtual Interface to Virtual Layer 3 Switch
Error occurred. (Error code: 93)
Specified Virtual Layer 3 Switch not found.
VPN Server/vpnhub>RouterIfAdd vpnrouter /HUB:vpnhub /IP:192.168.255.10/255.255.255.0
RouterIfAdd command - Add Virtual Interface to Virtual Layer 3 Switch
The command completed successfully.

VPN Server/vpnhub>RouterTableList
RouterTableList command - Get List of Routing Tables of Virtual Layer 3 Switch
Name of Virtual Layer 3 Switch: vpnrouter

Network Address|Subnet Mask|Gateway Address|Metric
---------------+-----------+---------------+------
The command completed successfully.

VPN Server/vpnhub>RouterIfList
RouterIfList command - Get List of Interfaces Registered on the Virtual Layer 3 Switch
Name of Virtual Layer 3 Switch: vpnrouter

IP Address    |Subnet Mask  |Virtual Hub Name
--------------+-------------+----------------
192.168.255.10|255.255.255.0|vpnhub
The command completed successfully.

VPN Server/vpnhub>RouterStart vpnrouter
RouterStart command - Start Virtual Layer 3 Switch Operation
The command completed successfully.

VPN Server/vpnhub>RouterTableList
RouterTableList command - Get List of Routing Tables of Virtual Layer 3 Switch
Name of Virtual Layer 3 Switch: vpnrouter

Network Address|Subnet Mask|Gateway Address|Metric
---------------+-----------+---------------+------
The command completed successfully.

VPN Server/vpnhub>Hub privatenethub
Hub command - Select Virtual Hub to Manage
The Virtual Hub "privatenethub" has been selected.
The command completed successfully.

VPN Server/privatenethub>RouterAdd privatenetrouter
RouterAdd command - Define New Virtual Layer 3 Switch
The command completed successfully.

VPN Server/privatenethub>RouterIfAdd vpnrouter /HUB:vpnhub /IP:192.168.255.10/255.255.255.
VPN Server/privatenethub>RouterIfAdd vpnrouter /HUB:vpnhu /IP:192.168.255.10/255.255.255.0
    Server/privatenethub>RouterIfAdd vpnrouter /HUB:vpnh /IP:192.168.255.10/255.255.255.0
VPN Server/privatenethub>RouterIfAdd privatenetrouter /HUB:privatenethub /IP:192.168.2.100
/255.255.255.0
RouterIfAdd command - Add Virtual Interface to Virtual Layer 3 Switch
The command completed successfully.

VPN Server/privatenethub>RouterStart privatenetrouter
RouterStart command - Start Virtual Layer 3 Switch Operation
The command completed successfully.

VPN Server/privatenethub>client_loop: send disconnect: Broken pipe
%
kishiratakuya@Kishiras-MBP ~ % ssh myvpn
Enter passphrase for key '/Users/kishiratakuya/.ssh/id_ed25519_conohav3':
Last login: Sun Nov 26 18:04:34 2023 from 122.16.192.175
[admin@vm-18a3d3e4-1c ~]$ ping 192.168.2.1
PING 192.168.2.1 (192.168.2.1) 56(84) bytes of data.
^C
--- 192.168.2.1 ping statistics ---
10 packets transmitted, 0 received, 100% packet loss, time 9207ms

[admin@vm-18a3d3e4-1c ~]$ ping 192.168.2.1
PING 192.168.2.1 (192.168.2.1) 56(84) bytes of data.
^C
--- 192.168.2.1 ping statistics ---
4 packets transmitted, 0 received, 100% packet loss, time 3102ms

[admin@vm-18a3d3e4-1c ~]$ ping 192.168.2.20
PING 192.168.2.20 (192.168.2.20) 56(84) bytes of data.
^C
--- 192.168.2.20 ping statistics ---
119 packets transmitted, 0 received, 100% packet loss, time 120866ms

[admin@vm-18a3d3e4-1c ~]$ ping fe80::5c07:90ff:fecc:1e7b
PING fe80::5c07:90ff:fecc:1e7b(fe80::5c07:90ff:fecc:1e7b) 56 data bytes
^C
--- fe80::5c07:90ff:fecc:1e7b ping statistics ---
4 packets transmitted, 0 received, 100% packet loss, time 3064ms

[admin@vm-18a3d3e4-1c ~]$ ifconfig
-bash: ifconfig: command not found
[admin@vm-18a3d3e4-1c ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,PROMISC,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether fa:16:3e:c2:d4:2d brd ff:ff:ff:ff:ff:ff
    altname enp0s3
    altname ens3
    inet 160.251.203.242/23 brd 160.251.203.255 scope global noprefixroute eth0
       valid_lft forever preferred_lft forever
    inet6 2400:8500:2002:3173:160:251:203:242/64 scope global noprefixroute
       valid_lft forever preferred_lft forever
    inet6 fe80::f816:3eff:fec2:d42d/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
[admin@vm-18a3d3e4-1c ~]$ arp -a
-bash: arp: command not found
[admin@vm-18a3d3e4-1c ~]$ ping 192.168.255.10
PING 192.168.255.10 (192.168.255.10) 56(84) bytes of data.
^C
--- 192.168.255.10 ping statistics ---
4 packets transmitted, 0 received, 100% packet loss, time 3074ms

[admin@vm-18a3d3e4-1c ~]$ ping 192.168.30.1
PING 192.168.30.1 (192.168.30.1) 56(84) bytes of data.
^C
--- 192.168.30.1 ping statistics ---
3 packets transmitted, 0 received, 100% packet loss, time 2033ms
```

**ローカルでの作業**
[自宅サーバをInternet公開にするためSoftEther VPNをVPS上に設定する(5) - Hexo](http://the.netaro.info/_blog_/2021/10/09/2021-1009_softether-kyoten-connect/)
```
pi@NanoPC-T6:~$ sudo /opt/vpnserver/vpncmd localhost:5555 /SERVER
vpncmd command - SoftEther VPN Command Line Management Utility
SoftEther VPN Command Line Management Utility (vpncmd command)
Version 4.41 Build 9782   (English)
Compiled 2022/11/17 16:36:25 by buildsan at crosswin with OpenSSL 3.0.7
Copyright (c) 2012-2022 SoftEther VPN Project. All Rights Reserved.

Connection has been established with VPN Server "localhost" (port 5555).

You have administrator privileges for the entire VPN Server.

VPN Server>Hub BRIDGE
Hub command - Select Virtual Hub to Manage
Error occurred. (Error code: 8)
The specified Virtual Hub does not exist on the server.
VPN Server>hubdelete
HubDelete command - Delete Virtual Hub
Name of Virtual Hub to delete: DEFAULT

The command completed successfully.

VPN Server>HubCreate nanopchub
HubCreate command - Create New Virtual Hub
Please enter the password. To cancel press the Ctrl+D key.

Password: ********************
Confirm input: ********************


The command completed successfully.

VPN Server>BridgeDeviceList
BridgeDeviceList command - Get List of Network Adapters Usable as Local Bridge
eth0
eth1
The command completed successfully.

VPN Server>BridgeCreate nanopchub /DEVICE:eth0 /TAP:yes
BridgeCreate command - Create Local Bridge Connection
While in the condition that occurs immediately after a new bridge connection is made when bridging to a physical network adapter, depending on the type of network adapter, there are cases where it will not be possible to communicate using TCP/IP to the network adapter using a bridge connection from a computer on the virtual network.
(This phenomenon is known to occur for Intel and Broadcom network adapters.)


If this issue arises, remedy the situation by restarting the computer on which VPN Server / Bridge is running. Normal communication will be possible after the computer has restarted.


Also many wireless network adapters will not respond to the sending of packets in promiscuous mode and when this occurs you will be unable to use the Local Bridge. If this issue arises, try using a regular wired network adapter instead of the wireless network adapter.

The command completed successfully.

VPN Server>Hub nanopchub
Hub command - Select Virtual Hub to Manage
The Virtual Hub "nanopchub" has been selected.
The command completed successfully.

VPN Server/nanopchub>statusget
StatusGet command - Get Current Status of Virtual Hub
Item                         |Value
-----------------------------+-------------------
Virtual Hub Name             |nanopchub
Status                       |Online
Type                         |Standalone
SecureNAT                    |Disabled
Sessions                     |1
Access Lists                 |0
Users                        |0
Groups                       |0
MAC Tables                   |1
IP Tables                    |1
Num Logins                   |0
Last Login                   |2023-11-26 09:47:10
Last Communication           |2023-11-26 09:49:26
Created at                   |2023-11-26 09:47:10
Outgoing Unicast Packets     |13 packets
Outgoing Unicast Total Size  |1,118 bytes
Outgoing Broadcast Packets   |0 packets
Outgoing Broadcast Total Size|0 bytes
Incoming Unicast Packets     |31 packets
Incoming Unicast Total Size  |2,562 bytes
Incoming Broadcast Packets   |10 packets
Incoming Broadcast Total Size|796 bytes
The command completed successfully.

VPN Server/nanopchub>sessionlist
SessionList command - Get List of Connected Sessions
Item            |Value
----------------+-----------------
Session Name    |SID-LOCALBRIDGE-1
VLAN ID         |-
Location        |Local Session
User Name       |Local Bridge
Source Host Name|Ethernet Bridge
TCP Connections |None
Transfer Bytes  |4,812
Transfer Packets|58
The command completed successfully.

VPN Server/nanopchub>CascadeList
CascadeList command - Get List of Cascade Connections
Item|Value
----+-----
The command completed successfully.

VPN Server/nanopchub>client_loop: send disconnect: Broken pipe
%
kishiratakuya@Kishiras-MBP ~ % ssh nanopc
Welcome to Ubuntu 22.04.3 LTS (GNU/Linux 6.1.25 aarch64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

30 additional security updates can be applied with ESM Apps.
Learn more about enabling ESM Apps service at https://ubuntu.com/esm

*** System restart required ***
Last login: Sun Nov 26 12:28:12 2023 from 192.168.2.226
pi@NanoPC-T6:~$ sudo /opt/vpnserver/vpncmd localhost:5555 /SERVER
[sudo] password for pi:
vpncmd command - SoftEther VPN Command Line Management Utility
SoftEther VPN Command Line Management Utility (vpncmd command)
Version 4.41 Build 9782   (English)
Compiled 2022/11/17 16:36:25 by buildsan at crosswin with OpenSSL 3.0.7
Copyright (c) 2012-2022 SoftEther VPN Project. All Rights Reserved.

Connection has been established with VPN Server "localhost" (port 5555).

You have administrator privileges for the entire VPN Server.

VPN Server>Hub nanopchub
Hub command - Select Virtual Hub to Manage
The Virtual Hub "nanopchub" has been selected.
The command completed successfully.

VPN Server/nanopchub>CascadeList
CascadeList command - Get List of Cascade Connections
Item|Value
----+-----
The command completed successfully.

VPN Server/nanopchub>CascadeCreate cascade0 /SERVER:160.251.203.242:5555 /HUB:privateneth
ub /USERNAME:nanopct6
CascadeCreate command - Create New Cascade Connection
The command completed successfully.

VPN Server/nanopchub>CascadePasswordSet cascade0 /PASSWORD:G2dDfnXc=1H]#p-*Fi-v /TYPE:sta
ndard
CascadePasswordSet command - Set User Authentication Type of Cascade Connection to Password Authentication
The command completed successfully.

VPN Server/nanopchub>CascadeOnline cascade0
CascadeOnline command - Switch Cascade Connection to Online Status
The command completed successfully.

VPN Server/nanopchub>CascadeList
CascadeList command - Get List of Cascade Connections
Item                  |Value
----------------------+-------------------------
Setting Name          |cascade0
Status                |Online (Established)
Established at        |2023-11-26 (Sun) 12:47:28
Destination VPN Server|160.251.203.242
Virtual Hub           |
The command completed successfully.

VPN Server/nanopchub>CascadeStatusGet cascade0
CascadeStatusGet command - Get Current Cascade Connection Status
Item                                      |Value
------------------------------------------+--------------------------------------------------------
VPN Connection Setting Name               |cascade0
Session Status                            |Connection Completed (Session Established)
VLAN ID                                   |-
Server Name                               |160.251.203.242
Port Number                               |TCP Port 5555
Server Product Name                       |SoftEther VPN Server (64 bit)
Server Version                            |4.41
Server Build                              |Build 9782
Connection Started at                     |2023-11-26 (Sun) 12:47:28
First Session has been Established since  |2023-11-26 (Sun) 12:47:28
Current Session has been Established since|2023-11-26 (Sun) 12:47:28
Number of Established Sessions            |1 Times
Half Duplex TCP Connection Mode           |No (Full Duplex Mode)
VoIP / QoS Function                       |Enabled
Number of TCP Connections                 |8
Maximum Number of TCP Connections         |8
Encryption                                |Enabled (Algorithm: TLS_AES_256_GCM_SHA384)
Use of Compression                        |No (No Compression)
Physical Underlay Protocol                |Standard TCP/IP (IPv4)
                                          |IPv4 UDPAccel_Ver=2 ChachaPoly_OpenSSL UDPAccel_MSS=1309
UDP Acceleration is Supported             |Yes
UDP Acceleration is Active                |Yes
Session Name                              |SID-NANOPCT6-3
Connection Name                           |CID-68
Session Key (160 bit)                     |F25B5D1682273531B534FD1AA6A41FD80924548E
Bridge / Router Mode                      |Yes
Monitoring Mode                           |No
Outgoing Data Size                        |4,507 bytes
Incoming Data Size                        |5,533 bytes
Outgoing Unicast Packets                  |2 packets
Outgoing Unicast Total Size               |84 bytes
Outgoing Broadcast Packets                |0 packets
Outgoing Broadcast Total Size             |0 bytes
Incoming Unicast Packets                  |2 packets
Incoming Unicast Total Size               |84 bytes
Incoming Broadcast Packets                |6 packets
Incoming Broadcast Total Size             |381 bytes
The command completed successfully.

VPN Server/nanopchub>BridgeList
BridgeList command - Get List of Local Bridge Connection
Number|Virtual Hub Name|Network Adapter or Tap Device Name|Status
------+----------------+----------------------------------+---------
1     |nanopchub       |eth0                              |Operating
The command completed successfully.

VPN Server/nanopchub>BridgeList
BridgeList command - Get List of Local Bridge Connection
Number|Virtual Hub Name|Network Adapter or Tap Device Name|Status
------+----------------+----------------------------------+---------
1     |nanopchub       |eth0                              |Operating
The command completed successfully.

VPN Server/nanopchub>BridgeDeviceList
BridgeDeviceList command - Get List of Network Adapters Usable as Local Bridge
eth0
eth1
The command completed successfully.

VPN Server/nanopchub>ConnectionGet
ConnectionGet command - Get Information of TCP Connections Connecting to the VPN Server
Connection Name to Get Info: q

Error occurred. (Error code: 29)
Object not found.
VPN Server/nanopchub>ConnectionList
ConnectionList command - Get List of TCP Connections Connecting to the VPN Server
Connection Name|Connection Source|Connection Start         |Type
---------------+-----------------+-------------------------+--------------
CID-2          |localhost: 60624 |2023-11-26 (Sun) 12:38:52|Management RPC
The command completed successfully.

VPN Server/nanopchub>AccountStatusGet
"AccountStatusGet": Command not found.
You can use the HELP command to view a list of the available commands.
VPN Server/nanopchub>exit
pi@NanoPC-T6:~$ sudo /opt/vpnserver/vpncmd localhost:5555 /SERVER
[sudo] password for pi:
vpncmd command - SoftEther VPN Command Line Management Utility
SoftEther VPN Command Line Management Utility (vpncmd command)
Version 4.41 Build 9782   (English)
Compiled 2022/11/17 16:36:25 by buildsan at crosswin with OpenSSL 3.0.7
Copyright (c) 2012-2022 SoftEther VPN Project. All Rights Reserved.

Connection has been established with VPN Server "localhost" (port 5555).

You have administrator privileges for the entire VPN Server.

VPN Server>BridgeDeviceList
BridgeDeviceList command - Get List of Network Adapters Usable as Local Bridge
eth0
eth1
The command completed successfully.
```