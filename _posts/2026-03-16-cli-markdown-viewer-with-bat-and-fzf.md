---
title: "CLIでMarkdownファイルをリッチに閲覧する設定（glow + bat + fzf）"
tags: ["cli", "markdown", "glow", "bat", "fzf", "zsh"]
---

# 背景
ターミナルでMarkdownファイルを読みたい場面は多いが、`cat`だと装飾なしで読みにくい。

いくつかのツールを試した経緯:

1. **glow単体**: レンダリングは美しいが、`less`を通すとカラーが消える・テーブルが折り返される問題
2. **bat単体**: シンタックスハイライト・行番号・ページャー一体で便利だが、テーブルをレンダリングしない（生テキスト表示）
3. **mdcat**: テーブルレンダリング対応だが、日本語（全角文字）の幅計算がズレてテーブルのカラムが揃わない

最終的に**glow（メインビューア） + bat（fzfプレビュー）**の組み合わせに落ち着いた。
glowの`-p`（内蔵ページャー）と`-w 0`（ワードラップ無効）を使うことで、以前の問題を回避できた。

# 必要なツール

```bash
brew install glow bat fzf
```

- **glow**: Markdownレンダリング（テーブル・見出し等を整形表示）
- **bat**: シンタックスハイライト + 行番号 + ページャー内蔵の`cat`代替
- **fzf**: ファジーファインダー（インタラクティブなファイル選択）

# 設定

`~/.zsh_aliases`などに以下を追加:

```bash
# Markdown viewer (glow for rendering, bat for fzf preview)
mdv() {
  local file
  if [ $# -eq 0 ]; then
    file=$(find . -name '*.md' -not -path '*/node_modules/*' -not -path '*/.git/*' | fzf --preview 'bat --color=always --style=numbers --language=md {}')
    [ -z "$file" ] && return
  else
    file="$1"
  fi
  glow -w 0 -p "$file"
}
```

# 使い方

```bash
# 引数なし: fzfでカレントディレクトリ以下の.mdファイルをインタラクティブに選択
mdv

# 引数あり: 直接表示
mdv README.md
```

引数なしで実行すると、fzfが起動してファイルを絞り込める。右ペインにbatによるプレビューも表示される。

# ツール使い分けのポイント

| 用途 | ツール | 理由 |
|------|--------|------|
| メイン閲覧 | glow | テーブル・見出しをレンダリング、日本語の幅計算が正確 |
| fzfプレビュー | bat | 軽快、シンタックスハイライトで視認性良好 |

# glowのオプション

- `-p`: 内蔵ページャーを使用（`less`を通さないのでカラー問題なし）
- `-w 0`: ワードラップ無効（wide表示、テーブルの折り返しを防ぐ）

# 課題

- **行番号表示**: glowのページャーモード(`-p`)では行番号を表示できない。`-l`オプションはTUIモード(`-t`)限定
