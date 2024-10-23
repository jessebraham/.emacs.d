;; Language server protocol support.
;; https://github.com/emacs-lsp/lsp-mode
(use-package lsp-mode
  :ensure t
  :commands lsp
  :custom
  (lsp-eldoc-render-all t)
  (lsp-idle-delay       0.6)
  ;; rust-analyzer configuration
  ;; https://emacs-lsp.github.io/lsp-mode/page/lsp-rust-analyzer/#available-configurations
  (lsp-rust-analyzer-cargo-watch-command                                "clippy")
  (lsp-rust-analyzer-display-chaining-hints                             t)
  (lsp-rust-analyzer-display-closure-return-type-hints                  t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-enable              "skip_trivial")
  (lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names t)
  (lsp-rust-analyzer-server-display-inlay-hints                         t)
  :config
  (add-hook 'lsp-after-open-hook
            (lambda ()
              (when (lsp-find-workspace 'rust-analyzer nil)
                (set-face-attribute 'lsp-rust-analyzer-inlay-face
                                    nil
                                    :foreground "#797E81"
                                    :height     140
                                    :slant      'italic)))))
