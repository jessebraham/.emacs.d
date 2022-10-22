;;; init.el --- A minimal-ish initialization file for Emacs.

;;; Commentary:
;; Simple configuration which sets some reasonable defaults and includes a
;; number of useful packages.

;;; Code:


;; ---------------------------------------------------------------------------
;; PACKAGE MANAGEMENT

(require 'package)
(setq package-enable-at-startup nil)

(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("melpa"  . "https://melpa.org/packages/")
        ("stable" . "https://stable.melpa.org/packages/")))

(package-initialize)

;; https://github.com/jwiegley/use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))


;; ---------------------------------------------------------------------------
;; GARBAGE COLLECTION

(defconst GC-CONS-THRESHOLD    250000000) ; 250MB
(defconst LARGE-FILE-THRESHOLD  50000000) ; 50MB

(setq gc-cons-threshold            GC-CONS-THRESHOLD
      large-file-warning-threshold LARGE-FILE-THRESHOLD)

(defun defer-garbage-collection ()
  "Defer garbage collection indefinitely, or rather until we restore it."
  (setq gc-cons-threshold most-positive-fixnum))

(defun restore-garbage-collection ()
  "Restore garbage collection with the configured threshold."
  (run-at-time
   1 nil (lambda () (setq gc-cons-threshold GC-CONS-THRESHOLD))))

(add-hook 'minibuffer-setup-hook #'defer-garbage-collection)
(add-hook 'minibuffer-exit-hook  #'restore-garbage-collection)


;; ---------------------------------------------------------------------------
;; EDITOR/INTERFACE TWEAKS

(setq backup-directory-alist        `((".*" . ,temporary-file-directory))
      auto-save-file-name-transform `((".*" ,temporary-file-directory t)))

;; Don't use double-spaces after periods (because I say so).
(setq sentence-end-double-space nil)

;; Scroll line-by-line rather than jumping around haphazardly.
(setq scroll-conservatively           10000
      scroll-margin                       0
      scroll-preserve-screen-position     1)

;; Whitespace settings:
;;  - tabs are 4 space characters (as the gods intended)
;;  - ensure a newline character is present at the end files when saving
;;  - clean up extraneous whitespace when saving
(setq-default indent-tabs-mode nil
              tab-width        4)
(setq require-final-newline t)
(add-hook 'before-save-hook 'whitespace-cleanup)

;; Open new windows to the right, not on the bottom.
(setq split-height-threshold nil
      split-width-threshold  0)

;; Don't require full yes/no answers, allow y/n instead.
(fset 'yes-or-no-p 'y-or-n-p)

;; Change the default font face and crank up that size!
(set-frame-font "Source Code Pro 16")

;; Enable various global modes/features:
;;  - automatically reload files if modified outside of the editor
;;  - display line numbers
;;  - prettify symbols (eg. lambda -> λ)
(global-auto-revert-mode)
(global-display-line-numbers-mode)
(global-prettify-symbols-mode)

