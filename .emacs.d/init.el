;; ;;; M-x shell の設定

;; ;;; Cygwin の bash を使う場合
;(setq explicit-shell-file-name "bash.exe")
;(setq shell-file-name "sh.exe")
;(setq shell-command-switch "-c")
;(add-hook 'shell-mode-hook
;           (lambda ()
					;  (set-buffer-process-coding-system 'japanese-shift-jis-unix
					;    'japanese-shift-jis-unix)))
;(add-hook 'shell-mode-hook
;          (lambda ()
;            (set-buffer-process-coding-system 'japanese-shift-jis-unix
;                                              'japanese-shift-jis-unix)))
;(autoload 'ansi-color-for-comint-mode-on "ansi-color"
;          "Set `ansi-color-for-comint-mode' to t." t)
;(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
;(add-hook 'comint-output-filter-functions
;          'comint-watch-for-password-prompt)

;; ;;; Virtually UN*X!にある tcsh.exe を使う場合
;; (setq explicit-shell-file-name "tcsh.exe") 
;; (setq shell-file-name "tcsh.exe") 
;; (setq shell-command-switch "-c") 

;; ;;; WindowsNT に付属の CMD.EXE を使う場合。
;; (setq explicit-shell-file-name "CMD.EXE") 
;; (setq shell-file-name "CMD.EXE") 
;; (setq shell-command-switch "\\/c") 

;; ;;; eshell
; Change the default eshell prompt
;(setq eshell-prompt-function
;      (lambda ()
;         (concat
;          (eshell/pwd) "\n")))

;; ;;; shell
; hide the password prompt
(add-hook 'comint-output-filter-functions
          'comint-watch-for-password-prompt)
; process escape sequence
(autoload 'ansi-color-for-comint-mode-on "ansi-color"
          "Set `ansi-color-for-comint-mode' to t." t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; ChangeLog
(setq user-full-name "Naotoshi Seo")
(setq user-mail-address "sonots@gmail.com")

;; Always end a file with a newline
(setq require-final-newline t)

;; Stop at the end of the file, not just add lines
(setq next-line-add-newlines nil)

;; Stop make backup files ~
(setq make-backup-files nil)

;; Do not use tab character for indentation (Use Ctrl-q Tab to type tab)
(setq-default indent-tabs-mode nil)

;; Show a tab character with 4 spaces
(setq default-tab-width 4)

;; ツールバーとメニューバーを消す
;(tool-bar-mode -1)
(menu-bar-mode -1)

;; visible bell
(setq visible-bell 't)

;; 起動画面を消す
(setq inhibit-startup-message t)

;; 時計
(display-time)

;; C-hをバックスペース
(global-set-key "\C-h" 'backward-delete-char)

;; Set backspace C-h
;;(define-key function-key-map [backspace] [8])

;; Set C-h backspace 
;(put 'backspace 'ascii-character 8)
;(setq keyboard-translate-table
;"\^@\^A\^B\^C\^D\^E\^F\^G\^?\^I\^J\^K\^L\^M\^N\^O\^P\^Q\^R\^S\^T\^U\^V\
;\^W\^X\^Y\^Z\^[\^\\\^]\^^\^_ !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJK\
;LMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~\^H")

;; Emacs Load Path
(setq load-path (cons "~/.emacs.d" load-path))
(setq load-path (cons "~/.emacs.d/elisp" load-path))
(setq load-path (cons "~/.emacs.d/auto-install" load-path))
;; auto-install
(require 'auto-install)
(setq auto-install-directory "~/.emacs.d/auto-install/")
(auto-install-update-emacswiki-package-name t)

;; ruby-mode.el, etc
(autoload 'ruby-mode "ruby-mode" "Mode for editing ruby source files" t)
(setq auto-mode-alist (cons '("\\.rb$" . ruby-mode) auto-mode-alist))
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode)) interpreter-mode-alist))
(autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby" "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook '(lambda () (inf-ruby-keys)))
;; ruby-electric.el --- auto insert 'end' and '}'
;(require 'ruby-electric)
;(add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode t)))
;; ruby-indent
(setq ruby-indent-level 2)
(setq ruby-indent-tabs-mode nil)
;; ruby-block.el --- highlight the end
(require 'ruby-block)
(ruby-block-mode t)
(setq ruby-block-highlight-toggle t)

;; flymake for ruby
(require 'flymake)
;; Invoke ruby with '-c' to get syntax checking
(defun flymake-ruby-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "ruby" (list "-c" local-file))))
(push '(".+\\.rb$" flymake-ruby-init) flymake-allowed-file-name-masks)
(push '("Rakefile$" flymake-ruby-init) flymake-allowed-file-name-masks)
(push '("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3) flymake-err-line-patterns)
(add-hook
 'ruby-mode-hook
 '(lambda ()
    ;; Don't want flymake mode for ruby regions in rhtml files
    (if (not (null buffer-file-name)) (flymake-mode))
    ;; エラー行で C-c d するとエラーの内容をミニバッファで表示する
    (define-key ruby-mode-map "\C-cd" 'credmp/flymake-display-err-minibuf)))

(defun credmp/flymake-display-err-minibuf ()
  "Displays the error/warning for the current line in the minibuffer"
  (interactive)
  (let* ((line-no             (flymake-current-line-no))
         (line-err-info-list  (nth 0 (flymake-find-err-info flymake-err-info line-no)))
         (count               (length line-err-info-list))
         )
    (while (> count 0)
      (when line-err-info-list
        (let* ((file       (flymake-ler-file (nth (1- count) line-err-info-list)))
               (full-file  (flymake-ler-full-file (nth (1- count) line-err-info-list)))
               (text (flymake-ler-text (nth (1- count) line-err-info-list)))
               (line       (flymake-ler-line (nth (1- count) line-err-info-list))))
          (message "[%s] %s" line text)
          )
        )
      (setq count (1- count)))))

(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "/root/.emacs.d/elisp/ac-dict")
(ac-config-default)

;; auto-complete
(require 'auto-complete)
(global-auto-complete-mode t)
; Use C-n/C-p to select candidates
(define-key ac-complete-mode-map "\C-n" 'ac-next)
(define-key ac-complete-mode-map "\C-p" 'ac-previous)
; Stop completion by M-/
(define-key ac-complete-mode-map "\M-/" 'ac-stop)
; Completion by tab
(define-key ac-complete-mode-map "\t" 'ac-complete)
(define-key ac-complete-mode-map "\r" nil)
;; RSense
(setq rsense-home (expand-file-name "~/opt/rsense"))
(require 'rsense)

;; C-c .で rsense
(add-hook 'ruby-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c .") 'ac-complete-rsense)))
;; . や::を入力した直後にrsense
(add-hook 'ruby-mode-hook
         (lambda ()
           (add-to-list 'ac-sources 'ac-source-rsense-method)
           (add-to-list 'ac-sources 'ac-source-rsense-constant)))

(require 'linum)
(global-linum-mode t) 

;; windows.el
;; キーバインドを変更．
;; デフォルトは C-c C-w
;; 変更しない場合」は，以下の 3 行を削除する
(setq win:switch-prefix "\C-z")
(define-key global-map win:switch-prefix nil)
(define-key global-map "\C-z1" 'win-switch-to-window)
(require 'windows)
;; 新規にフレームを作らない
(setq win:use-frame nil)
(win:startup-with-window)
(define-key ctl-x-map "\C-c" 'see-you-again)
(define-key ctl-x-map "C" 'save-buffers-kill-emacs)
(resume-windows 0)

;; Move divided window using Met and the arrow keys
(require 'windmove)                        ; to load the package
;(windmove-default-keybindings)            ; default keybindings
(global-set-key "\C-\M-h" 'windmove-left)  ; use different keys
(global-set-key "\C-\M-j" 'windmove-down)  ; because putty disables
(global-set-key "\C-\M-k" 'windmove-up)    ; cursor keys
(global-set-key "\C-\M-l" 'windmove-right)
(setq windmove-wrap-around t)              ; wrap around

;; M-x shell on zsh
(autoload 'ansi-color-for-comint-mode-on "ansi-color"
  "Set `ansi-color-for-comint-mode' to t." t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; anything
(defvar org-directory "")
(require 'anything)
(require 'anything-config)
(global-set-key (kbd "C-x b") 'anything)
(setq anything-sources
      '(anything-c-source-buffers+
        anything-c-source-recentf
        anything-c-source-man-pages
        anything-c-source-emacs-commands
        anything-c-source-emacs-functions
        anything-c-source-files-in-current-dir
        ))
;(require 'anything-project)
;(global-set-key (kbd "C-u") 'anything-project)
(require 'anything-git-project)
(global-set-key (kbd "C-u") 'anything-git-project)
(setq anything-idle-delay 0.3)	; 候補を作って描写するまでのタイムラグ。デフォルトで 0.3
(setq anything-input-idle-delay 0.2) ; 文字列を入力してから検索するまでのタイムラグ。デフォルトで 0
(setq anything-candidate-number-limit 100) ; 表示する最大候補数。デフォルトで 50

;; revive.el
(autoload 'save-current-configuration "revive" "Save status" t)
(autoload 'resume "revive" "Resume Emacs" t)
(autoload 'wipe "revive" "Wipe emacs" t)
(define-key ctl-x-map "F" 'resume)                        ; C-x F で復元
(define-key ctl-x-map "K" 'wipe)                          ; C-x K で Kill
(add-hook 'kill-emacs-hook 'save-current-configuration)   ; 終了時に保存

;; mac
(setq mac-command-key-is-meta nil) 

;; minibuf-isearch
(require 'minibuf-isearch)
(require 'session)
(add-hook 'after-init-hook 'session-initialize)

;; package.el
(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(setq package-user-dir (concat user-emacs-directory "elpa"))
(package-initialize)

;; ack.el
(require 'ack)
(global-set-key (kbd "C-i") 'ack)

