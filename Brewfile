# Make sure using latest Homebrew
update

# Update already-installed formula (takes too much time, I will do it manually later)
# upgrade

# Add Repository
tap homebrew/versions || true
tap homebrew/binary || true
tap phinze/homebrew-cask || true
tap sonots/mycask || true

# Packages

install zsh
install git
install gist
install tig
install tmux
install ack
install ctags
install nkf
install lv
install wget
install tree
install pkg-config
install libtool
install cmake
install autoconf
install automake
install mosh
install markdown
install pidof # pidof
install proctools # pkill, pgrep, pfind
install rmtrash # `rmtrash` moves file to Trash
install reattach-to-user-namespace # http://yuzuemon.hatenablog.com/entry/20120222/1329841466 # http://qiita.com/yuku_t/items/bea95b1bc6e6ca8a495b
#install coreutils --default-names # http://takuya-1st.hatenablog.jp/entry/20111230/1325272152
#install imagemagick
#install packer
install brew-cask

# .dmg with homebrew-cask
cask install google-chrome
cask install firefox
cask install evernote
cask install skype
cask install iterm2
cask install limechat
cask install sublime-text
#cask install xquartz
#cask install wireshark
cask install kobito
cask install virtualbox
cask install vagrant
cask install echofon # mycask
cask install cot-editor # mycask

# Remove outdated versions
cleanup
