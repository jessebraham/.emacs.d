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
