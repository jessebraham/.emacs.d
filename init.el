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
        ("stable" . "https://stable.melpa.org/packages/"))
      package-archive-priorities
      '(("gnu"     .  0)
        ("melpa"   . 10)
        ("stable") .  5))

(package-initialize)

;; https://github.com/jwiegley/use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))


;; ---------------------------------------------------------------------------
;; AUTOSAVE & BACKUPS

;; Automatically save files whenever focus is lost.
(add-hook 'after-focus-change-function
          (lambda ()
            (interactive)
            (save-some-buffers t)))

;; Store backup and autosave files in the temp directory rather than just
;; littering them about everywhere.
(setq backup-directory-alist        `((".*" . ,temporary-file-directory))
      auto-save-file-name-transform `((".*" ,temporary-file-directory t)))


;; ---------------------------------------------------------------------------
;; GARBAGE COLLECTION

(defconst GC-CONS-THRESHOLD    50000000) ; 50MB
(defconst LARGE-FILE-THRESHOLD 50000000) ; 50MB

(setq gc-cons-threshold            GC-CONS-THRESHOLD
      large-file-warning-threshold LARGE-FILE-THRESHOLD)

(defun defer-garbage-collection ()
  (setq gc-cons-threshold most-positive-fixnum))

(defun restore-garbage-collection ()
  (run-at-time
   1 nil (lambda () (setq gc-cons-threshold GC-CONS-THRESHOLD))))

(add-hook 'minibuffer-setup-hook #'defer-garbage-collection)
(add-hook 'minibuffer-exit-hook  #'restore-garbage-collection)


;; ---------------------------------------------------------------------------
;; INTERFACE TWEAKS

;; Disable the menu bar, scroll bar, and tool bar.
(menu-bar-mode     -1)
(toggle-scroll-bar -1)
(tool-bar-mode     -1)

