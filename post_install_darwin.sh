#!/bin/bash

. ~/.dotfiles/_run.sh

# 書き込む値を前後で読み比べて、変わったときだけ最後に再ログインを促す。
# defaults write は同じ値を書いても中身は変わらないので、再実行では何も出ない。
# snap は「読めたら 値、読めなければ (未設定)」を一行で出す。defaults の
# エラー出力には時刻と PID が入るため、そのまま拾うと毎回差分になる。
snap() {
  local out
  if out=$("$@" 2>/dev/null); then
    printf '%s = %s\n' "$*" "$out"
  else
    printf '%s = (未設定)\n' "$*"
  fi
}
settings_snapshot() {
  snap defaults read com.apple.finder AppleShowAllFiles
  snap defaults read -g KeyRepeat
  snap defaults read -g InitialKeyRepeat
  snap defaults read -g com.apple.swipescrolldirection
  snap defaults read -g com.apple.keyboard.fnState
  snap defaults read -g com.apple.sound.beep.volume
  snap defaults read -g com.apple.sound.uiaudio.enabled
  snap nvram StartupMute
  snap defaults -currentHost read -g com.apple.keyboard.modifiermapping.0-0-0
  snap defaults -currentHost read -g com.apple.keyboard.modifiermapping.2131-273-0
  snap defaults read com.apple.symbolichotkeys AppleSymbolicHotKeys
  snap defaults read com.googlecode.iterm2 PrefsCustomFolder
  snap defaults read com.googlecode.iterm2 LoadPrefsFromCustomFolder
}
settings_before=$(settings_snapshot)

# Finder で隠しファイルを表示する。環境設定には無い。
defaults write com.apple.finder AppleShowAllFiles TRUE

# システム設定 > キーボード > 「キーのリピート速度」「リピート入力認識までの時間」
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 15

# システム設定 > トラックパッド > スクロールとズーム > 「ナチュラルなスクロール」をOFF
defaults write -g com.apple.swipescrolldirection -bool false
# システム設定 > キーボード > キーボードショートカット > ファンクションキー >
#   「F1、F2などのキーを標準のファンクションキーとして使用」（F7 でカタカナ変換したいため）
defaults write -g com.apple.keyboard.fnState -bool true
# 通知音、UI サウンドエフェクトと起動音を消す
# システム設定 > サウンド > 「通知音の音量」を0に。「ユーザインターフェースのサウンドエフェクトを再生」をOFF
defaults write -g com.apple.sound.beep.volume -float 0
defaults write -g com.apple.sound.uiaudio.enabled -int 0
# システム設定 > サウンド > 「起動時にサウンドを再生」
# これは defaults ではなく NVRAM に入っている
[ "$(nvram StartupMute 2>/dev/null | awk '{print $2}')" = "%01" ] \
  || run sudo nvram StartupMute=%01

# 修飾キーのリマップ。値は HID usage に 0x700000000 を足したもの。
caps_lock=30064771129
left_option=30064771298
left_command=30064771299
left_control=30064771296
right_option=30064771302
right_command=30064771303

