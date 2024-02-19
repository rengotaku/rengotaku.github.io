---
title: "[Rails]外部キー制約違反を一時的に無効にする"
tags: ["mysql", "activerecord", "rails"]
---

レコードを削除しようとしたら外部キーエラーが発生した。
`ActiveRecord::InvalidForeignKey (Mysql2::Error: Cannot delete or update a parent row: a foreign key constraint fails`
一時的に制約違反を無効にして対応したい。

## How
[Add a cop to prevent use of `disable_referential_integrity` (#358608) · Issues · GitLab.org / GitLab · GitLab](https://gitlab.com/gitlab-org/gitlab/-/issues/358608)
`disable_referential_integrity`でブロック引数を渡せば一時的に無効にできる。

```
ActiveRecord::Base.connection.disable_referential_integrity do
  Something.destroy_all
end
```

**出力されたログ**
`FOREIGN_KEY_CHECKS`に0を設定していることが確認できる。

```
   (4.0ms)  SELECT @@FOREIGN_KEY_CHECKS
   (1.8ms)  SET FOREIGN_KEY_CHECKS = 0
  ...
  TRANSACTION (1.4ms)  BEGIN
  ...
  TRANSACTION (1.0ms)  ROLLBACK
   (0.7ms)  SET FOREIGN_KEY_CHECKS = 1
```

## Break down
### FOREIGN_KEY_CHECKSとは？
[MySQL :: MySQL 8.0 Reference Manual :: 7.1.8 Server System Variables](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_foreign_key_checks)

> If set to 1 (the default), foreign key constraints are checked. If set to 0, foreign key constraints are ignored
0を設定すると外部キーの制約を無視する。

### 影響度は？
`Scope`は、Global, Session とあるので、ScopeをSessionに留めておけば、たSessionへ（全体）の影響は出ない。

[python - How can I temporarily disable a foreign key constraint in MySQL? - Stack Overflow](https://stackoverflow.com/questions/15501673/how-can-i-temporarily-disable-a-foreign-key-constraint-in-mysql) より、デフォルトはSessionで、全体へ適用したい場合はGLOBALを明示する必要がある。

`SET GLOBAL FOREIGN_KEY_CHECKS=0;`
