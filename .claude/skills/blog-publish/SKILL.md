---
name: blog-publish
description: ナレッジをJekyll blog形式で_postsに投稿する
---

# Jekyll Blog 投稿

学んだ知識や技術メモをJekyll blog形式で `_posts` ディレクトリに投稿する。

## 前提条件

`/blog:init` で初期化済みであること

## Claude Code の自動処理

このスキルでは、以下をClaude Codeが自動的に処理する:

1. **Front Matterの生成**
   - タイトルと本文から適切なカテゴリを推定
   - 本文の内容からタグを自動抽出
   - layout, date を自動設定

2. **ファイル名の生成**
   - タイトルを英数字+ハイフンに自動変換
   - 日付プレフィックス（YYYY-MM-DD）を自動付与

3. **Git操作**
   - 設定に応じて自動コミット・プッシュ

## 使用方法

### 基本的な使用
```
/blog:publish
```

Claude Codeが以下を実行:
1. タイトルと本文の入力を求める
2. 本文の内容を分析して、カテゴリとタグを推定
3. Front Matterを自動生成
4. Jekyll形式でファイルを作成
5. Git操作を実行（設定に応じて）

### 引数指定（オプション）
```
/blog:publish --title "タイトル" --file /path/to/draft.md
```

## Front Matter自動設定の例

入力:
```
タイトル: Python仮想環境のセットアップ
本文:
# Python仮想環境

Pythonプロジェクトでは必ずvenvを使用する...
```

Claude Codeが自動生成:
```yaml
---
layout: post
title: "Python仮想環境のセットアップ"
date: 2026-03-13 10:30:00 +0900
categories: [python, development]
tags: [python, venv, environment, setup]
---
```

## 推定ロジック

- **カテゴリ**: 本文の内容から主要なトピック（技術領域）を1-2個抽出
- **タグ**: 具体的なキーワード、ツール名、コマンド名などを3-5個抽出
- **デフォルト値**: `kb-config.json` の設定を使用

## 実行フロー

1. 設定ファイル `~/.claude/kb-config.json` を読み込み
2. ユーザーからタイトルと本文を受け取る
3. 本文を分析してカテゴリとタグを推定
4. Front Matterを生成
5. ファイル名を生成（YYYY-MM-DD-slug.md）
6. `_posts` ディレクトリにファイルを書き込み
7. Git add & commit（autoCommit=trueの場合）
8. Git push（autoPush=trueの場合）
9. 結果を報告

## 対話は最小限

ユーザーが入力するのは:
- タイトル
- 本文（またはファイルパス）

カテゴリ、タグ、日付、ファイル名などはClaude Codeが自動設定。
