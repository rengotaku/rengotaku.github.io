# How
Check your instance's cpu.
```
$ lscpu

CPU(s):                2
On-line CPU(s) list:   0,1
Thread(s) per core:    2
Core(s) per socket:    1
Socket(s):             1
```
In this case, this cpu work normal until `load average 2.00` which is referred from below:

> While a load of 1 can mean approximately 100% resource usage on a single processor system, such systems are practically non-existent today. Unless you haven’t upgraded your system in over a decade, your system should run on a multi-core processor.
> 
> For a dual-core processor, a load of 1 means that 1 core was 100% idle. This translates to approximately 50% CPU usage. Similarly, it would represent 25% CPU usage for a quad-core processor.

# References
* [What is Load Average in Linux? | DigitalOcean](https://www.digitalocean.com/community/tutorials/load-average-in-linux)
* [amazon web services - AWS EC2: The number of cpu cores available on an instance - Stack Overflow](https://stackoverflow.com/a/34034483)