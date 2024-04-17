---
title: "[Ruby]mysql2 gemのインストールがエラーになる"
tags: ["gem", "ruby", "rails"]
---

# バージョン等
**Middleware**

```
$ bundle version
Bundler version 2.4.21 (2023-10-17 commit d10b46bd15)
$ mysql --version
mysql  Ver 8.3.0 for macos13.6 on arm64 (Homebrew)
$ bundle show mysql2
/Users/hoge/.rbenv/versions/3.0.6/lib/ruby/gems/3.0.0/gems/mysql2-0.5.6
$ ruby --version
ruby 3.0.6p216 (2023-03-30 revision 23a532679b) [arm64-darwin22]
```

**Machine**

```
$ sw_vers
ProductName:            macOS
ProductVersion:         13.2.1
BuildVersion:           22D68
$ sysctl -n machdep.cpu.brand_string
Apple M2
```

# エラー内容

```

$ bundle install
Fetching gem metadata from https://rubygems.org/.......
...
Fetching mysql2 0.5.6
...
Installing mysql2 0.5.6 with native extensions
Gem::Ext::BuildError: ERROR: Failed to build gem native extension.

    current directory: /Users/hoge/.rbenv/versions/3.0.6/lib/ruby/gems/3.0.0/gems/mysql2-0.5.6/ext/mysql2
/Users/hoge/.rbenv/versions/3.0.6/bin/ruby -I /Users/hoge/.rbenv/versions/3.0.6/lib/ruby/3.0.0 -r
./siteconf20240312-75475-d3s1tr.rb extconf.rb --with-ldflags\=-L/usr/local/opt/openssl/lib
checking for rb_absint_size()... yes
checking for rb_absint_singlebit_p()... yes
checking for rb_gc_mark_movable()... yes
checking for rb_wait_for_single_fd()... yes
checking for rb_enc_interned_str() in ruby.h... yes
-----
Using --with-openssl-dir=/Users/hoge/.rbenv/versions/3.0.6/openssl
-----
-----
Using mysql_config at /opt/homebrew/bin/mysql_config
-----
checking for mysql.h... yes
checking for errmsg.h... yes
checking for SSL_MODE_DISABLED in mysql.h... yes
checking for SSL_MODE_PREFERRED in mysql.h... yes
checking for SSL_MODE_REQUIRED in mysql.h... yes
checking for SSL_MODE_VERIFY_CA in mysql.h... yes
checking for SSL_MODE_VERIFY_IDENTITY in mysql.h... yes
checking for MYSQL.net.vio in mysql.h... yes
checking for MYSQL.net.pvio in mysql.h... no
checking for MYSQL_DEFAULT_AUTH in mysql.h... yes
checking for MYSQL_ENABLE_CLEARTEXT_PLUGIN in mysql.h... yes
checking for SERVER_QUERY_NO_GOOD_INDEX_USED in mysql.h... yes
checking for SERVER_QUERY_NO_INDEX_USED in mysql.h... yes
checking for SERVER_QUERY_WAS_SLOW in mysql.h... yes
checking for MYSQL_OPTION_MULTI_STATEMENTS_ON in mysql.h... yes
checking for MYSQL_OPTION_MULTI_STATEMENTS_OFF in mysql.h... yes
checking for my_bool in mysql.h... no
checking for mysql_ssl_set() in mysql.h... no
-----
Don't know how to set rpath on your system, if MySQL libraries are not in path mysql2 may not load
-----
-----
Setting libpath to /opt/homebrew/Cellar/mysql/8.3.0_1/lib
-----
creating Makefile

current directory: /Users/hoge/.rbenv/versions/3.0.6/lib/ruby/gems/3.0.0/gems/mysql2-0.5.6/ext/mysql2
make DESTDIR\= clean

current directory: /Users/hoge/.rbenv/versions/3.0.6/lib/ruby/gems/3.0.0/gems/mysql2-0.5.6/ext/mysql2
make DESTDIR\=
compiling client.c
In file included from client.c:15:
./mysql_enc_name_to_ruby.h:43:1: warning: a function declaration without a prototype is deprecated in all versions of C and is not
supported in C2x [-Wdeprecated-non-prototype]
mysql2_mysql_enc_name_to_rb_hash (str, len)
^
./mysql_enc_name_to_ruby.h:86:1: warning: a function declaration without a prototype is deprecated in all versions of C and is not
supported in C2x [-Wdeprecated-non-prototype]
mysql2_mysql_enc_name_to_rb (str, len)
^
2 warnings generated.
compiling infile.c
compiling mysql2_ext.c
compiling result.c
result.c:304:35: warning: implicit conversion loses integer precision: 'unsigned long' to 'int' [-Wshorten-64-to-32]
        precision = field->length - (field->decimals > 0 ? 2 : 1);
                  ~ ~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1 warning generated.
compiling statement.c
linking shared-object mysql2/mysql2.bundle
ld: warning: directory not found for option '-L/usr/local/opt/openssl/lib'
ld: library not found for -lzstd
clang: error: linker command failed with exit code 1 (use -v to see invocation)
make: *** [mysql2.bundle] Error 1

make failed, exit code 2

Gem files will remain installed in /Users/hoge/.rbenv/versions/3.0.6/lib/ruby/gems/3.0.0/gems/mysql2-0.5.6 for inspection.
Results logged to
/Users/hoge/.rbenv/versions/3.0.6/lib/ruby/gems/3.0.0/extensions/arm64-darwin-22/3.0.0/mysql2-0.5.6/gem_make.out

  /Users/hoge/.rbenv/versions/3.0.6/lib/ruby/3.0.0/rubygems/ext/builder.rb:93:in `run'
  /Users/hoge/.rbenv/versions/3.0.6/lib/ruby/3.0.0/rubygems/ext/builder.rb:44:in `block in make'
  /Users/hoge/.rbenv/versions/3.0.6/lib/ruby/3.0.0/rubygems/ext/builder.rb:36:in `each'
  /Users/hoge/.rbenv/versions/3.0.6/lib/ruby/3.0.0/rubygems/ext/builder.rb:36:in `make'
  /Users/hoge/.rbenv/versions/3.0.6/lib/ruby/3.0.0/rubygems/ext/ext_conf_builder.rb:63:in `block in build'
  /Users/hoge/.rbenv/versions/3.0.6/lib/ruby/3.0.0/tempfile.rb:317:in `open'
  /Users/hoge/.rbenv/versions/3.0.6/lib/ruby/3.0.0/rubygems/ext/ext_conf_builder.rb:26:in `build'
  /Users/hoge/.rbenv/versions/3.0.6/lib/ruby/3.0.0/rubygems/ext/builder.rb:159:in `build_extension'
  /Users/hoge/.rbenv/versions/3.0.6/lib/ruby/3.0.0/rubygems/ext/builder.rb:193:in `block in build_extensions'
  /Users/hoge/.rbenv/versions/3.0.6/lib/ruby/3.0.0/rubygems/ext/builder.rb:190:in `each'
  /Users/hoge/.rbenv/versions/3.0.6/lib/ruby/3.0.0/rubygems/ext/builder.rb:190:in `build_extensions'
  /Users/hoge/.rbenv/versions/3.0.6/lib/ruby/3.0.0/rubygems/installer.rb:837:in `build_extensions'
/Users/hoge/.rbenv/versions/3.0.6/lib/ruby/gems/3.0.0/gems/bundler-2.4.7/lib/bundler/rubygems_gem_installer.rb:72:in
`build_extensions'
/Users/hoge/.rbenv/versions/3.0.6/lib/ruby/gems/3.0.0/gems/bundler-2.4.7/lib/bundler/rubygems_gem_installer.rb:28:in
`install'
  /Users/hoge/.rbenv/versions/3.0.6/lib/ruby/gems/3.0.0/gems/bundler-2.4.7/lib/bundler/source/rubygems.rb:200:in `install'
