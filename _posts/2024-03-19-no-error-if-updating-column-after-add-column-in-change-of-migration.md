---
title: "[Activerecord] add_columnで追加したカラムを更新してもdown時にエラーにならない"
tags: ["ruby", "rails", "activerecord"]
---

# 学び
changeをdownする際の`remove_index、remove_column`は遅延実行されるので、追加したカラムに更新処理を行なっていてもエラーにならない。

# 検証
## 実行するmigration
カラムを追加する、かつ追加したカラムの値を更新する。

```
class AddSequenceToHoges < ActiveRecord::Migration[6.1]
  def change
    add_column :hoges, :sequence, :integer, after: :content, comment: '表示順'
    add_index :hoges, [:company_important_meeting_id, :sequence]

puts "Hoge.count: #{Hoge.count}"
    Hoge.find_each do |hoge|
puts "hoge in loop"
      hoge.update_column(:sequence, 1)
    end
  end
end
```

### up時
`add_column → add_index → 更新処理`と、呼び出し順に実行されている。

```
bundle exec rails db:migrate
== 20240221091903 AddSequenceToHoges: migrating ==
-- add_column(:hoges, :sequence, :integer, {:after=>:content, :comment=>"表示順"})
   -> 0.8408s
-- add_index(:hoges, [:fuga_id, :sequence])
   -> 0.0767s
Hoge.count.count: 1
hoge in loop
== 20240221091903 AddSequenceToHoges: migrated (1.0267s)
```

### down時
`更新処理 → remove_index → remove_column`と、upと逆実行になっている。感覚的にはカラムが削除されて、存在しないカラムを更新しようとしてエラーになると思っていた。

```
bundle exec rails db:migrate:down VERSION=20240221091903
== 20240221091903 AddSequenceToHoges: reverting ==
Hoge.count: 1
hoge in loop
-- remove_index(:hoges, [:fuga_id, :sequence])
   -> 0.0103s
-- remove_column(:hoges, :sequence, :integer, {:after=>:content, :comment=>"表示順"})
   -> 0.0656s
== 20240221091903 AddSequenceToHoges: reverted (0.1504s)
```