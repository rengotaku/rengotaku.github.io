# Example
If you had a domain `example.com` and these belows are comparison chart between records and target domains:
| Record name         | Type  | Value/Route traffic to                                | Target domains                                                              |
|---------------------|-------|-------------------------------------------------------|-----------------------------------------------------------------------------|
| *.example.com       | CNAME | hoge.cloudfront.net                                   | hoge.example.com, entry.hoge.example.com                                                            |
| *.entry.example.com | CNAME | hoge.cloudfront.net                                   | hoge.entry.example.com, hoge2.entry.example.com, hoge.api.entry.example.com |
| *.api.example.com   | CNAME | hoge-alb-service-api.ap-northeast-1.elb.amazonaws.com | hoge.api.example.com, hoge2.api.example.com       |

In this case, Lambda-Edge works in Cloudfront's "Behavior" which can work sorting access.

# References
* [dns - Does the * in a CNAME record take priority over explicit subdomains? - Stack Overflow](https://stackoverflow.com/questions/14757475/does-the-in-a-cname-record-take-priority-over-explicit-subdomains)