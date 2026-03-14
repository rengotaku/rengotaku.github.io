# Problems and solutions
## Problem
> The main risk when using the LOR algorithm is causing a flood of requests when a new target is added to the target group. In the LOR diagram above, Task 6 received 5 requests in quick succession, which might put it under high load. 

Solution
> The only way to avoid this issue is to ensure our autoscaling policy will launch at least a few tasks during each scale-up action.

## Problem
> The other potential issue is that a failing target will often respond quicker than a healthy one.

Solution
> The other potential issue is that a failing target will often respond quicker than a healthy one.

# References
* [AWS Application Load Balancer algorithms | by Simon Tabor | DAZN Engineering | Medium](https://medium.com/dazn-tech/aws-application-load-balancer-algorithms-765be2eca158)
