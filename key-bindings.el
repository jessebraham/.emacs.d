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