/Users/hoge/.rbenv/versions/3.0.6/lib/ruby/gems/3.0.0/gems/bundler-2.4.7/lib/bundler/installer/gem_installer.rb:54:in
`install'
/Users/hoge/.rbenv/versions/3.0.6/lib/ruby/gems/3.0.0/gems/bundler-2.4.7/lib/bundler/installer/gem_installer.rb:16:in
`install_from_spec'
/Users/hoge/.rbenv/versions/3.0.6/lib/ruby/gems/3.0.0/gems/bundler-2.4.7/lib/bundler/installer/parallel_installer.rb:167:in
`do_install'
/Users/hoge/.rbenv/versions/3.0.6/lib/ruby/gems/3.0.0/gems/bundler-2.4.7/lib/bundler/installer/parallel_installer.rb:158:in
`block in worker_pool'
  /Users/hoge/.rbenv/versions/3.0.6/lib/ruby/gems/3.0.0/gems/bundler-2.4.7/lib/bundler/worker.rb:62:in `apply_func'
/Users/hoge/.rbenv/versions/3.0.6/lib/ruby/gems/3.0.0/gems/bundler-2.4.7/lib/bundler/worker.rb:57:in `block in
process_queue'
  /Users/hoge/.rbenv/versions/3.0.6/lib/ruby/gems/3.0.0/gems/bundler-2.4.7/lib/bundler/worker.rb:54:in `loop'
  /Users/hoge/.rbenv/versions/3.0.6/lib/ruby/gems/3.0.0/gems/bundler-2.4.7/lib/bundler/worker.rb:54:in `process_queue'
