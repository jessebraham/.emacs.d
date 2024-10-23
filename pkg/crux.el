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
