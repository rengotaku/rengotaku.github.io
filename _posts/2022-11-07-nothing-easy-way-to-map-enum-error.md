# Problem
What is defined as below: 
```
  enum state: {
    draft: 1,
    enabled: 2
    disabled: 3
  }
```
If you put a wrong value which no defined in enum attribute, take a error `ArgumentError: 'hoge' is not a valid status` and wanna  custom this error behavior such as error message.

Even if you'd like to modified code only a little, you  couldn't now.

# How
I'm not sure, but it look like good.
[ActiveRecord::Enum validation in Rails API | by Kerollos Magdy | Nerd For Tech | Medium](https://medium.com/nerd-for-tech/using-activerecord-enum-in-rails-35edc2e9070f)

You don't have the way not to modified own code now.

# References
* [ActiveRecord enum: use validation if exists instead of raising ArgumentError · Issue #13971 · rails/rails · GitHub](https://github.com/rails/rails/issues/13971)