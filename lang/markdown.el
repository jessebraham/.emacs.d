;; Markdown
;; https://github.com/jrblevin/markdown-mode
(use-package markdown-mode
  :ensure t
  :mode
  ("README\\.md\\'" . gfm-mode)
  :init
  (setq markdown-command "multimarkdown"))
