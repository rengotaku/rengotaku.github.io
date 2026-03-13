# How
```
# Application user
CREATE USER 'hogehoge'@'192.168.1.1' IDENTIFIED WITH mysql_native_password BY 'hogehoge';
GRANT CREATE, ALTER, DROP, INSERT, UPDATE, DELETE, SELECT, REFERENCES, RELOAD on *.* TO 'hogehoge'@'192.168.1.1' WITH GRANT OPTION;

# Observation user
CREATE USER 'hogehoge'@'%' IDENTIFIED WITH mysql_native_password BY 'hogehoge';
GRANT INSERT, UPDATE, DELETE, SELECT, REFERENCES on *.* TO 'hogehoge'@'%' WITH GRANT OPTION;

# Packet caputres(Below used to use because of high pressure on a CPU)
tcpdump -i eth0 -G 600 -w /tmp/tcpdump_eth0.out -z "./packet-sender"
```

## High pressure on CPU
I'm not used to using below because of the title.
```
nohup tcpdump -i eth0 -G 600 -w /tmp/tcpdump_eth0.out -z "./packet-sender" 2>/tmp/pacet_capture.out
```

Now, using below
```
nohup ./packet-sender -v 1> ./packet_capture.out 2> ./packet_capture.err &
```
