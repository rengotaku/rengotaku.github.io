---
title: "Active Storageでファイルを複製したい"
tags: ["rails", "activestorage"]
---

[Rails7 ActiveStorage レコードに添付済みの画像を複製して別レコードに添付する #Ruby - Qiita](https://qiita.com/KOH6/items/90fa856344d99fd17e9a)を参考に

## クラスの設定
```
class Post < ApplicationRecord
  ...
  has_many_attached :attachments, dependent: :purge_later
  ...
end
```

## ファイルのコピーの方法
### 各Postに別々のファイルとして添付する
```
new_post.attachments.attach(io: URI.open(app.polymorphic_url(post.attachments.first)), filename: post.attachments.first.filename)
```

`active_storage_blobs`、`active_storage_attachments`にレコード登録しているのがわかる
```
pry(main)> new_post.attachments.attach(io: URI.open(app.polymorphic_url(post.attachments.first)), filename: oa.attachments.first.filename)
  ActiveStorage::Attachment Load (12.6ms)  SELECT `active_storage_attachments`.* FROM `active_storage_attachments` WHERE `active_storage_attachments`.`record_id` = 130 AND `active_storage_attachments`.`record_type` = 'Post' AND `active_storage_attachments`.`name` = 'attachments' ORDER BY `active_storage_attachments`.`id` ASC LIMIT 1
  ActiveStorage::Blob Load (3.3ms)  SELECT `active_storage_blobs`.* FROM `active_storage_blobs` WHERE `active_storage_blobs`.`id` = 76 LIMIT 1
...
  ActiveStorage::Blob Create (2.1ms)  INSERT INTO `active_storage_blobs` (`key`, `filename`, `content_type`, `metadata`, `byte_size`, `checksum`, `created_at`, `service_name`) VALUES ('xz26v3enpok46m9rlnhein71b6ne', 'IMG_4871.jpg', 'image/jpeg', '{\"identified\":true}', 9791584, 'AkKORBLoYfcvAk4RJLHflg==', '2024-01-22 20:50:37', 'local')
  ActiveStorage::Attachment Create (2.3ms)  INSERT INTO `active_storage_attachments` (`name`, `record_type`, `record_id`, `blob_id`, `created_at`) VALUES ('attachments', 'Post', 133, 77, '2024-01-22 20:50:37')
...
  TRANSACTION (3.1ms)  COMMIT
  Disk Storage (26.3ms) Uploaded file to key: xz26v3enpok46m9rlnhein71b6ne (checksum: AkKORBLoYfcvAk4RJLHflg==)
=> true
```

```
origin_blob = post.attachment.blob
new_blob = ActiveStorage::Blob.create_and_upload!(
  io: StringIO.new(origin_blob.download),
  filename: origin_blob.filename,
  content_type: origin_blob.content_type
)
new_post.attachments.attach(new_blob)
```

### 複数のPostから同一ファイルを参照する
```
new_post.attachments.attach(post.attachments.first.blob)
```

`active_storage_attachments`のみ更新
```
pry(main)> new_post.attachments.attach(oa.attachments.first.blob)
  ActiveStorage::Attachment Load (15.5ms)  SELECT `active_storage_attachments`.* FROM `active_storage_attachments` WHERE `active_storage_attachments`.`record_id` = 131 AND `active_storage_attachments`.`record_type` = 'Post' AND `active_storage_attachments`.`name` = 'attachments' ORDER BY `active_storage_attachments`.`id` ASC LIMIT 1
  ActiveStorage::Blob Load (3.1ms)  SELECT `active_storage_blobs`.* FROM `active_storage_blobs` WHERE `active_storage_blobs`.`id` = 75 LIMIT 1
...
  ActiveStorage::Attachment Create (2.7ms)  INSERT INTO `active_storage_attachments` (`name`, `record_type`, `record_id`, `blob_id`, `created_at`) VALUES ('attachments', 'Post', 133, 75, '2024-01-22 18:11:38')
...
  TRANSACTION (1.3ms)  COMMIT
=> true
```

## Tips
**copy_of_fileは使えないかも。**

[Ruby-on-rails – How to duplicate a file stored in ActiveStorage in Rails 5.2 – iTecNote](https://itecnote.com/tecnote/r-how-to-duplicate-a-file-stored-in-activestorage-in-rails-5-2/)からすると複製の方法が変わった模様。

**ActiveStorageに格納されているファイルをダウンロードのURLの生成方法**

```
pry(main)> URI.open(app.polymorphic_url(post.attachments.first))
=> #<File:/var/folders/q4/mbnzt6791px2s0k69rp3wmf80000gn/T/open-uri20240122-74969-il0h3z>

pry(main)> URI.open("http://localhost:3000#{Rails.application.routes.url_helpers.rails_blob_path(oa.attachments.first)}")
=> #<File:/var/folders/q4/mbnzt6791px2s0k69rp3wmf80000gn/T/open-uri20240122-74969-1449hfb>
```
