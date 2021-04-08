;;; init.el --- A minimal-ish initialization file for Emacs.

;;; Commentary:
;; Simple configuration which sets some reasonable defaults and includes a
;; number of useful packages.

;;; Code:


;; ---------------------------------------------------------------------------
;; PACKAGE MANAGEMENT

(require 'package)
(setq package-enable-at-startup nil)

(setq package-archives '(("gnu"   . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

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
(add-hook 'focus-out-hook
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
  ;; Defer it so that commands launched immediately after will enjoy the
  ;; benefits.
  (run-at-time
   1 nil (lambda () (setq gc-cons-threshold GC-CONS-THRESHOLD))))

(add-hook 'minibuffer-setup-hook #'defer-garbage-collection)
(add-hook 'minibuffer-exit-hook  #'restore-garbage-collection)


;; ---------------------------------------------------------------------------
;; INTERFACE TWEAKS

;; Disable various default modes/features:
;;  - the menu bar
;;  - the scroll bar
;;  - the tool bar
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

;; Don't use double-spaces after periods (because I say so).
(setq sentence-end-double-space nil)


;; ---------------------------------------------------------------------------
;; EDITOR TWEAKS

;; Enable various global modes/features:
;;  - automatically reload files if modified outside of the editor
;;  - display line numbers (set the initial gutter size to avoid resizing)
;;  - prettify symbols (eg. lambda -> λ)
(global-auto-revert-mode)
(setq display-line-numbers-width-start 4)
(global-display-line-numbers-mode)
(global-prettify-symbols-mode)

;; Display a ruler in the 80th column.
(setq-default display-fill-column-indicator-column 80)
(global-display-fill-column-indicator-mode)

;; Highlight the current line. The default settings can cause some strange
;; visual effects in vterm, so only use it in programming or text modes.
(require 'hl-line)
(set-face-attribute 'hl-line    nil
                    :background "gray11")
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

;; Make it easier to move between windows. Windows can be navigated using
;; <shift> in combination with the arrow keys.
(setq windmove-wrap-around t)
(windmove-default-keybindings)


;; ---------------------------------------------------------------------------
;; THEME

;; Use the 'doom-one' theme from the 'doom-themes' package.
;; https://github.com/hlissner/emacs-doom-themes/
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-one t)
  (doom-themes-visual-bell-config))

;; Sexy mode-line. Aims to be easy to read from small to large monitors.
;; https://github.com/Malabarba/smart-mode-line
(use-package smart-mode-line
  :ensure t
  :config
  (setq sml/theme 'respectful)
  (add-hook 'after-init-hook 'sml/setup))


;; ---------------------------------------------------------------------------
;; PACKAGES

;; Useful improvements to default keyboard shortcuts.
;; https://github.com/bbatsov/crux
(use-package crux
  :ensure t
  :bind
  ("C-k"   . crux-smart-kill-line)
  ("C-c n" . crux-cleanup-buffer-or-region)
  ("C-c f" . crux-recentf-find-file)
  ("C-c d" . crux-duplicate-current-line-or-region)
  ("C-a"   . crux-move-beginning-of-line))

;; Don't display minor modes in the mode line.
;; https://github.com/emacsmirror/diminish
(use-package diminish
  :ensure t)

;; Highlight FIXME, NOTE, and TODO in comments.
;; https://github.com/tarsius/hl-todo
(use-package hl-todo
  :ensure t
  :config
  (setq hl-todo-keyword-faces
        '(("FIXME" . "#FF6C6B")
          ("NOTE"  . "#E6C07B")
          ("TODO"  . "#C678DD")))
  (global-hl-todo-mode))

;; The one and only true git integration.
;; https://github.com/magit/magit
(use-package magit
  :bind (("C-M-g" . magit-status)))

;; Rainbow delimiters!
;; https://github.com/Fanael/rainbow-delimiters
(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

;; Insert/delete parens in pairs, highlight pairs, etc. General quality of life
;; improvements.
;; https://github.com/Fuco1/smartparens
(use-package smartparens
  :ensure t
  :diminish smartparens-mode
  :config
  (progn
    (require 'smartparens-config)
    (smartparens-global-mode)
    (show-paren-mode)))

;; Show keystroke suggestions.
;; https://github.com/justbur/emacs-which-key
(use-package which-key
  :ensure t
  :diminish which-key-mode
  :config
  (which-key-mode))


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
 '(package-selected-packages '(use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
