# How
Create controller such as below:
`app/controllers/debug_controller.rb`
```
class DebugController < ApplicationController
  def debug_session
    render json: session.to_json
  end
end
```

Append new route such as  below:
`config/routes.rb`
```
    resources :debug, only: [] do
      collection do
        get "/debug_session" => "debug#debug_session"
      end
    end
```

Execute some script such as below:
```
irb(main):004:0> app.cookies["_hoge_session"] = "session_id"
irb(main):004:0> app.get '/debug/debug_session'
irb(main):004:0> app.response
```

Then you should get information such as below:
```
#<ActionDispatch::TestResponse:0x0
 @cache_control={:max_age=>"0", :private=>true, :must_revalidate=>true},
 @committed=false,
 @cv=
  #<MonitorMixin::ConditionVariable:0x0
   @cond=#<Thread::ConditionVariable:0x0>,
   @monitor=#<Monitor:0x0>>,
 @header=
  {"X-Frame-Options"=>"SAMEORIGIN",
   "X-XSS-Protection"=>"1; mode=block",
   "X-Content-Type-Options"=>"nosniff",
   "X-Download-Options"=>"noopen",
   "X-Permitted-Cross-Domain-Policies"=>"none",
   "Referrer-Policy"=>"strict-origin-when-cross-origin",
   "Content-Type"=>"application/json; charset=utf-8",
   "ETag"=>"W/\"98174xxx\"",
   "Cache-Control"=>"max-age=0, private, must-revalidate",
   "X-Request-Id"=>"xxx",
   "X-Runtime"=>"0.027711",
   "Content-Length"=>"1640"},
 @mon_data=#<Monitor:0x0>,
 @mon_data_owner_object_id=22780,
 @request=#<ActionDispatch::Request GET "http://www.example.com/debug/debug_session" for 127.0.0.1>,
 @sending=false,
 @sent=false,
 @status=200,
 @stream=
  #<ActionDispatch::Response::Buffer:0x000000000179b408
   @buf=
    ["session data"],
   @closed=false,
   @response=#<ActionDispatch::TestResponse:0x0 ...>,
   @str_body=nil>>
```

# Tips
If you get such as below information to execute script in local: 
```
Blocked host: www.example.com</h1>\n</header>\n<div id=\"container\">\n  <h2>To allow requests to www.example.com, add the following to your environment configuration:</h2>\n  <pre>config.hosts &lt;&lt; \"www.example.com\"</pre>\n</div>\n\n\n</body>\n</html>\n
```
Add below to  `config/environments/development.rb`:
```
config.hosts << /www.example.com/
```

# References
[Calling controllers and actions from the Rails console](https://snippets.aktagon.com/snippets/316-calling-controllers-and-actions-from-the-rails-console)

[cloud9 - Upgraded Rails to 6, getting Blocked host Error - Stack Overflow](https://stackoverflow.com/a/57069747)