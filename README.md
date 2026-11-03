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

iTerm2 の設定は `iterm2/com.googlecode.iterm2.plist` で管理する。iTerm2 は終了時に
設定を書き戻すので、読み込み先を切り替える `post_install_darwin.sh` は iTerm2 を
終了した状態で実行する。

`Brewfile.sh` の `mas install` は App Store にサインインしていて、購入履歴に入って
いるアプリしか入らない。
