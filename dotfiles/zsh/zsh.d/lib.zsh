# =============================================================================
# .zshrc から使う共通関数をまとめたファイル
#
# ここで定義した関数は .zshrc の中だけで使う。
# 名前が "__" で始まっているのは、普段使うコマンドと名前がぶつからないため。
# =============================================================================


# -----------------------------------------------------------------------------
# キャッシュの置き場所
#
# zsh は起動のたびに brew や starship などのコマンドを実行して、その出力を
# 設定として読み込む。毎回実行すると遅いので、結果をファイルに保存しておく。
# その保存先がこのディレクトリ。
#
# ここに置いたファイルは「そのまま実行される」ので、他人に書き換えられると
# 危険。自分だけが読み書きできる権限 (700) で作る。
# -----------------------------------------------------------------------------
: ${ZSH_CACHE_DIR:=${XDG_CACHE_HOME:-$HOME/.cache}/zsh}
[[ -d $ZSH_CACHE_DIR ]] || mkdir -p -m 700 "$ZSH_CACHE_DIR"


# -----------------------------------------------------------------------------
# そのコマンドが使えるか調べる
#
#   使い方: if __has_command git; then ... fi
#
# $commands は「コマンド名 → 実行ファイルのパス」を持つ zsh の連想配列。
# $+commands[git] は「その名前が登録されていれば 1、なければ 0」になる。
# which や command -v と違って別プロセスを起動しないので速い。
# -----------------------------------------------------------------------------
__has_command() {
  (( $+commands[$1] ))
}


# -----------------------------------------------------------------------------
# コマンドの出力をキャッシュして読み込む
#
#   使い方: __load_cached <キャッシュ名> <更新チェック用ファイル> <コマンド...>
#   例:     __load_cached starship "$commands[starship]" starship init zsh
#
# 「starship init zsh」の出力は starship 本体が変わらない限り毎回同じ。
# だから一度ファイルに保存しておいて、次からはそれを読むだけにする。
#
# <更新チェック用ファイル> より キャッシュが古ければ作り直す。
# 例えば starship を新しくすると実行ファイルの日付が新しくなるので、
# キャッシュが自動で作り直される。
# -----------------------------------------------------------------------------
__load_cached() {
  local cache_name=$1
  local watch_file=$2
  shift 2                      # 残りの引数 ($@) が実行するコマンドになる

  local cache_file=$ZSH_CACHE_DIR/$cache_name.zsh

  # キャッシュが無い、または更新チェック用ファイルより古いなら作り直す
  if [[ ! -s $cache_file || $cache_file -ot $watch_file ]]; then

    # まず一時ファイルに書き出し、成功したときだけ本番のファイルと入れ替える
    # (途中で失敗した中身が残らないようにするため)
    if "$@" >| "$cache_file.new" 2>/dev/null && [[ -s $cache_file.new ]]; then
      mv -f "$cache_file.new" "$cache_file"

      # zsh は同じ名前の .zwc (コンパイル済みファイル) があればそちらを読む。
      # 読み込みが少し速くなるので作っておく
      zcompile "$cache_file" 2>/dev/null
    else
      # 作れなかったときはキャッシュを諦めて、その場でコマンドを実行して読み込む
      rm -f "$cache_file.new"
      eval "$("$@" 2>/dev/null)"
      return
    fi
  fi

  source "$cache_file"
}


# -----------------------------------------------------------------------------
# 「あとで」実行する
#
#   使い方: __run_later source ~/somefile.zsh
#
# 重い処理を起動時にまとめて実行するとプロンプトが出るまで待たされる。
# zsh-defer を使うと「プロンプトを出したあと、暇なときに実行」に回せるので、
# 体感の起動が速くなる。
#
# zsh-defer はプラグインなので、まだ読み込まれていない場合もある。
# そのときは仕方ないのでその場で実行する。
#
# 注意: zsh-defer は登録した順に実行される。順番に意味がある処理
#       (補完の準備 → 補完を使う設定、など) は登録の順番に気をつけること。
# -----------------------------------------------------------------------------
__run_later() {
  if (( $+functions[zsh-defer] )); then
    zsh-defer "$@"
  else
    "$@"
  fi
}


# -----------------------------------------------------------------------------
# Homebrew を使えるようにする
#
# Homebrew の場所は環境によって違うので、上から順に探して最初に見つかった
# ものを使う。
#   /opt/homebrew          … Apple Silicon の Mac
#   /usr/local             … Intel の Mac
#   /home/linuxbrew, ~/    … Linux (Linuxbrew)
#
# 見つかったら `brew shellenv` を実行する。これは PATH などを設定するための
# コマンドで、出力をキャッシュして使う。
#
# ※ 探す場所の並びは scripts/common.sh の __load_brew と揃えること
# -----------------------------------------------------------------------------
__setup_homebrew() {
  local brew_path
  for brew_path in /opt/homebrew/bin/brew \
                   /usr/local/bin/brew \
                   /home/linuxbrew/.linuxbrew/bin/brew \
                   $HOME/.linuxbrew/bin/brew; do
    if [[ -x $brew_path ]]; then
      __load_cached brew-shellenv "$brew_path" "$brew_path" shellenv
      return 0    # 見つかった
    fi
  done
  return 1        # 見つからなかった
}


# -----------------------------------------------------------------------------
# 補完機能を準備する (Tabキーでコマンドの候補が出るようにする)
#
# この関数は sheldon の plugins.toml から __run_later 経由で呼ばれる。
#
# compinit は補完の準備をするコマンド。このとき「補完定義の置き場所に、
# 他人が書き換えられるディレクトリが混じっていないか」も検査する。
# -C を付けるとその検査を省略できるが、速くなるのは約2.5msだけで、
# しかもあとで実行される処理なので体感は変わらない。
# 安全を優先して毎回検査する。
# -----------------------------------------------------------------------------
__setup_completion() {
  local dump_file=$ZSH_CACHE_DIR/zcompdump

  autoload -Uz compinit
  compinit -d "$dump_file"

  # 補完定義は量が多いので、コンパイルしておくと次回の読み込みが速くなる
  if [[ ! -s ${dump_file}.zwc || ${dump_file}.zwc -ot $dump_file ]]; then
    zcompile "$dump_file" 2>/dev/null
  fi
}


# -----------------------------------------------------------------------------
# zeno のキー割り当て
#
# zeno は「gs と打つと git status に展開」のような入力補助プラグイン。
# zeno 本体があとから読み込まれるので、キー割り当ても同じタイミングで行う。
# ZENO_LOADED は zeno 本体が読み込まれたときに設定される目印。
# -----------------------------------------------------------------------------
__setup_zeno_keys() {
  [[ -n $ZENO_LOADED ]] || return 0   # zeno が無ければ何もしない

  bindkey '^m' zeno-auto-snippet-and-accept-line  # Enter    展開して実行
  bindkey '^i' zeno-completion                    # Tab      補完
  bindkey '^g' zeno-ghq-cd                        # Ctrl-g   リポジトリへ移動
  bindkey '^r' zeno-history-selection             # Ctrl-r   履歴から検索
  bindkey '^x' zeno-insert-snippet                # Ctrl-x   スニペット挿入
}