# modmap <VendorID>-<ProductID>-0 <src> <dst> [<src> <dst> ...]
# 第1引数は ByHost の .GlobalPreferences に入るキー名
# com.apple.keyboard.modifiermapping.<VendorID>-<ProductID>-0 の末尾部分。
modmap() {
  local device=$1; shift
  local xml='<array>'
  while [ $# -ge 2 ]; do
    xml="${xml}<dict><key>HIDKeyboardModifierMappingSrc</key><integer>$1</integer>"
    xml="${xml}<key>HIDKeyboardModifierMappingDst</key><integer>$2</integer></dict>"
    shift 2
  done
  defaults -currentHost write -g "com.apple.keyboard.modifiermapping.${device}" "${xml}</array>"
}

# システム設定 > キーボード > キーボードショートカット > 修飾キー > 内部キーボード
# CapsLock -> Control
# 内部キーボードは 0-0-0
run modmap 0-0-0 "$caps_lock" "$left_control"
# システム設定 > キーボード > キーボードショートカット > 修飾キー > Realforce 87
# CapsLock -> Control、左右とも Option <-> Command を入れ替え
# Realforce 87。VendorID/ProductID 固有なので、キーボードを買い替えると効かなくなる。
run modmap 2131-273-0 \
  "$caps_lock" "$left_control" \
  "$left_option" "$left_command" \
  "$left_command" "$left_option" \
  "$right_option" "$right_command" \
  "$right_command" "$right_option"

# Command+Space でも入力ソースを切り替える（Control+Space は標準のまま残す）
# AppleSymbolicHotKeys はアクションごとの数値 ID がキー。60=前の入力ソースを選択 / 61=入力メニューの次のソースを選択 / 64=Spotlight検索
# parameters は [文字コード, キーコード, 修飾キーのビットマスク]。1048576 が Command。
# 入力ソースが2つなら 60 と 61 は同じトグル動作になるので、60 の Control+Space を残したまま 61 に Command+Space を割り当てる。
# Spotlight が Command+Space を握っていると競合するので先に無効化する。
# システム設定 > キーボード > キーボードショートカット >
#   Spotlight > 「Spotlight検索を表示」のチェックを外す
#   入力ソース > 「入力メニューの次のソースを選択」に Command+Space を割り当てる
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 \
  "<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>49</integer><integer>1048576</integer></array><key>type</key><string>standard</string></dict></dict>"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 \
  "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>1048576</integer></array><key>type</key><string>standard</string></dict></dict>"
# これを呼ばないとログアウトまで反映されない
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

# .ssh/config
if ! grep -q '^# .dotfiles/install.sh' $HOME/.ssh/config; then
  mkdir -p $HOME/.ssh
  cat <<EOF >> $HOME/.ssh/config
# .dotfiles/install.sh
Host *
  # UseKeychain yes
  AddKeysToAgent yes
  ForwardAgent yes
  ServerAliveInterval 15
  ServerAliveCountMax 10

# SSH over Session Manager
host i-* mi-*
  ProxyCommand sh -c "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"
EOF
 chmod 700 $HOME/.ssh
 chmod 600 $HOME/.ssh/config
fi

# change default shell to zsh
# Prefer homebrew zsh (Apple Silicon: /opt/homebrew, Intel: /usr/local),
# fall back to the system zsh.
if [ -x /opt/homebrew/bin/zsh ]; then
  zsh_path=/opt/homebrew/bin/zsh
elif [ -x /usr/local/bin/zsh ]; then
  zsh_path=/usr/local/bin/zsh
else
  zsh_path=/bin/zsh
fi
if ! grep -qx "$zsh_path" /etc/shells; then
  echo "$zsh_path" | run sudo tee -a /etc/shells
fi
if [ "$SHELL" != "$zsh_path" ]; then
  run chsh -s "$zsh_path"
fi

# iTerm2 の設定は iterm2/com.googlecode.iterm2.plist から読ませる。プロファイルの
# 設定（カラー、透過、Option キーの扱いなど）がそこに入っている。
# iTerm2 は終了時に設定を plist へ書き戻すため、起動中に読み込み先を変えても戻る
# 可能性がある。そのため起動中は変更せず警告だけ出す。
iterm2_prefs_dir="$HOME/.dotfiles/iterm2"
if [ "$(defaults read com.googlecode.iterm2 PrefsCustomFolder 2>/dev/null)" = "$iterm2_prefs_dir" ] \
   && [ "$(defaults read com.googlecode.iterm2 LoadPrefsFromCustomFolder 2>/dev/null)" = "1" ]; then
  : # 設定済み
elif pgrep -xq iTerm2; then
  echo "WARN: iTerm2 が起動中のため設定の読み込み先を変更できません。iTerm2 を終了してから実行してください。" >&2
else
  defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$iterm2_prefs_dir"
  defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
fi

# システム設定の GUI から変えた場合はその場で反映されるが、plist を直接書いた
# 場合は反映されないものがある（KeyRepeat で確認済み）。
if [ "$(settings_snapshot)" != "$settings_before" ]; then
  echo
  echo "設定値が変わりました。反映のためログアウトして再ログインしてください。"
fi
