---
title: "[GraphQL] Responding multiple errors"
tags: ["ruby", "graphql"]
---

# Solution
Imitating this article [https://github.com/rmosolgo/graphql-ruby/issues/629#issuecomment-589877682], but in my case, `path` was said "unknown keyword" and removed from parameters like below:

```
def resolve(**args)
  context.add_error(
    GraphQL::ExecutionError.new(
      "first error message.",
      extensions: {...}
    )
  )
  context.add_error(
    GraphQL::ExecutionError.new(
      "second error message.",
      extensions: {...}
    )
  )
end
```