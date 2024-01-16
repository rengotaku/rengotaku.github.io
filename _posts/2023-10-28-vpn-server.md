---
title: "Conohaと自宅鯖をVPNでつないで大容量ストレージサーバーを構築にトライ"
tags: ["softeather", "vpn", "linux", "centos"]
---

## 前提
[自宅サーバをInternet公開にするためSoftEther VPNをVPS上に設定する(1) - Hexo](http://the.netaro.info/_blog_/2021/10/03/2021-1003_softether-server/) に沿って作業をします。（大体がWindowsでToolを利用して設定している中でコマンドを細かく残してくれているブログに感謝です）

## リモートサーバの設定
### Firewallの解除
[CentOS 7 firewalld よく使うコマンド #centos7 - Qiita](https://qiita.com/kenjjiijjii/items/1057af2dddc34022b09e)

Conohaの接続許可ポートを`全て許可`

```
# systemctl start firewalld.service
# firewall-cmd --add-service=https --zone=public --permanent
# firewall-cmd --add-service=http --zone=public --permanent
# firewall-cmd --add-port=22/tcp --zone=public --permanent
# firewall-cmd --list-all-zones --permanent
```

**設定の内容**

```
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
```

### リモートサーバにSofteatherのインストール・設定

**インストール**

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

**設定**

```
$ sudo /opt/vpnserver/vpncmd
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
Hostname of IP Address of Destination: 160.251.200.200

If connecting to the server by Virtual Hub Admin Mode, please input the Virtual Hub name.
If connecting by server admin mode, please press Enter without inputting anything.
Specify Virtual Hub Name:
Connection has been established with VPN Server "160.251.200.200" (port 443).

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

VPN Server/vpnhub>UserCreate username /Group:none /REALNAME:none /NOTE:none
UserCreate command - Create User
The command completed successfully.

VPN Server/vpnhub>UserPasswordSet username
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
Pre Shared Key for IPsec (Recommended: 9 letters at maximum): ********

The command completed successfully.

VPN Server/vpnhub>SecureNatEnable
SecureNatEnable command - Enable the Virtual NAT and DHCP Server Function (SecureNat Function)
The command completed successfully.

VPN Server/vpnhub>exit
$ sudo systemctl status vpnserver
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
Nov 26 11:09:26 vm-18a3d3e4-1c.novalocal vpnserver[107516]: https://160.251.200.200:5555/
Nov 26 11:09:26 vm-18a3d3e4-1c.novalocal vpnserver[107516]:   or
Nov 26 11:09:26 vm-18a3d3e4-1c.novalocal vpnserver[107516]: https://160.251.200.200/
Nov 26 11:09:26 vm-18a3d3e4-1c.novalocal vpnserver[107516]: Note: IP address may vary. Specify your server's IP address.
Nov 26 11:09:26 vm-18a3d3e4-1c.novalocal vpnserver[107516]: A TLS certificate warning will appear because the server uses self signed certificate by default. That is natural. Continue with ignoring the TLS warning.
Nov 26 11:09:26 vm-18a3d3e4-1c.novalocal systemd[1]: Started Softether VPN Server Service.
```

### ローカルサーバにSofteatherの設定

```
$ sudo /opt/vpnserver/vpncmd
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
Hostname of IP Address of Destination: 160.251.200.200

If connecting to the server by Virtual Hub Admin Mode, please input the Virtual Hub name.
If connecting by server admin mode, please press Enter without inputting anything.
Specify Virtual Hub Name:
Connection has been established with VPN Server "160.251.200.200" (port 443).

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

VPN Server/privatenethub>UserCreate mypc /Group:none /REALNAME:none /NOTE:none
UserCreate command - Create User
The command completed successfully.

VPN Server/privatenethub>UserPasswordSet mypc
UserPasswordSet command - Set Password Authentication for User Auth Type and Set Password
Please enter the password. To cancel press the Ctrl+D key.

Password: ********************
Confirm input: ********************


The command completed successfully.
```

**DHCPの確認と有効化**

```
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
```

**RouterIfAddの実行**
```
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
```

```
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
```

**設定したIPの確認**

```
$ ifconfig
-bash: ifconfig: command not found
$ ip a
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
    inet 160.251.200.200/23 brd 160.251.203.255 scope global noprefixroute eth0
       valid_lft forever preferred_lft forever
    inet6 2400:8500:2002:3173:160:251:203:242/64 scope global noprefixroute
       valid_lft forever preferred_lft forever
    inet6 fe80::f816:3eff:fec2:d42d/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
```

**ローカルでの作業**
[自宅サーバをInternet公開にするためSoftEther VPNをVPS上に設定する(5) - Hexo](http://the.netaro.info/_blog_/2021/10/09/2021-1009_softether-kyoten-connect/)
```
$ sudo /opt/vpnserver/vpncmd localhost:5555 /SERVER
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

VPN Server>HubCreate mypchub
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

VPN Server>BridgeCreate mypchub /DEVICE:eth0 /TAP:yes
BridgeCreate command - Create Local Bridge Connection
While in the condition that occurs immediately after a new bridge connection is made when bridging to a physical network adapter, depending on the type of network adapter, there are cases where it will not be possible to communicate using TCP/IP to the network adapter using a bridge connection from a computer on the virtual network.
(This phenomenon is known to occur for Intel and Broadcom network adapters.)


If this issue arises, remedy the situation by restarting the computer on which VPN Server / Bridge is running. Normal communication will be possible after the computer has restarted.


Also many wireless network adapters will not respond to the sending of packets in promiscuous mode and when this occurs you will be unable to use the Local Bridge. If this issue arises, try using a regular wired network adapter instead of the wireless network adapter.

The command completed successfully.

VPN Server>Hub mypchub
Hub command - Select Virtual Hub to Manage
The Virtual Hub "mypchub" has been selected.
The command completed successfully.

VPN Server/mypchub>statusget
StatusGet command - Get Current Status of Virtual Hub
Item                         |Value
-----------------------------+-------------------
Virtual Hub Name             |mypchub
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

VPN Server/mypchub>sessionlist
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

VPN Server/mypchub>CascadeList
CascadeList command - Get List of Cascade Connections
Item|Value
----+-----
The command completed successfully.

VPN Server/mypchub>CascadeCreate cascade0 /SERVER:160.251.200.200:5555 /HUB:privateneth
ub /USERNAME:mypc
CascadeCreate command - Create New Cascade Connection
The command completed successfully.

VPN Server/mypchub>CascadePasswordSet cascade0 /PASSWORD:**************** /TYPE:sta
ndard
CascadePasswordSet command - Set User Authentication Type of Cascade Connection to Password Authentication
The command completed successfully.

VPN Server/mypchub>CascadeOnline cascade0
CascadeOnline command - Switch Cascade Connection to Online Status
The command completed successfully.

VPN Server/mypchub>CascadeList
CascadeList command - Get List of Cascade Connections
Item                  |Value
----------------------+-------------------------
Setting Name          |cascade0
Status                |Online (Established)
Established at        |2023-11-26 (Sun) 12:47:28
Destination VPN Server|160.251.200.200
Virtual Hub           |
The command completed successfully.

VPN Server/mypchub>CascadeStatusGet cascade0
CascadeStatusGet command - Get Current Cascade Connection Status
Item                                      |Value
------------------------------------------+--------------------------------------------------------
VPN Connection Setting Name               |cascade0
Session Status                            |Connection Completed (Session Established)
VLAN ID                                   |-
Server Name                               |160.251.200.200
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
Session Name                              |SID-mypc-3
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
```

**設定した内容を確認**

```
VPN Server/mypchub>BridgeList
BridgeList command - Get List of Local Bridge Connection
Number|Virtual Hub Name|Network Adapter or Tap Device Name|Status
------+----------------+----------------------------------+---------
1     |mypchub       |eth0                              |Operating
The command completed successfully.

VPN Server/mypchub>BridgeList
BridgeList command - Get List of Local Bridge Connection
Number|Virtual Hub Name|Network Adapter or Tap Device Name|Status
------+----------------+----------------------------------+---------
1     |mypchub       |eth0                              |Operating
The command completed successfully.

VPN Server/mypchub>BridgeDeviceList
BridgeDeviceList command - Get List of Network Adapters Usable as Local Bridge
eth0
eth1
The command completed successfully.

VPN Server/mypchub>ConnectionGet
ConnectionGet command - Get Information of TCP Connections Connecting to the VPN Server
Connection Name to Get Info: q

Error occurred. (Error code: 29)
Object not found.
VPN Server/mypchub>ConnectionList
ConnectionList command - Get List of TCP Connections Connecting to the VPN Server
Connection Name|Connection Source|Connection Start         |Type
---------------+-----------------+-------------------------+--------------
CID-2          |localhost: 60624 |2023-11-26 (Sun) 12:38:52|Management RPC
The command completed successfully.

VPN Server/mypchub>AccountStatusGet
"AccountStatusGet": Command not found.
You can use the HELP command to view a list of the available commands.
VPN Server/mypchub>exit
```
