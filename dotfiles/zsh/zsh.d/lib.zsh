# .zshrc から読み込まれる共通関数

# eval 結果や compinit のダンプを置くキャッシュディレクトリ
# ここに置いたファイルは source / zcompile されるため、
# 他ユーザーから書き込めない権限で作る
: ${ZSH_CACHE_DIR:=${XDG_CACHE_HOME:-$HOME/.cache}/zsh}
[[ -d $ZSH_CACHE_DIR ]] || mkdir -p -m 700 "$ZSH_CACHE_DIR"


# コマンドの出力をファイルにキャッシュして source する。
# 依存ファイル(コマンド本体や設定ファイル)より新しければ再生成しない。
#   $1: キャッシュ名  $2: 依存ファイル  $3以降: 出力を生成するコマンド
__cache_eval() {
  local name=$1 dep=$2
  shift 2

  local cache=$ZSH_CACHE_DIR/$name.zsh
  if [[ ! -s $cache || $cache -ot $dep ]]; then
    if "$@" >| "$cache.new" 2>/dev/null && [[ -s $cache.new ]]; then
      mv -f "$cache.new" "$cache"
      # zsh は同名の .zwc があればそちらを読むのでコンパイルしておく
      zcompile "$cache" 2>/dev/null
    else
      # 生成に失敗したらキャッシュを諦めてその場で評価する
      rm -f "$cache.new"
      eval "$("$@" 2>/dev/null)"
      return
    fi
  fi
  source "$cache"
}


# zsh-defer があれば遅延実行し、無ければその場で実行する
__defer() {
  if (( $+functions[zsh-defer] )); then
    zsh-defer "$@"
  else
    "$@"
  fi
}


# インストール済みのHomebrewをPATHに通す
# 候補の並びは scripts/common.sh の __load_brew と揃えること
__load_brew() {
  local brew
  for brew in /opt/homebrew/bin/brew /usr/local/bin/brew \
              /home/linuxbrew/.linuxbrew/bin/brew $HOME/.linuxbrew/bin/brew; do
    if [[ -x $brew ]]; then
      __cache_eval brew-shellenv "$brew" "$brew" shellenv
      return 0
    fi
  done
  return 1
}


# 補完の初期化 (sheldon の plugins.toml から zsh-defer 経由で呼ばれる)
# compinit は fpath 内に他ユーザーが書き込めるディレクトリが無いかを検査する。
# -C で省略できるが節約は約2.5msに過ぎず、しかも zsh-defer で遅延実行されるため
# 体感には影響しない。安全側に倒して毎回検査する
__compinit() {
  local dump=$ZSH_CACHE_DIR/zcompdump

  autoload -Uz compinit
  compinit -d "$dump"

  if [[ ! -s ${dump}.zwc || ${dump}.zwc -ot $dump ]]; then
    zcompile "$dump" 2>/dev/null
  fi
}


# zenoのキーバインド (zeno本体の読み込み後に呼ぶ必要がある)
__zeno_bindkeys() {
  [[ -n $ZENO_LOADED ]] || return 0
  bindkey '^m' zeno-auto-snippet-and-accept-line
  bindkey '^i' zeno-completion
  bindkey '^g' zeno-ghq-cd
  bindkey '^r' zeno-history-selection
  bindkey '^x' zeno-insert-snippet
}
