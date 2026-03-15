# Zatsu posts

技術メモとナレッジ共有のための個人ブログ

🌐 **Live Site**: https://rengotaku.github.io/

## 📝 ブログについて

日々の技術的な学びや、問題解決のプロセスを記録しているブログです。

## 🚀 ローカル開発

### 前提条件
- Ruby
- Bundler

### セットアップ

```bash
# 依存関係のインストール
bundle install

# ローカルサーバーの起動
bundle exec jekyll serve

# または Dockerを使用
docker-compose up
```

ブラウザで http://localhost:4000 にアクセス

## ✍️ 記事の書き方

### 1. ファイル作成

`_posts/` ディレクトリに以下の形式でファイルを作成：

```
YYYY-MM-DD-title-in-lowercase.md
```

**例**: `2024-01-15-getting-started-with-docker.md`

### 2. Frontmatter

ファイルの先頭に以下を記述：

```yaml
---
title: "記事のタイトル"
tags: ["tag1", "tag2", "tag3"]
---
```

### 3. 本文

Frontmatterの後に本文をMarkdownで記述

```markdown
# 見出し1

本文...

## 見出し2

- リスト項目1
- リスト項目2

\`\`\`python
# コード例
print("Hello, World!")
\`\`\`
```

## 📁 ディレクトリ構造

```
.
├── _posts/          # ブログ記事
├── _config.yml      # Jekyll設定
├── Gemfile          # Ruby依存関係
├── index.markdown   # トップページ
└── 404.html         # 404ページ
```

## 🔧 設定

- **テーマ**: [Minima](https://github.com/jekyll/minima)
- **プラグイン**: jekyll-feed

## 📦 デプロイ

GitHub Pagesの自動デプロイを使用:
- `master`ブランチへのpushで自動的にビルド・デプロイ
- URL: https://rengotaku.github.io/

## 🛠️ トラブルシューティング

### ビルドエラー
```bash
# 依存関係の更新
bundle update

# キャッシュのクリア
bundle exec jekyll clean
```

### ローカルで表示されない
- ポート4000が使用中でないか確認
- `_config.yml`のbaseurl設定を確認

## 📚 参考リンク

- [Jekyll公式ドキュメント](https://jekyllrb.com/)
- [Minimaテーマ](https://github.com/jekyll/minima)
- [GitHub Pages](https://pages.github.com/)
- [Markdown記法](https://www.markdownguide.org/)

## 📄 ライセンス

このブログの内容は個人の学習・参考用です。
