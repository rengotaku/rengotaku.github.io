#!/bin/bash
# Jekyll blog検索スクリプト

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

# 引数の解析
KEYWORD=""
TAG=""
CATEGORY=""
FROM_DATE=""
TO_DATE=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --tag)
      TAG="$2"
      shift 2
      ;;
    --category)
      CATEGORY="$2"
      shift 2
      ;;
    --from)
      FROM_DATE="$2"
      shift 2
      ;;
    --to)
      TO_DATE="$2"
      shift 2
      ;;
    *)
      KEYWORD="$1"
      shift
      ;;
  esac
done

# 検索の実行
SEARCH_DIR="$REPO_PATH/$POSTS_DIR"

if [[ ! -d "$SEARCH_DIR" ]]; then
  echo "エラー: 投稿ディレクトリが存在しません: $SEARCH_DIR"
  exit 1
fi

echo "=== 検索中 ==="
echo ""

# ファイルリストの取得（日付範囲フィルタ）
FILES=$(ls -1 "$SEARCH_DIR"/*.md 2>/dev/null || echo "")

if [[ -z "$FILES" ]]; then
  echo "投稿が見つかりませんでした。"
  exit 0
fi

# 日付範囲フィルタ
if [[ -n "$FROM_DATE" ]]; then
  FILES=$(echo "$FILES" | grep -E "^$SEARCH_DIR/$FROM_DATE" || echo "$FILES")
fi

if [[ -n "$TO_DATE" ]]; then
  FILES=$(echo "$FILES" | grep -E "^$SEARCH_DIR/[0-9]{4}-[0-9]{2}-[0-9]{2}" | \
    awk -v to="$TO_DATE" '$0 <= to' || echo "$FILES")
fi

# 検索の実行
RESULTS=""
COUNT=0

for file in $FILES; do
  MATCH=false

  # キーワード検索
  if [[ -n "$KEYWORD" ]]; then
    if grep -qi "$KEYWORD" "$file"; then
      MATCH=true
    fi
  else
    MATCH=true
  fi

  # タグフィルタ
  if [[ -n "$TAG" ]] && [[ "$MATCH" == "true" ]]; then
    if ! grep -qiE "^tags:.*$TAG" "$file"; then
      MATCH=false
    fi
  fi

  # カテゴリフィルタ
  if [[ -n "$CATEGORY" ]] && [[ "$MATCH" == "true" ]]; then
    if ! grep -qiE "^categories:.*$CATEGORY" "$file"; then
      MATCH=false
    fi
  fi

  # マッチした場合は結果に追加
  if [[ "$MATCH" == "true" ]]; then
    ((COUNT++))

    FILENAME=$(basename "$file")
    TITLE=$(grep -m 1 "^title:" "$file" | sed 's/^title: "\(.*\)"$/\1/')
    CATEGORIES=$(grep -m 1 "^categories:" "$file" | sed 's/^categories: //')
    TAGS=$(grep -m 1 "^tags:" "$file" | sed 's/^tags: //')

    echo "[$COUNT] $FILENAME"
    echo "タイトル: $TITLE"
    echo "カテゴリ: $CATEGORIES"
    echo "タグ: $TAGS"
    echo "パス: $file"
    echo ""
  fi
done

echo "=== 検索完了 ==="
echo "見つかった投稿: ${COUNT}件"
