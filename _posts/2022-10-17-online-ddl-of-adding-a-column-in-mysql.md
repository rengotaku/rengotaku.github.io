# How
You do need to use `no specific statement` on MySQL 5.7.
If you would use MySQL 5.6, you have to use the statement `ALGORITHM=INPLACE, LOCK=NONE` for no downtime.

# References
[MySQL :: MySQL 5.7 Reference Manual :: 14.13.1 Online DDL Operations](https://dev.mysql.com/doc/refman/5.7/en/innodb-online-ddl-operations.html#online-ddl-column-operations)

[What is MySQL's Online DDL | Ruby, Internet, and Programming](https://rip.hibariya.org/post/online-ddl/)

[Does adding a non-null default column cause downtime in MySQL 5.7? - Roger Lam](https://www.lamroger.com/posts/20191022-mysql-algorithm-lock/)