;; Enable various modes/features:
;;  - display the line number and cursor column position in the mode line
;;  - overwrite selected text when typing
;;  - display the date and time (using 24h format) in the mode line
;;  - display the file size in the mode line
(column-number-mode)
(setq display-time-string-forms
      '((propertize (format-time-string "%F %H:%M %Z"))))
(delete-selection-mode)
(display-time-mode)
(size-indication-mode)

;; Display a ruler in the 80th column.
(setq-default display-fill-column-indicator-column 80)
(global-display-fill-column-indicator-mode)


;; ---------------------------------------------------------------------------
;; KEY BINDINGS

;; Globally un-set "C-z", which suspends Emacs by default (and is super
;; annoying!)
(global-unset-key (kbd "C-z"))

;; Make it easier to move between windows. Windows can be navigated using
;; <shift> in combination with the arrow keys.
(setq windmove-wrap-around t)
(windmove-default-keybindings)

;; Enable code folding in programming modes, and set some more reasonable
;; shortcuts.
(add-hook 'prog-mode-hook #'hs-minor-mode)
(global-set-key (kbd "C-c C-h") (kbd "C-c @ C-h")) ; Hide a block
(global-set-key (kbd "C-c C-s") (kbd "C-c @ C-s")) ; Show a block


;; ---------------------------------------------------------------------------
;; THEME

;; Use the 'doom-one' theme from the 'doom-themes' package.
;; https://github.com/hlissner/emacs-doom-themes/
(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold   t
        doom-themes-enable-italic t)
  (doom-themes-visual-bell-config)
  (load-theme 'doom-one t))

;; Modeline from doom.
;; https://github.com/seagle0128/doom-modeline
(use-package doom-modeline
  :ensure t
  :init   (doom-modeline-mode 1))


;; ---------------------------------------------------------------------------
;; PACKAGES

;; All of the icons!
; https://github.com/domtronn/all-the-icons.el
(use-package all-the-icons
  :ensure t)

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
  :config   (add-hook 'after-init-hook #'global-flycheck-mode))

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

;; Language server protocol support.
;; https://github.com/emacs-lsp/lsp-mode
(use-package lsp-mode
  :ensure t
  :commands lsp
  :custom
  (lsp-eldoc-render-all t)
  (lsp-idle-delay       0.6)
  ;; rust-analyzer configuration
  ;; https://emacs-lsp.github.io/lsp-mode/page/lsp-rust-analyzer/#available-configurations
  (lsp-rust-analyzer-cargo-watch-command                   "clippy")
  (lsp-rust-analyzer-display-chaining-hints                t)
  (lsp-rust-analyzer-display-closure-return-type-hints     t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
  (lsp-rust-analyzer-server-display-inlay-hints            t)
  :config
  (add-hook 'lsp-after-open-hook
            (lambda ()
              (when (lsp-find-workspace 'rust-analyzer nil)
                (set-face-attribute 'lsp-rust-analyzer-inlay-face
                                    nil
                                    :foreground "#797E81"
                                    :height     140
                                    :slant      'italic)))))

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
  :config (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

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

;; Distinguish "real" buffers from "unreal" buffers.
;; https://github.com/hlissner/emacs-solaire-mode
(use-package solaire-mode
  :ensure t
  :config
  (solaire-global-mode +1))

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
  :after  (treemacs all-the-icons)
  :ensure t
  :config
  (treemacs-load-theme "all-the-icons"))

(use-package treemacs-magit
  :after  (treemacs magit)
  :ensure t)

;; Show keystroke suggestions.
;; https://github.com/justbur/emacs-which-key
(use-package which-key
  :ensure   t
  :diminish which-key-mode
  :config   (which-key-mode))

;; A template system for Emacs.
;; https://github.com/joaotavora/yasnippet
(use-package yasnippet
  :ensure t
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'text-mode-hook 'yas-minor-mode))


;; ---------------------------------------------------------------------------
;; LANGUAGES

;; Fish shell
;; https://github.com/wwwjfy/emacs-fish
(use-package fish-mode
  :ensure t)

;; Racket
;; https://github.com/greghendershott/racket-mode
(use-package racket-mode
  :ensure t)

(require 'lsp-racket)
(add-hook 'racket-mode-hook #'lsp)

;; Rust
;; https://github.com/brotzeit/rustic
(use-package rustic
  :ensure t
  :bind (:map rustic-mode-map
              ("M-j"       . lsp-ui-imenu)
              ("M-?"       . lsp-find-references)
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c a" . lsp-execute-code-action)
              ("C-c C-c r" . lsp-rename)
              ("C-c C-c q" . lsp-workspace-restart)
              ("C-c C-c Q" . lsp-workspace-shutdown)
              ("C-c C-c s" . lsp-rust-analyzer-status))
  ;; FIXME: rustic-format-on-save is doing horrific things to my buffers, so
  ;;        it's disabled until I can figure out what the hell is going on...
  ; :config
  ; (setq rustic-format-on-save t)
  )

;; YAML
;; https://github.com/yoshiki/yaml-mode
(use-package yaml-mode
  :ensure t)


;; ---------------------------------------------------------------------------
;; FUNCTIONS

(defun company-yasnippet-or-completion ()
  (interactive)
  (or (do-yas-expand)
      (company-complete-common)))

(defun check-expansion ()
  (save-excursion
    (if (looking-at "\\_>") t
      (backward-char 1)
      (if (looking-at "\\.") t
        (backward-char 1)
        (if (looking-at "::") t nil)))))

(defun do-yas-expand ()
  (let ((yas/fallback-behavior 'return-nil))
    (yas/expand)))

(defun tab-indent-or-complete ()
  (interactive)
  (if (minibufferp)
      (minibuffer-complete)
    (if (or (not yas/minor-mode)
            (null (do-yas-expand)))
        (if (check-expansion)
            (company-complete-common)
          (indent-for-tab-command)))))


;; ---------------------------------------------------------------------------
;; DAEMON MODE

;; Start the Emacs server so that new frames don't need to load the config.
(require 'server)
(if (not (server-running-p))
    (server-start))


;; ---------------------------------------------------------------------------
;; NO TOUCHY!!!
;;
;; The expressions below are automatically generated/populated and, in
;; general, should not be touched by fleshy human fingers.

(eval-when-compile
  (require 'use-package))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(git-gutter:added-sign " +")
 '(git-gutter:deleted-sign " -")
 '(git-gutter:modified-sign " *")
 '(inhibit-startup-screen t)
 '(package-selected-packages
   '(fish-mode solaire-mode racket-mode treemacs-all-the-icons treemacs-magit treemacs selectrum-prescient selectrum all-the-icons rustic lsp-ui helm-lsp helm-projectile super-save git-gutter flycheck which-key magit hl-todo diminish crux smartparens doom-modeline doom-themes use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(hl-line ((t (:background "#2F333B")))))

(provide 'init)
;;; init.el ends here
