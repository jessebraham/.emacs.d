;; A powerful and flexible file tree project explorer.
;; https://github.com/Alexander-Miller/treemacs
(use-package treemacs
  :ensure t
  :defer  t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-silent-filewatch t
          treemacs-silent-refresh   t
          treemacs-width            40)
    (treemacs-resize-icons 20))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-all-the-icons
  :ensure t
  :after
  (treemacs all-the-icons)
  :config
  (treemacs-load-theme "all-the-icons"))

(use-package treemacs-magit
  :ensure t
  :after
  (treemacs magit))