/Users/hoge/.rbenv/versions/3.0.6/lib/ruby/gems/3.0.0/gems/bundler-2.4.7/lib/bundler/worker.rb:90:in `block (2 levels) in
create_threads'

An error occurred while installing mysql2 (0.5.6), and Bundler cannot continue.

In Gemfile:
  mysql2
```


# 行ったこと
## mysql2を全てアンインストールしてインストール(効果なし)

[MySQL起動エラーの対処の仕方【Library not loaded: /usr/local/opt/mysql/lib/libmysqlclient.21.dylib (LoadError)】 #MySQL - Qiita](https://qiita.com/k-yasuhiro/items/9674d2e6e0b0fac3e1a8)

```
$ bundle exec gem uninstall mysql2

Select gem to uninstall:
 1. mysql2-0.5.4
 2. mysql2-0.5.5
 3. mysql2-0.5.6
 4. All versions
> 4
Successfully uninstalled mysql2-0.5.4
Successfully uninstalled mysql2-0.5.5
Successfully uninstalled mysql2-0.5.6
$ bundle doctor
The following gems are missing
 * mysql2 (0.5.6)
Install missing gems with `bundle install`
```

## bundle config --globalを設定する(効果なし)

[bundle install fails with Gem::Ext::BuildError · Issue #1175 · brianmario/mysql2](https://github.com/brianmario/mysql2/issues/1175#issuecomment-1214674846)

```
$ bundle config --global build.mysql2 "--with-mysql-lib=/opt/homebrew/Cellar/mysql/8.3.0_1/lib --with-mysql-dir=/opt/homebrew/Cellar/mysql/8.3.0_1 --with-mysql-config=/opt/homebrew/Cellar/mysql/8.3.0_1/bin/mysql_config --with-mysql-include=/opt/homebrew/Cellar/mysql/8.3.0_1/include"
Your application has set build.mysql2 to "--with-ldflags=-L/usr/local/opt/openssl/lib". This will override the global value you are currently setting
$ bundle install
Fetching gem metadata from https://rubygems.org/.......
...
Gem::Ext::BuildError: ERROR: Failed to build gem native extension.
```

## LIBRARY_PATHの指定(効果あり)

[bundle install fails with Gem::Ext::BuildError · Issue #1175 · brianmario/mysql2](https://github.com/brianmario/mysql2/issues/1175#issuecomment-860257254)

```
$ export LIBRARY_PATH=$LIBRARY_PATH:$(brew --prefix zstd)/lib/
$ bundle install
Fetching gem metadata from https://rubygems.org/.

......
Installing mysql2 0.5.6 with native extensions
Bundle complete! 135 Gemfile dependencies, 346 gems now installed.
```

## mysqlのバージョン指定とオプションの指定(効果あり)
※ 別の作業で発生したので同じエラー内容による事象ではないがメモ。

[Problem with gem installing · Issue #1350 · brianmario/mysql2](https://github.com/brianmario/mysql2/issues/1350#issuecomment-1921562619)

```
$ brew uninstall mysql
Uninstalling /opt/homebrew/Cellar/mysql/8.3.0_1... (323 files, 312.6MB)
$ brew install mysql@8.0

$ gem install mysql2 -v '0.5.4' -- \
--with-mysql-lib=/opt/homebrew/Cellar/mysql@8.0/8.0.36_1/lib \
--with-mysql-dir=/opt/homebrew/Cellar/mysql@8.0/8.0.36_1 \
--with-mysql-config=/opt/homebrew/Cellar/mysql@8.0/8.0.36_1/bin/mysql_config \
--with-mysql-include=/opt/homebrew/Cellar/mysql@8.0/8.0.36_1/include
Building native extensions with: '--with-mysql-lib=/opt/homebrew/Cellar/mysql@8.0/8.0.36_1/lib --with-mysql-dir=/opt/homebrew/Cellar/mysql@8.0/8.0.36_1 --with-mysql-config=/opt/homebrew/Cellar/mysql@8.0/8.0.36_1/bin/mysql_config --with-mysql-include=/opt/homebrew/Cellar/mysql@8.0/8.0.36_1/include'
This could take a while...
Successfully installed mysql2-0.5.4
Parsing documentation for mysql2-0.5.4
Installing ri documentation for mysql2-0.5.4
Done installing documentation for mysql2 after 0 seconds
1 gem installed
```
