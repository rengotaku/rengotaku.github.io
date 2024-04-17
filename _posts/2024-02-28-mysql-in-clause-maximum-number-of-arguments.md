---
title: "[MySQL]IN句の渡せる最大引数は？"
tags: ["mysql"]
---

[conditional statements - MySQL IN condition limit - Stack Overflow](https://stackoverflow.com/questions/4275640/mysql-in-condition-limit)

## 前置き
IN句の引数(1,2,3...の箇所をさす)で渡せる上限が気になった。

`select * from table where id in (1, 2, 3...9999)`

## 結論
IN句自体の渡せる引数に制限はない。が、[max_allowed_packet](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_max_allowed_packet)によって制限される。

`show variables like 'max_allowed_packet'`で確認できる。単位がbyte。私の環境では16.7MB(16777216bytes)。

IN句以外で0.7MBを利用するとしたら、160万(16MB)文字なので、中々に制限を超えることはなさそう。