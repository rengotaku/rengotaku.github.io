---
title: "CLIでMarkdownファイルをリッチに閲覧する設定（bat + fzf）"
tags: ["cli", "markdown", "bat", "fzf", "zsh"]
---

# 背景
ターミナルでMarkdownファイルを読みたい場面は多いが、`cat`だと装飾なしで読みにくい。
`glow`を試したが、`less`を通すとカラーが消える・テーブルが改行される等の問題があった。

最終的に**bat + fzf**の組み合わせに落ち着いた。

# 必要なツール

```bash
brew install bat fzf
```

- **bat**: シンタックスハイライト + 行番号 + ページャー内蔵の`cat`代替
- **fzf**: ファジーファインダー（インタラクティブなファイル選択）

# 設定

`~/.zsh_aliases`などに以下を追加:

```bash
# Markdown viewer
mdv() {
  local file
  if [ $# -eq 0 ]; then
    file=$(find . -name '*.md' -not -path '*/node_modules/*' -not -path '*/.git/*' | fzf --preview 'bat --color=always --style=numbers --language=md {}')
    [ -z "$file" ] && return
  else
    file="$1"
  fi
  bat --style=numbers --language=md "$file"
}
```

# 使い方

```bash
# 引数なし: fzfでカレントディレクトリ以下の.mdファイルをインタラクティブに選択
mdv

# 引数あり: 直接表示
mdv README.md
```

引数なしで実行すると、fzfが起動してファイルを絞り込める。右ペインにプレビューも表示される。

# glowではなくbatを選んだ理由

`glow`はMarkdownのレンダリングが美しいが、以下の点で不便だった:

- **テーブルが折り返される**: `-w`で幅指定は可能だが、ページャーと相性が悪い
- **lessを通すとカラーが消える**: `less -R`で回避可能だが、行番号付与（`cat -n`）と併用すると崩れる

`bat`はシンタックスハイライト・行番号・ページャーが一体になっており、追加の工夫が不要。

# lessの便利なキー操作

`bat`のデフォルトページャーは`less`なので、覚えておくと便利:

| キー | 動作 |
|------|------|
| `スペース` / `b` | 1ページ進む / 戻る |
| `d` / `u` | 半ページ進む / 戻る |
| `/検索語` | 前方検索 |
| `n` / `N` | 次 / 前の検索結果 |
| `g` / `G` | 先頭 / 末尾 |
| `50g` | 50行目へジャンプ |
| `q` | 終了 |
