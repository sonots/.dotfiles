# Supported Environments

* Linux
* Darwin (macOS)

# How to Initilaize

```
$ git clone git@github.com:sonots/.dotfiles
$ cd .dotfiles
$ ./install.sh
```

# macOS

iTerm2 の設定は `iterm2/com.googlecode.iterm2.plist` から読ませる。読み込み先を
切り替える `post_install_darwin.sh` は iTerm2 を終了した状態で実行する（起動中は
警告を出して飛ばす）。

`Brewfile.sh` の `mas install` は App Store にサインインしていて、購入履歴に入って
いるアプリしか入らない。
