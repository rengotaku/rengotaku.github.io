---
title: "Nginxのログのコンテンツの拡張"
tags: ["nginx"]
---

[Tech Blog: How to configure JSON logging in nginx? - Velebit AI](https://www.velebit.ai/blog/nginx-json-logging/)

# 設定
/etc/nginx/nginx.conf
```
log_format logger-json escape=json '{"time_local":"$time_local","msec":"$msec","body_bytes_sent":$body_bytes_sent,"upstream_bytes_received":"$upstream_bytes_received","http_host":"$http_host","remote_addr":"$remote_addr","http_x_forwarded_for":"$http_x_forwarded_for","request_length":$request_length,"request_method":"$request_method","http_x_forwarded_proto":"$http_x_forwarded_proto","query_string":"$query_string","uri":"$uri","status":$status,"http_referer":"$http_referer","http_user_agent":"$http_user_agent","request_time":$request_time,"upstream_response_time":"$upstream_response_time"}';

access_log /var/log/nginx/access.log logger-json;
```

**出力例**
nginxの前段にALBがあり、ユーザのIPは`http_x_forwarded_for`を参照するようにしてます。

```
{
   "time_local":"19/Sep/2023:16:01:10 +0900",
   "msec":"1695106870.434",
   "body_bytes_sent":38,
   "upstream_bytes_received":"892",
   "http_host":"example.com",
   "remote_addr":"10.1.1.1",
   "http_x_forwarded_for":"123.123.123.123",
   "request_length":809,
   "request_method":"GET",
   "http_x_forwarded_proto":"https",
   "query_string":"test=testttttttttttttttttt",
   "uri":"/",
   "status":401,
   "http_referer":"",
   "http_user_agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36",
   "request_time":0.007,
   "upstream_response_time":"0.008"
}
```