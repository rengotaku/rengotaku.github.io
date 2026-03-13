# Problem
I defined model like below:
```
type Hostname struct {
	ID       uint    `gorm:"primaryKey"`
	IP       string  `gorm:"type:string;index:ip_uq,unique;"`
	Hostname *string `gorm:"type:string;"`
	ErrorFlg bool    `gorm:"type:bool;default:false;"`
}
```

And I'd like to perform like below:
```
SELECT * FROM `hostnames` WHERE hostname is null and error_flg = false LIMIT 10
```

I tried with `db.Where(&models.Hostname{Hostname: nil, ErrorFlg: false}).Find(&hostnames)`, then got message which represented raw SQL without "where" a log below:
```
[11.348ms] [rows:78] SELECT * FROM `hostnames`
```

# Solution
No use model struct in "Where".
`db.Where("hostname is null and error_flg = ?", false).Limit(10).Find(&hostnames)`

# References
[(TIL) Don’t use struct in GORM while building “where” clause | by Michał Kutrzeba | Medium](https://michal-kutrzeba.medium.com/til-dont-use-struct-in-gorm-while-building-where-clause-830376eab384)