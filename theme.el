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
