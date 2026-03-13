---
title: "VPNサーバーについて調べる - Tailscale入門"
tags: ["vpn", "tailscale", "wireguard", "networking"]
---

# Tailscaleとは

外出先からホームネットワークにアクセスするためのクラウド型P2P VPNツール。現時点で最も洗練されたP2P型のVPNツールの一つ。

## 主な特徴

### 1. 簡単な認証方式
- GoogleまたはMicrosoftアカウントでログイン
- ブラウザから機器の一覧取得、削除、共有などの管理が可能
- セットアップが非常に簡単

### 2. ポート開放不要
- VPN用のポートを外部に公開する必要がない
- P2P型のため、安全にVPNネットワークを構築可能
- 個人用途に最適

### 3. 豊富なプラットフォーム対応
以下のプラットフォームで動作確認済み：
- Windows 10 PC
- MacBook Pro
- iOS端末（iPad）
- Android端末
- Raspberry Pi
- クラウドサービス（VPS）
- WSL2 Ubuntu（特殊な起動方法が必要）

### 4. 技術仕様
- **VPNプロトコル**: Wireguard
- **P2P接続**: UDPホールパンチング（Skypeでも使用）
- **IPアドレス**: 100.x.x.x のプライベートIPアドレスを使用

## ユースケース

| 接続元 | アプリ | 接続先 | 用途 |
|--------|--------|--------|------|
| iPad | Microsoft Remote Desktop | Windows PC | リモートデスクトップ |
| Android | Termux | Raspberry Pi | SSH接続 |
| iPad | Prompt2 | Raspberry Pi | SSH接続 |
| Windows PC | VS Code | クラウドサーバー | リモートデバッグ |

## メリット

1. **認証が簡単** - Google/MSアカウントでログイン
2. **ポート開放不要** - P2P接続のため安全
3. **多様なプラットフォーム** - PC、モバイル、IoT機器など
4. **機器の共有機能** - 他のユーザーに機器へのアクセス権を付与可能

## 注意点

- 会社のPCでの使用は管理者の承認が必要
- アカウントは個人のGoogleアカウントに紐づく
- 組織利用には向いていない（現時点）

## 参考リンク

- [Tailscale公式サイト](https://tailscale.com/)
- [tailscaleで実現するかんたん・安全・便利なクラウド型VPN接続のカタチ - Qiita](https://qiita.com/delphinz/items/90df5c5ac21edaa777a1)
- [Tailscale解説動画](https://www.youtube.com/watch?v=sA55fcuJSQQ)

## 代替ツール

- **ZeroTier** - 同様のP2P VPNツール
