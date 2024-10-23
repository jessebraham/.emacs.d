;; Highlight FIXME, NOTE, and TODO in comments.
;; https://github.com/tarsius/hl-todo
(use-package hl-todo
  :ensure t
  :config
  (setq hl-todo-keyword-faces
        '(("FIXME" . "#FF6C6B")
          ("NOTE"  . "#E6C07B")
          ("TODO"  . "#C678DD")))
  (add-hook 'prog-mode-hook #'hl-todo-mode)
  (add-hook 'text-mode-hook #'hl-todo-mode))
