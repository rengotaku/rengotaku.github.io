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
# 引数なし: VSCode風ブラウザ（左:ファイル一覧 / 右:プレビュー、Enterで全画面、Escで一覧に戻る）
# 引数あり: 直接表示
mdv() {
  if [ $# -ge 1 ]; then
    glow -w 0 -p "$1"
    return
  fi
  local file
  while true; do
    file=$(find . -name '*.md' -not -path '*/node_modules/*' -not -path '*/.git/*' |
      sed 's|^\./||' | sort |
      fzf --layout=reverse \
          --preview 'glow -w 0 {}' \
          --preview-window 'right:65%:wrap' \
          --header 'Enter: 全画面表示 / Esc: 終了' \
          --bind 'ctrl-/:change-preview-window(down:50%|right:65%)')
    [ -z "$file" ] && break
    glow -w 0 -p "$file"
  done
}
```

# 使い方

```bash
# 引数なし: VSCode風ブラウザで起動
mdv

# 引数あり: 直接表示
mdv README.md
```

## VSCode風ブラウザの操作

| キー | 動作 |
|------|------|
| 文字入力 | ファイル名をファジー検索 |
| `↑` / `↓` | ファイル選択を移動（右ペインのプレビューが連動） |
| `Enter` | 選択したファイルをglowで全画面表示 |
| `q` | 全画面表示から一覧に戻る |
| `Ctrl+/` | プレビュー位置の切り替え（右⇄下） |
| `Esc` | mdvを終了 |

引数なしで実行すると、左にファイル一覧、右にglowによるプレビューが表示される。
ファイルを選択するとプレビューがリアルタイムで切り替わり、Enterで全画面表示、qで一覧に戻れる。

# ツール使い分けのポイント

| 用途 | ツール | 理由 |
|------|--------|------|
| メイン閲覧（全画面） | glow | テーブル・見出しをレンダリング、日本語の幅計算が正確 |
| fzfプレビュー | glow | メイン閲覧と同じレンダリングで一貫性がある |

# glowのオプション

- `-p`: 内蔵ページャーを使用（`less`を通さないのでカラー問題なし）
- `-w 0`: ワードラップ無効（wide表示、テーブルの折り返しを防ぐ）

# 課題

- **行番号表示**: glowのページャーモード(`-p`)では行番号を表示できない。`-l`オプションはTUIモード(`-t`)限定
