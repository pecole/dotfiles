# =============================================================================
# .zshrc — 対話シェル (人が操作するターミナル) を開くたびに読み込まれる設定
#
# 読み込まれる順番:
#   ~/.zshenv  →  ~/.zsh.d/.zshenv  →  ~/.zsh.d/.zshrc (このファイル)
#
# このファイルの構成:
#   1. 共通関数の読み込み
#   2. 外部ツールの設定 (Homebrew / プラグイン / mise / starship など)
#   3. PATH の仕上げ
#   4. zsh 自体の設定 (動作オプション・履歴・キー・エイリアス)
# =============================================================================


# =============================================================================
# 1. 共通関数の読み込み
# =============================================================================
# __has_command / __load_cached / __run_later / __setup_homebrew /
# __setup_completion / __setup_zeno_keys が使えるようになる
source "${ZDOTDIR}/lib.zsh"


# =============================================================================
# 2. 外部ツールの設定
# =============================================================================

# --- Homebrew -----------------------------------------------------------
# 見つかったら PATH などを設定し、Homebrew 関連の追加設定も読み込む
if __setup_homebrew; then
  source "${ZDOTDIR}/homebrew.zsh"
fi

# --- プラグイン (sheldon) ------------------------------------------------
# sheldon はプラグイン管理ツール。`sheldon source` が「どのプラグインを
# どう読み込むか」という zsh のコードを出力するので、それを読み込む。
# 出力は plugins.toml が変わらない限り同じなのでキャッシュする。
#
# ここで zsh-defer が読み込まれる。これ以降 __run_later が「あとで実行」
# として機能する。
if __has_command sheldon; then
  __load_cached sheldon "${XDG_CONFIG_HOME:-$HOME/.config}/sheldon/plugins.toml" \
    sheldon source
fi

# --- mise (言語バージョン管理) -------------------------------------------
# node や go のバージョンをディレクトリごとに切り替えるツール。
#
# 本体を有効にする処理は約19msかかるので、あとに回して起動を速くする。
# その代わり shims (バージョンを判断して本物に橋渡しする中継役) を
# 先に PATH へ入れておく。これは PATH に1行足すだけなので一瞬で終わり、
# 本体の準備が終わるまでの間も node や go が正しく動く。
[[ -d "$HOME/.local/share/mise/shims" ]] \
  && path=("$HOME/.local/share/mise/shims" $path)

__run_later __setup_mise

# --- あとで実行するもの ---------------------------------------------------
# ここから下の __run_later は登録した順に実行される。
# 補完の準備 (__setup_completion) は sheldon の設定内で登録済みなので、
# 補完を使うものはこの位置に書けば必ずその後に実行される。

# gcloud のコマンド補完 (読み込みに約90msかかるので後回しにする)
[[ -r $GCLOUD_COMPLETION_INC ]] && __run_later source "$GCLOUD_COMPLETION_INC"

# GitHub CLI (gh) のコマンド補完
__has_command gh && __run_later __load_cached gh-completion "$commands[gh]" \
  gh completion -s zsh

# fzf (あいまい検索ツール) のキー割り当てと補完
__has_command fzf && __run_later __load_cached fzf "$commands[fzf]" fzf --zsh

# zeno のキー割り当て (zeno 本体もあとから読み込まれる)
__run_later __setup_zeno_keys

# --- Rust (cargo) --------------------------------------------------------
# rustup が入れたコマンドを使えるようにする。
# (~/.cargo/env を読むのと同じことを、ファイルを開かずに行っている)
[[ -d "$HOME/.cargo/bin" ]] && path=("$HOME/.cargo/bin" $path)

# --- starship (プロンプト表示) -------------------------------------------
if __has_command starship; then
  __load_cached starship "$commands[starship]" starship init zsh
fi


# =============================================================================
# 3. PATH の仕上げ
# =============================================================================
# ここまでの処理で PATH に同じディレクトリが二重に入ることがある。
#
# .zshenv で `typeset -U path` (重複を持たない配列) にしてあるが、これは
# 配列に代入したときにしか効かない。gcloud の設定ファイルや mise は
#   export PATH='/a:/b:/a'
# のように文字列でまとめて代入するため、この形だと重複が残ってしまう。
#
# そこで PATH を触る処理をすべて終えたこの位置で、配列に入れ直して
# 重複を取り除く。$path と PATH は連動しているのでこれで両方きれいになる。
path=($path)


# =============================================================================
# 4. zsh 自体の設定
# =============================================================================

# --- 動作オプション -------------------------------------------------------
setopt autocd              # ディレクトリ名を打つだけで移動できる
setopt interactivecomments # 対話中でも # 以降をコメント扱いにする
setopt magicequalsubst     # --dir=~/foo のような書き方でも ~ を展開する
setopt nonomatch           # ワイルドカードが何にも一致しなくてもエラーにしない
setopt notify              # バックグラウンドジョブの終了をすぐ知らせる
setopt numericglobsort     # ファイル名を数字として自然な順に並べる
setopt promptsubst         # プロンプトの中でコマンド展開を使えるようにする
setopt auto_param_keys     # 変数名の補完時に括弧などを補う
#setopt correct            # コマンドのスペルミスを指摘する (今は無効)

# --- 履歴 -----------------------------------------------------------------
# 履歴ファイルはリポジトリの外 (~/.local/state/zsh/history) に置く。
# 過去に打ったコマンドが git に混ざらないようにするため
HISTFILE=${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history
[[ -d ${HISTFILE:h} ]] || mkdir -p "${HISTFILE:h}"
HISTSIZE=1000              # メモリ上に保持する件数
SAVEHIST=2000              # ファイルに保存する件数

setopt inc_append_history     # 実行するたびに履歴ファイルへ追記する
setopt share_history          # 複数のターミナル間で履歴を共有する
setopt hist_expire_dups_first # 上限を超えたらまず重複から削除する
setopt hist_ignore_dups       # 直前と同じコマンドは記録しない
setopt hist_ignore_space      # 行頭にスペースを入れたコマンドは記録しない
setopt hist_verify            # !! などの展開後、実行前に内容を見せる

# 引数なしの history は直近16件しか出さないので、全件出すようにする
alias history='history 1'

# --- キー割り当て ---------------------------------------------------------
bindkey -e   # Emacs風 (Ctrl-a で行頭、Ctrl-e で行末 など)

# --- エイリアス -----------------------------------------------------------
# ls の色付けオプションは macOS(BSD版) と Linux(GNU版) で違う
if [[ "$OSTYPE" == darwin* ]]; then
  alias ls='ls -GF'
else
  alias ls='ls -F --color=auto'
fi
alias la='ls -la'   # 隠しファイルも含めて詳細表示
alias ll='ls -l'    # 詳細表示

# vim と打っても nvim が起動するようにする
if __has_command nvim; then
  alias vim='nvim'
fi


# =============================================================================
# 起動時間の計測 (普段は動かない)
#
# 遅くなった原因を調べたいときは ~/.zshenv の先頭にある
#   # zmodload zsh/zprof
# のコメントを外してターミナルを開き直すと、下の行が結果を表示する。
# =============================================================================
(( $+builtins[zprof] )) && zprof
