# dotfiles

Mac / Linux 用の設定ファイル集。

「dotfiles」とは、`.zshrc` のようにドットで始まる設定ファイルのこと。
それらをこのリポジトリにまとめて置き、ホームディレクトリからは
**シンボリックリンク**（ショートカットのようなもの）で参照する。

こうすると設定を git で管理でき、新しいマシンでも同じ環境をすぐ再現できる。

```
このリポジトリ                              ホームディレクトリ
dotfiles/zsh/.zshenv    <────リンク────    ~/.zshenv
dotfiles/nvim/.config/nvim  <──リンク───   ~/.config/nvim
```

## セットアップ

```sh
git clone https://github.com/pecole/dotfiles.git
cd dotfiles
./scripts/setup.sh
```

`setup.sh` は次の4つを順に実行する。

| 順番 | 内容 |
|---|---|
| 1 | `link.sh` — 設定ファイルへのリンクを作る |
| 2 | `install.sh` — Homebrew とパッケージを入れる |
| 3 | ログインシェルを zsh に変える |
| 4 | Neovim のプラグインを `lazy-lock.json` の通りに入れる |

リンクを作る場所に本物のファイルがあった場合は、消さずに
`~/.dotfiles.bak/<日時>/` へ退避してからリンクを作る。

## 個別に実行する

| スクリプト | 内容 |
|---|---|
| `scripts/link.sh` | リンクを作るだけ |
| `scripts/unlink.sh` | リンクを消すだけ（このリポジトリを指すものだけ） |
| `scripts/install.sh` | パッケージを入れるだけ（要 `~/.Brewfile`） |

## ディレクトリ構成

```
dotfiles/
├── README.md
├── linklist.Base.txt      … 何をどこにリンクするかの一覧
│
├── scripts/               … セットアップ用のスクリプト
│   ├── setup.sh           …   まとめて実行する入り口
│   ├── link.sh            …   リンクを作る
│   ├── unlink.sh          …   リンクを消す
│   ├── install.sh         …   パッケージを入れる
│   └── common.sh          …   上記が共通で使う関数
│
└── dotfiles/              … 実際の設定ファイル
    ├── zsh/               … シェル
    ├── nvim/              … エディタ (Neovim)
    ├── sheldon/           … zsh プラグインの一覧
    ├── starship/          … プロンプトの見た目
    ├── wezterm/           … ターミナル
    ├── zeno/              … zsh の入力補助
    └── homebrew/          … 入れるパッケージの一覧 (.Brewfile)
```

## zsh の設定が読み込まれる順番

```
~/.zshenv               … 設定の置き場所 (~/.zsh.d) を教えるだけ
  └ ~/.zsh.d/.zshenv    … zsh を起動するたびに必ず必要なもの (環境変数など)
  └ ~/.zsh_local        … このマシンだけの設定 (git 管理外)

~/.zsh.d/.zshrc         … ターミナルを開いたときだけ必要なもの
  └ ~/.zsh.d/lib.zsh        … .zshrc が使う共通関数
  └ ~/.zsh.d/homebrew.zsh   … Homebrew があるときだけ読む設定
```

起動を速くするため、`brew shellenv` や `starship init` のように
毎回同じ結果になるコマンドは、出力を `~/.cache/zsh/` に保存して使い回す。
元のコマンドが新しくなると自動で作り直される。

また、すぐには要らない処理（補完の準備など）はプロンプトを表示した後に回している。

## Neovim の設定が読み込まれる順番

```
init.lua                … 読み込む順番を決めるだけ
  ├ lua/base.lua        … 使わない機能を切るなど、最初に決めたいこと
  ├ lua/autocmds.lua    … 保存時など、自動で動く処理
  ├ lua/options.lua     … 見た目や動作の設定
  ├ lua/keymaps.lua     … キーの割り当て
  ├ lua/commands.lua    … 自作コマンド
  └ lua/lazy_nvim.lua   … プラグイン管理
      └ lua/plugins/*.lua   … プラグインごとの設定
```

プラグインは必要になるまで読み込まない設定にしてあるため、
起動時に読み込まれるのは配色など最小限だけになっている。

## リンクを追加する

`dotfiles/linklist.Base.txt` に1行追加して `link.sh` を実行し直す。

```
<リポジトリ内の相対パス>    <リンクを作る場所>
```

OS ごとに分けたい場合は `dotfiles/linklist.Darwin.txt`（Mac）や
`dotfiles/linklist.Linux.txt` を作る。無ければ読み飛ばされる。

## バージョンの固定

同じ環境を再現できるよう、プラグインは使うバージョンを記録している。

| 対象 | 記録先 | 更新のしかた |
|---|---|---|
| Neovim のプラグイン | `dotfiles/nvim/.config/nvim/lazy-lock.json` | `:Lazy update` |
| zsh のプラグイン | `dotfiles/sheldon/.config/sheldon/plugins.toml` の `rev` | ファイル先頭のコメント参照 |

zsh のプラグインはターミナルを開くたびに読み込まれるので、
意図しない変更が入らないようコミットを固定している。

## 補足

- GUI アプリ（cask）は Mac のみ。Linux ではコマンドラインツールだけ入る
- API キーなど公開したくない設定は、git 管理外の `~/.zsh_local` に書く
- zsh が作るファイルはリポジトリの外に出している
  - `~/.cache/zsh/` — コマンド出力のキャッシュと補完のデータ
  - `~/.local/state/zsh/history` — コマンド履歴
  - キャッシュを作り直したいときは `rm -rf ~/.cache/zsh` してターミナルを開き直す
