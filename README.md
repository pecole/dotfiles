# dotfiles

Mac / Linux 対応の dotfiles。

## セットアップ

```sh
git clone https://github.com/pecole/dotfiles.git
cd dotfiles
./scripts/setup.sh
```

`setup.sh` は以下をまとめて実行する。

1. `link.sh` — `dotfiles/linklist.*.txt` に従ってシンボリックリンクを作成
   (リンク先に実ファイルがあれば `~/.dotfiles.bak/<日時>/` に退避)
2. `install.sh` — Homebrewと `~/.Brewfile` のパッケージをインストール
   (LinuxではHomebrewの前提パッケージを apt / dnf / pacman で入れてからLinuxbrewを使用)
3. ログインシェルをzshに変更
4. Neovimプラグインを `lazy-lock.json` の状態に復元

## 個別実行

| スクリプト | 内容 |
|---|---|
| `scripts/link.sh` | シンボリックリンクの作成のみ |
| `scripts/unlink.sh` | シンボリックリンクの削除 |
| `scripts/install.sh` | パッケージのインストールのみ (要 `~/.Brewfile`) |

## リンクの追加

`dotfiles/linklist.Base.txt` (OS共通) または `dotfiles/linklist.<uname -s>.txt`
(OS別: `Darwin` / `Linux`) に

```
<リポジトリ内の相対パス>    <リンク先のパス>
```

を追記して `link.sh` を再実行する。

## 補足

- GUIアプリ (cask) はMacのみ。LinuxではCLIツールだけインストールされる
- マシン固有のzsh設定 (APIキーなど) はgit管理外の `~/.zsh_local` に書く
