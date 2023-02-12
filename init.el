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
;; Also use unicode ellipses, because they're better.
(setq sentence-end-double-space nil
      truncate-string-ellipsis  "…")

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
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)
(add-hook 'text-mode-hook #'display-fill-column-indicator-mode)

;; Make sure that UTF-8 is *ALWAYS* the default encoding.
(set-charset-priority 'unicode)
(prefer-coding-system 'utf-8-unix)


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
;; APPEARANCE & THEME

;; All of the icons!
; https://github.com/domtronn/all-the-icons.el
(use-package all-the-icons
  :ensure t)

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
  :init
  (doom-modeline-mode 1))

;; Distinguish "real" buffers from "unreal" buffers.
;; https://github.com/hlissner/emacs-solaire-mode
(use-package solaire-mode
  :ensure t
  :config
  (solaire-global-mode +1))


;; ---------------------------------------------------------------------------
;; PACKAGES

(load "~/.emacs.d/lsp.el")
(load "~/.emacs.d/pkg.el")


;; ---------------------------------------------------------------------------
;; LANGUAGE SUPPORT

;; Fish shell
;; https://github.com/wwwjfy/emacs-fish
(use-package fish-mode
  :ensure t)

;; Markdown
;; https://github.com/jrblevin/markdown-mode
(use-package markdown-mode
  :ensure t
  :mode
  ("README\\.md\\'" . gfm-mode)
  :init
  (setq markdown-command "multimarkdown"))

;; Racket
;; https://github.com/greghendershott/racket-mode
(use-package racket-mode
  :ensure t)

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

;; TOML
;; https://github.com/dryman/toml-mode.el
(use-package toml-mode
  :ensure t)

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
   '(vterm toml-mode fish-mode solaire-mode racket-mode treemacs-all-the-icons treemacs-magit treemacs selectrum-prescient selectrum all-the-icons rustic lsp-ui helm-lsp helm-projectile super-save git-gutter flycheck which-key magit hl-todo diminish crux smartparens doom-modeline doom-themes use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(hl-line ((t (:background "#2F333B")))))

(provide 'init)
;;; init.el ends here
