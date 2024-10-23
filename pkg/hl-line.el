;; Highlight the current line. The default settings can cause some strange
;; visual effects in vterm, so only use it in programming or text modes.
(use-package hl-line
  :custom-face
  (hl-line ((t (:background "#2F333B"))))
  :config
  (add-hook 'prog-mode-hook #'hl-line-mode)
  (add-hook 'text-mode-hook #'hl-line-mode))
