;;; pkg.el --- Package configuration

;;; Commentary:
;; Includes and configures all language-agnostic packages.

;;; Code:


;; Text completion framework. Uses pluggable back-ends and front-ends to
;; retrieve and display completion candidates.
;; https://github.com/company-mode/company-mode
(use-package company
  :ensure   t
  :diminish company-mode
  :config
  (setq company-idle-delay            0.4
        company-minimum-prefix-length 3
        company-echo-delay            0
        company-show-numbers          t
        company-transformers          '(company-sort-by-occurrence))
  (add-hook 'after-init-hook #'global-company-mode)
  :bind
  (:map company-active-map
        ("C-n" . company-select-next)
        ("C-p" . company-select-previous)
        ("M-<" . company-select-first)
        ("M->" . company-select-last))
  (:map company-mode-map
    ("<tab>" . tab-indent-or-complete)
    ("TAB"   . tab-indent-or-complete)))

;; Useful improvements to default keyboard shortcuts.
;; https://github.com/bbatsov/crux
(use-package crux
  :ensure t
  :bind
  ("C-a"     . crux-move-beginning-of-line)
  ("C-k"     . crux-smart-kill-line)
  ("C-c d"   . crux-duplicate-current-line-or-region)
  ("C-c f"   . crux-recentf-find-file)
  ("C-c n"   . crux-cleanup-buffer-or-region)
  ("C-x C-l" . crux-downcase-region)
  ("C-x C-u" . crux-upcase-region))

;; Don't display minor modes in the mode line.
;; https://github.com/emacsmirror/diminish
(use-package diminish
  :ensure t)

;; On-the-fly syntax checking.
;; https://github.com/flycheck/flycheck
(use-package flycheck
  :ensure   t
  :diminish flycheck-mode
  :config
  (setq flycheck-standard-error-navigation nil)
  (add-hook 'after-init-hook #'global-flycheck-mode))

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

;; Highlight the current line. The default settings can cause some strange
;; visual effects in vterm, so only use it in programming or text modes.
(use-package hl-line
  :custom-face
  (hl-line ((t (:background "#2F333B"))))
  :config
  (add-hook 'prog-mode-hook #'hl-line-mode)
  (add-hook 'text-mode-hook #'hl-line-mode))

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

;; The one and only true git integration.
;; https://github.com/magit/magit
(use-package magit
  :ensure t)

;; Display the minimap on the right hand side of the buffer.
;; https://github.com/dengste/minimap
(use-package minimap
  :ensure t
  :config
  (setq minimap-width-fraction  0.1
        minimap-minimum-width   20
        minimap-window-location 'right
        minimap-update-delay    0.05
        minimap-recenter-type   'free
        minimap-hide-fringes    t))

;; Rainbow delimiters!
;; https://github.com/Fanael/rainbow-delimiters
(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

;; A better solution for incremental narrowing.
;; https://github.com/radian-software/selectrum
(use-package selectrum
  :ensure t
  :config
  (selectrum-mode +1))

;; Sorting and filtering of list candidates.
;; https://github.com/radian-software/prescient.el
(use-package selectrum-prescient
  :ensure t
  :config
  (prescient-persist-mode +1)
  (selectrum-prescient-mode +1))

;; Insert/delete parens in pairs, highlight pairs, etc. General quality of life
;; improvements.
;; https://github.com/Fuco1/smartparens
(use-package smartparens
  :ensure   t
  :diminish smartparens-mode
  :config
  (progn
    (require 'smartparens-config)
    (smartparens-global-mode)
    (show-paren-mode)))

;; Save buffers when focus is lost.
;; https://github.com/bbatsov/super-save
(use-package super-save
  :ensure t
  :config
  (super-save-mode +1))

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

;; A fully-fledged terminal emulator inside GNU Emacs based on libvterm
;; https://github.com/akermu/emacs-libvterm/
(use-package vterm
  :ensure t)

;; Show keystroke suggestions.
;; https://github.com/justbur/emacs-which-key
(use-package which-key
  :ensure   t
  :diminish which-key-mode
  :config
  (which-key-mode))

;; A template system for Emacs.
;; https://github.com/joaotavora/yasnippet
(use-package yasnippet
  :ensure t
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'text-mode-hook 'yas-minor-mode))


(provide 'pkg)
;;; pkg.el ends here
