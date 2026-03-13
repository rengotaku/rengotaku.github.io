#!/bin/bash
# Jekyll blog投稿スクリプト

set -e

CONFIG_FILE="$HOME/.claude/kb-config.json"

# 設定ファイルの確認
if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "エラー: 設定ファイルが存在しません: $CONFIG_FILE"
  echo "先に /blog:init を実行してください。"
  exit 1
fi

# 設定の読み込み
REPO_PATH=$(jq -r .repositoryPath "$CONFIG_FILE")
POSTS_DIR=$(jq -r .postsDirectory "$CONFIG_FILE")
DEFAULT_CATEGORY=$(jq -r .defaultCategory "$CONFIG_FILE")
DEFAULT_TAGS=$(jq -r '.defaultTags | join(", ")' "$CONFIG_FILE")
AUTO_COMMIT=$(jq -r .autoCommit "$CONFIG_FILE")
AUTO_PUSH=$(jq -r .autoPush "$CONFIG_FILE")

# 引数の解析
TITLE=""
CATEGORIES=""
TAGS=""
CONTENT=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --title)
      TITLE="$2"
      shift 2
      ;;
    --categories)
      CATEGORIES="$2"
      shift 2
      ;;
    --tags)
      TAGS="$2"
      shift 2
      ;;
    --content)
      CONTENT="$2"
      shift 2
      ;;
    --file)
      if [[ -f "$2" ]]; then
        CONTENT=$(cat "$2")
      else
        echo "エラー: ファイルが存在しません: $2"
        exit 1
      fi
      shift 2
      ;;
    *)
      echo "不明なオプション: $1"
      exit 1
      ;;
  esac
done

# 対話入力（引数が指定されていない場合）
if [[ -z "$TITLE" ]]; then
  read -p "タイトル: " TITLE
fi

if [[ -z "$CATEGORIES" ]]; then
  read -p "カテゴリ (カンマ区切り) [$DEFAULT_CATEGORY]: " CATEGORIES
  CATEGORIES=${CATEGORIES:-$DEFAULT_CATEGORY}
fi

if [[ -z "$TAGS" ]]; then
  read -p "タグ (カンマ区切り) [$DEFAULT_TAGS]: " TAGS
  TAGS=${TAGS:-$DEFAULT_TAGS}
fi

if [[ -z "$CONTENT" ]]; then
  echo "本文を入力してください (Ctrl+D で終了):"
  CONTENT=$(cat)
fi

# ファイル名の生成（タイトルをケバブケースに変換）
DATE=$(date +%Y-%m-%d)
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//')
FILENAME="${DATE}-${SLUG}.md"
FILEPATH="$REPO_PATH/$POSTS_DIR/$FILENAME"

# ファイルの重複確認
if [[ -f "$FILEPATH" ]]; then
  echo "警告: ファイルが既に存在します: $FILENAME"
  read -p "上書きしますか? (y/n): " OVERWRITE
  if [[ "$OVERWRITE" != "y" ]]; then
    echo "キャンセルしました。"
    exit 0
  fi
fi

# カテゴリとタグの配列形式への変換
CATEGORIES_ARRAY="[$(echo $CATEGORIES | sed 's/,/, /g' | sed 's/\([^,]*\)/\1/g')]"
TAGS_ARRAY="[$(echo $TAGS | sed 's/,/, /g' | sed 's/\([^,]*\)/\1/g')]"

# Front Matterの生成
DATETIME=$(date +"%Y-%m-%d %H:%M:%S +0900")

# 投稿ファイルの作成
cat > "$FILEPATH" <<EOF
---
layout: post
title: "$TITLE"
date: $DATETIME
categories: $CATEGORIES_ARRAY
tags: $TAGS_ARRAY
---

$CONTENT
EOF

echo ""
echo "✅ 投稿ファイルを作成しました: $FILEPATH"
echo ""
echo "=== プレビュー ==="
head -20 "$FILEPATH"
echo ""

# Git操作
if [[ "$AUTO_COMMIT" == "true" ]]; then
  cd "$REPO_PATH"
  git add "$POSTS_DIR/$FILENAME"
  git commit -m "Add post: $TITLE"
  echo "✅ コミットしました: $FILENAME"

  if [[ "$AUTO_PUSH" == "true" ]]; then
    git push origin master
    echo "✅ プッシュしました。"
  else
    echo "ℹ️  プッシュは手動で実行してください: cd $REPO_PATH && git push"
  fi
else
  echo "ℹ️  Git操作は手動で実行してください:"
  echo "  cd $REPO_PATH"
  echo "  git add $POSTS_DIR/$FILENAME"
  echo "  git commit -m 'Add post: $TITLE'"
  echo "  git push origin master"
fi
