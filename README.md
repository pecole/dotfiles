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
(OS別: `Darwin` / `Linux`。必要になったら作成する。既定では Base のみ) に

```
<リポジトリ内の相対パス>    <リンク先のパス>
```

を追記して `link.sh` を再実行する。

## 補足

- GUIアプリ (cask) はMacのみ。LinuxではCLIツールだけインストールされる
- マシン固有のzsh設定 (APIキーなど) はgit管理外の `~/.zsh_local` に書く
- zshの生成物はリポジトリ内に作らず、以下に出力される
  - `~/.cache/zsh/` — `brew shellenv` / `sheldon source` / `starship init` /
    `fzf --zsh` / `gh completion` のキャッシュと `compinit` のダンプ
  - `~/.local/state/zsh/history` — コマンド履歴
  - キャッシュは元コマンドが更新されると自動で再生成される。
    手動でやり直す場合は `rm -rf ~/.cache/zsh` してシェルを開き直す
