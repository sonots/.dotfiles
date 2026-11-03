#!/bin/bash

# logout is required to reflect
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 15
# Show hidden files on Finder
defaults write com.apple.finder AppleShowAllFiles TRUE

# Command+Space でも入力ソースを切り替える（Control+Space は標準のまま残す）
# AppleSymbolicHotKeys はアクションごとの数値 ID がキー。
#   60=前の入力ソースを選択 / 61=入力メニューの次のソースを選択 / 64=Spotlight検索
# parameters は [文字コード, キーコード, 修飾キーのビットマスク]。1048576 が Command。
# 入力ソースが2つなら 60 と 61 は同じトグル動作になるので、60 の Control+Space を
# 残したまま 61 に Command+Space を割り当てる。
# Spotlight が Command+Space を握っていると競合するので先に無効化する。
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 \
  "<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>49</integer><integer>1048576</integer></array><key>type</key><string>standard</string></dict></dict>"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 \
  "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>1048576</integer></array><key>type</key><string>standard</string></dict></dict>"
# これを呼ばないとログアウトまで反映されない
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

# Trackpad: ナチュラルなスクロールを OFF
defaults write -g com.apple.swipescrolldirection -bool false
# F1, F2 などを標準のファンクションキーとして使う（F7 でカタカナ変換したいため）
defaults write -g com.apple.keyboard.fnState -bool true
# 通知音と UI サウンドエフェクトを消す
defaults write -g com.apple.sound.beep.volume -float 0
defaults write -g com.apple.sound.uiaudio.enabled -int 0
# 起動音を消す。これは defaults ではなく NVRAM に入っている
sudo nvram StartupMute=%01

# 修飾キーのリマップ。ByHost の .GlobalPreferences に
# com.apple.keyboard.modifiermapping.<VendorID>-<ProductID>-0 として入る
# （0-0-0 は内部キーボード）。値は HID usage に 0x700000000 を足したもの。
# デバイス固有なので、キーボードを買い替えると ProductID が変わって効かなくなる。
# 反映には再ログインが必要。
caps_lock=30064771129
left_option=30064771298
left_command=30064771299
right_control=30064771300
right_option=30064771302
right_command=30064771303

# modmap <VendorID>-<ProductID>-0 <src> <dst> [<src> <dst> ...]
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

# 内部キーボード: CapsLock -> Control
modmap 0-0-0 "$caps_lock" "$right_control"
# Realforce 87: CapsLock -> Control、左右とも Option <-> Command を入れ替え
modmap 2131-273-0 \
  "$caps_lock" "$right_control" \
  "$left_option" "$left_command" \
  "$left_command" "$left_option" \
  "$right_option" "$right_command" \
  "$right_command" "$right_option"

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
  echo "$zsh_path" | sudo tee -a /etc/shells
fi
if [ "$SHELL" != "$zsh_path" ]; then
  chsh -s "$zsh_path"
fi
