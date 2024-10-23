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
