;;; init.el --- A minimal-ish initialization file for Emacs.

;;; Commentary:
;; Defines a simple function for including other user-defined configuration
;; files, and loads all specified user configuration.

;;; Code:

(defconst user-init-dir
  (cond ((boundp 'user-emacs-directory)
         user-emacs-directory)
        ((boundp 'user-init-directory)
         user-init-directory)
        (t "~/.emacs.d/")))

(defun load-user-file (file)
  (interactive "f")
  "Load a file in current user's configuration directory"
  (load-file (expand-file-name file user-init-dir)))

(load-user-file "functions.el")
(load-user-file "gc.el")
(load-user-file "package.el")

(load-user-file "interface.el")
(load-user-file "key-bindings.el")
(load-user-file "theme.el")

;; Language Support:
(load-user-file "lang/fish.el")
(load-user-file "lang/markdown.el")
(load-user-file "lang/rust.el")
(load-user-file "lang/toml.el")
(load-user-file "lang/yaml.el")

;; Package Configuration:
(load-user-file "pkg/company.el")
(load-user-file "pkg/crux.el")
(load-user-file "pkg/diminish.el")
(load-user-file "pkg/flycheck.el")
(load-user-file "pkg/git-gutter.el")
(load-user-file "pkg/hl-line.el")
(load-user-file "pkg/hl-todo.el")
(load-user-file "pkg/lsp.el")
(load-user-file "pkg/magit.el")
(load-user-file "pkg/minimap.el")
(load-user-file "pkg/rainbow-delimiters.el")
(load-user-file "pkg/selectrum.el")
(load-user-file "pkg/smartparens.el")
(load-user-file "pkg/super-save.el")
(load-user-file "pkg/treemacs.el")
(load-user-file "pkg/vterm.el")
(load-user-file "pkg/which-key.el")
(load-user-file "pkg/yasnippet.el")

;; Start the Emacs server so that new frames don't need to load the config.
(require 'server)
(if (not (server-running-p))
    (server-start))

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
 '(package-selected-packages
   '(magit solaire-mode doom-modeline doom-themes all-the-icons)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
