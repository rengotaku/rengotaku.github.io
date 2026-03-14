# Problem
Do not know how to go out packet to host machine from a docker container.
```
bash-4.4# wget http://localhost:9040
--2022-11-02 05:14:45--  http://localhost:9040/
Resolving localhost... 127.0.0.1, ::1
Connecting to localhost|127.0.0.1|:9040... failed: Connection refused.
Connecting to localhost|::1|:9040... failed: Address not available.
Retrying.

--2022-11-02 05:14:46--  (try: 2)  
...
```

# Solution
Use domain `host.docker.internal`.
```
bash-4.4# wget http://host.docker.internal:9040
--2022-11-02 05:18:29--  http://host.docker.internal:9040/
Resolving host.docker.internal... 192.168.65.2
Connecting to host.docker.internal|192.168.65.2|:9040... connected.
HTTP request sent, awaiting response... 403 Forbidden
```

Or you can show IP of the domain.
```
bash-4.4# nslookup host.docker.internal
nslookup: can't resolve '(null)': Name does not resolve

Name:      host.docker.internal
Address 1: 192.168.65.2
```

```
bash-4.4# wget http://192.168.65.2:9040
--2022-11-02 05:21:40--  http://192.168.65.2:9040/
Connecting to 192.168.65.2:9040... connected.
HTTP request sent, awaiting response... 200 OK
```

# References
* [How to access host port from docker container - Stack Overflow](https://stackoverflow.com/questions/31324981/how-to-access-host-port-from-docker-container)