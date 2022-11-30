---
title: "[Sentry] Refer to values other threads"
tags: ["ruby", "rails", "sentry"]
---

# Problem
We used to set transaction name or tags such below:
```
class ApplicationJob < ActiveJob::Base
  before_perform :error_happened_previously
  before_perform :set_sentry_transaction_and_tags

  def set_sentry_transaction_and_tags
    Sentry.configure_scope do |scope|
      scope.set_transaction_name(self.class.name)
      scope.set_tags(service_name: service_name)
    end
  end
  ...
end
```
If something bad was happened in error_happened_previously, I can't check right transaction name and tags in order to refer to values which has set other threads.

# Solution
Using `Sentry.with_scope`.

Document says as below:
> While this example looks similar to configure-scope, it is actually very different. Calls to configure-scope change the current active scope; all successive calls to configure-scope will maintain previously set changes unless they are explicitly unset.

# References
[Scopes and Hubs for Ruby | Sentry Documentation](https://docs.sentry.io/platforms/ruby/enriching-events/scopes/#using-with-scope)