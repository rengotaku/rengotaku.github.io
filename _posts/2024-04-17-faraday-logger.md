---
title: "[Faraday]複数項目をフィルターする"
tags: ["faraday", "ruby"]
---

# 参考
https://lostisland.github.io/faraday/#/middleware/included/logging?id=filter-sensitive-information

ちなみに、https://github.com/lostisland/faraday_middleware/wiki などをChatGPTは推奨していたが、リクエスト値そのものを書き換えるので実現できず。

# フィルタリングしたいリクエスト

JSON形式です。

**フィルタリング前**

`{"secret_key":"xxxx","cus_id":"xxxx","access_token":"xxxx","xid":"xxxx", ...}`

**フィルタリング後**

`{"secret_key":"[FILTERED]","cus_id":"xxxx","access_token":"xxxx","xid":"[FILTERED]", ...}`

# フィルタリング処理

```
FILTERING_KEYS = %w(secret_key xid)

@conn = Faraday.new(url) do |f|
  f.adapter(Faraday.default_adapter)
  ...
  f.response :logger, nil, { headers: true, bodies: true, errors: true } do |logger|
    FILTERING_KEYS.each { |key| logger.filter(/(#{key}":)(".+?")/, '\1"[FILTERED]"') }
  end
end
```