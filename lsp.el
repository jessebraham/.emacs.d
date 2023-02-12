;;; lsp.el --- Language server configuration

;;; Commentary:
;; Configures the Language Server for various programming languages.

;;; Code:


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


;; Taken from:
;; https://mullikine.github.io/posts/creating-a-lsp-mode-for-racket/

(require 'lsp-mode)

(defcustom lsp-racket-executable-path "racket"
  "Path to Racket executable."
  :group 'lsp-racket
  :type 'string)

(defcustom lsp-racket-server-args '()
  "Extra arguments for the Racket language server."
  :group 'lsp-racket
  :type '(repeat string))

(defun lsp-racket--server-command ()
  "Generate the language server startup command."
  `(,lsp-racket-executable-path "--lib" "racket-langserver" ,@lsp-racket-server-args))

(defvar lsp-racket--config-options `())

(lsp-register-client
 (make-lsp-client :new-connection
                  (lsp-stdio-connection 'lsp-racket--server-command)
                  :major-modes '(racket-mode)
                  :server-id 'racket
                  :initialized-fn (lambda (workspace)
                                    (with-lsp-workspace workspace
                                      (lsp--set-configuration
                                       `(:racket ,lsp-racket--config-options))))))

(add-hook 'racket-mode-hook #'lsp)


(provide 'lsp)
;;; lsp.el ends here
