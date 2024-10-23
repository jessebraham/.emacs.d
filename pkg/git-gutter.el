;; Display gutter icons for inserted, modified, and deleted lines.
;; https://github.com/emacsorphanage/git-gutter
(use-package git-gutter
  :ensure t
  :config
  (custom-set-variables
   '(git-gutter:modified-sign " *")
   '(git-gutter:added-sign    " +")
   '(git-gutter:deleted-sign  " -"))
  (set-face-foreground 'git-gutter:added    "#98BE65")
  (set-face-foreground 'git-gutter:modified "#E6C07B")
  (set-face-foreground 'git-gutter:deleted  "#FF6C6B")
  (add-hook 'prog-mode-hook #'git-gutter-mode)
  (add-hook 'text-mode-hook #'git-gutter-mode))