;; Enable various modes/features:
;;  - display the line number and cursor column position in the mode line
;;  - display the date and time (using 24h format) in the mode line
;;  - display the file size in the mode line
(column-number-mode)
(setq display-time-string-forms
      '((propertize (format-time-string "%Y-%m-%d %H:%M"))))
(display-time-mode)
(size-indication-mode)

;; Don't require full yes/no answers, allow y/n instead.
(fset 'yes-or-no-p 'y-or-n-p)

;; Scroll line-by-line rather than jumping around haphazardly.
(setq scroll-conservatively           10000
      scroll-margin                       0
      scroll-preserve-screen-position     1)

;; Don't use double-spaces after periods (because I say so).
(setq sentence-end-double-space nil)


;; ---------------------------------------------------------------------------
;; EDITOR TWEAKS

;; Enable various global modes/features:
;;  - automatically reload files if modified outside of the editor
;;  - display line numbers
;;  - prettify symbols (eg. lambda -> λ)
(global-auto-revert-mode)
(global-display-line-numbers-mode)
(global-prettify-symbols-mode)

;; Display a ruler in the 80th column.
(setq-default display-fill-column-indicator-column 80)
(global-display-fill-column-indicator-mode)

;; Highlight the current line. The default settings can cause some strange
;; visual effects in vterm, so only use it in programming or text modes.
(require 'hl-line)
(set-face-attribute 'hl-line    nil
                    :background "gray17")
(add-hook 'prog-mode-hook #'hl-line-mode)
(add-hook 'text-mode-hook #'hl-line-mode)

;; When text is selected and you begin typing, the selected text should be
;; overwritten.
(delete-selection-mode)

;; Whitespace settings:
;;  - tabs are 4 space characters (as the gods intended)
;;  - ensure a newline character is present at the end files when saving
;;  - clean up extraneous whitespace when saving
(setq-default indent-tabs-mode nil
              tab-width        4)
(setq require-final-newline t)
(add-hook 'before-save-hook 'whitespace-cleanup)


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
(global-set-key (kbd "C-c C-h") (kbd "C-c @ C-h")) ; Hide a block
(global-set-key (kbd "C-c C-s") (kbd "C-c @ C-s")) ; Show a block

(add-hook 'prog-mode-hook #'hs-minor-mode)


;; ---------------------------------------------------------------------------
;; THEME

;; Use the 'doom-one' theme from the 'doom-themes' package.
;; https://github.com/hlissner/emacs-doom-themes/
(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold   t
        doom-themes-enable-italic t)
  (doom-themes-org-config)
  (doom-themes-visual-bell-config)
  (load-theme 'doom-one t))

;; Modeline from doom.
;; https://github.com/seagle0128/doom-modeline
(use-package doom-modeline
  :ensure t
  :init   (doom-modeline-mode))


;; ---------------------------------------------------------------------------
;; PACKAGES

;; Text completion framework. Uses pluggable back-ends and front-ends to
;; retrieve and display completion candidates.
;; https://github.com/company-mode/company-mode
(use-package company
  :ensure   t
  :diminish company-mode
  :config
  (setq company-idle-delay            0.2
        company-minimum-prefix-length 3
        company-echo-delay            0
        company-show-numbers          t
        company-transformers          '(company-sort-by-occurrence))
  (add-hook 'after-init-hook #'global-company-mode))

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

;; An extensible emacs startup screen showing you what’s most important.
;; https://github.com/emacs-dashboard/emacs-dashboard/
(use-package dashboard
  :ensure t
  :config
  (setq dashboard-items '((projects . 5)
                          (recents  . 5)
                          (agenda   . 5)))
  (setq dashboard-week-agenda t)
  (dashboard-setup-startup-hook))

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
  (set-face-foreground 'git-gutter:added    "#98BE65")
  (set-face-foreground 'git-gutter:modified "#E6C07B")
  (set-face-foreground 'git-gutter:deleted  "#FF6C6B")
  (add-hook 'prog-mode-hook #'git-gutter-mode)
  (add-hook 'text-mode-hook #'git-gutter-mode))

;; A framework for incremental completions and narrowing selections.
;; https://github.com/emacs-helm/helm
(use-package helm
  :ensure   t
  :diminish helm-mode
  :bind
  ("M-x"     . helm-M-x)
  ("C-x C-f" . helm-find-files)
  ("M-y"     . helm-show-kill-ring)
  ("C-x b"   . helm-mini)
  :config
  (require 'helm-config)
  (setq helm-split-window-inside-p         t
        helm-move-to-line-cycle-in-source  t
        helm-autoresize-max-height         0
        helm-autoresize-min-height        20)
  (helm-mode)
  (helm-autoresize-mode)
  ; Re-bind <tab> to run persistent action.
  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
  ; Make <tab> work in terminal.
  (define-key helm-map (kbd "C-i")   'helm-execute-persistent-action)
  ; List actions using C-z.
  (define-key helm-map (kbd "C-z")   'helm-select-action))

;; Integrate helm and projectile.
;; https://github.com/bbatsov/helm-projectile
(use-package helm-projectile
  :ensure t
  :config (helm-projectile-on))

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

;; I mean, you have to use org-mode... right?
;; https://github.com/bzg/org-mode
(use-package org-mode
  :ensure org-plus-contrib
  :mode   (("\\.org$" . org-mode))
  :init
  (setq org-todo-keywords
        '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE")))
  (global-set-key "\C-ca" 'org-agenda)
  (global-set-key "\C-cl" 'org-store-link))

;; A project interaction/management library.
;; https://github.com/bbatsov/projectile
(use-package projectile
  :ensure   t
  :diminish projectile-mode
  :init     (projectile-mode)
  :bind
  (("C-c p f" . helm-projectile-find-file)
   ("C-c p p" . helm-projectile-switch-project)
   ("s-p"     . projectile-command-map)
   ("C-c p s" . projectile-save-project-buffers)))

;; Rainbow delimiters!
;; https://github.com/Fanael/rainbow-delimiters
(use-package rainbow-delimiters
  :ensure t
  :config (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

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

;; Show keystroke suggestions.
;; https://github.com/justbur/emacs-which-key
(use-package which-key
  :ensure   t
  :diminish which-key-mode
  :config   (which-key-mode))


;; ---------------------------------------------------------------------------
;; LANGUAGES

;; https://github.com/wwwjfy/emacs-fish
(use-package fish-mode
  :ensure t)

;; https://github.com/greghendershott/racket-mode
(use-package racket-mode
  :ensure t
  :config
  (require  'racket-xp)
  (add-hook 'racket-mode-hook #'racket-xp-mode))


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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" default))
 '(package-selected-packages '(racket-mode git-gutter use-package)))
 '(org-agenda-files '("~/org/agenda.org"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
