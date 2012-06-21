;; original is http://d.hatena.ne.jp/yaotti/20101216/1292500323
;; patch from usk_t(https://gist.github.com/747399)

(require 'cl)
(require 'anything)

(defvar anything-git-project:exclude-args "--exclude .hg")

(defun check-target-is-exist-in-path (path target)
  "checking targetted file is exist in path.
  logic: (path = \"~/foo/bar/boo\", target = \".git\")
  1. create all candidates: path -> (\"~/foo/bar/boo\" \"~/foo/bar\" \"~/foo\" \"~\")
  2. search"
  (destructuring-bind (head . words) (split-string path"/")
    (let ((candidates
           (loop for word in words
                 with acc = head
                 unless (string-equal "" word)
                 do (setq acc (concat acc "/" word))
                 and collect acc into result
                 finally return (nreverse (cons head result)))))
      (lexical-let ((target target))
        (find target candidates
              :test (lambda (target path)
                      (file-exists-p (concat path "/" target))))))))

(defun anything-git-project:in-git-repository ()
  "if in git-repository return root path of one"
  (and default-directory
       (check-target-is-exist-in-path (file-truename default-directory) ".git")))

(defun anything-git-project:commad-to-buffer (bufname root command args)
  "notice: args is string. not list"
  (when (get-buffer bufname)
    (with-current-buffer bufname (erase-buffer)))
  (let* ((cmd (format "cd %s && %s %s %s" root command args
                      anything-git-project:exclude-args))
         (buf (get-buffer-create bufname)))
    (and root
         (with-current-buffer buf
           (insert (shell-command-to-string cmd))
           (current-buffer)))))

(defun anything-c-sources-git-project-for (root-dir)
  (loop for (header-fmt . command-args) in
        '(("Modified files (%s)" . "--modified")
          ("Untracked files (%s)" . "--others --exclude-standard")
          ("All files in this project (%s)" . ""))
        collect
        `((name . ,(format header-fmt root-dir))
          (init . (lambda ()
                    ;; update all project-files every time (it is heavy?)
                    (let* ((bufname (format " *%s*" ,header-fmt)) ;; slak-off
                           (buf (anything-git-project:commad-to-buffer 
                                 bufname ,root-dir "git ls-files" ,command-args)))
                      (anything-candidate-buffer buf))))
          (display-to-real . (lambda (c) (concat ,root-dir "/" c)))
          (candidates-in-buffer)
          (type . file))))

(defun anything-git-project ()
  (interactive)
  (let* ((git-root-dir (anything-git-project:in-git-repository))
         (sources (anything-c-sources-git-project-for git-root-dir))
         (any-buffer (format "*Anything git project in %s*" git-root-dir)))
    (and git-root-dir
         (anything-other-buffer sources any-buffer))))

;; (define-key global-map (kbd "C-;") 'anything-git-project)

(provide 'anything-git-project)