#!/bin/bash
# 失敗しても止めずに最後まで走らせ、何が失敗したかを最後にまとめて出すための仕組み。
# 独立した手順が多く、1つコケても残りは進めたいので set -e は使わない。
#
# install.sh から呼ばれる子スクリプト（Brewfile.sh, post_install_*.sh）は別プロセス
# なので、失敗の記録はシェル変数ではなくファイルに書いて共有する。単独で実行された
# ときは自分でログを作り、終了時に自分で出す。

if [ -z "$DOTFILES_FAILED_LOG" ]; then
  DOTFILES_FAILED_LOG=$(mktemp)
  export DOTFILES_FAILED_LOG
  _dotfiles_report_on_exit() {
    local code=$?
    if [ -s "$DOTFILES_FAILED_LOG" ]; then
      echo >&2
      echo "以下が失敗しました:" >&2
      sed 's/^/  /' "$DOTFILES_FAILED_LOG" >&2
      code=1
    fi
    rm -f "$DOTFILES_FAILED_LOG"
    exit $code
  }
  trap _dotfiles_report_on_exit EXIT
fi

# run <command> [args...] : 失敗したらコマンド行を記録して続行する
run() {
  "$@" || echo "$*" >> "$DOTFILES_FAILED_LOG"
}
