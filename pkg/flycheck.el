;; On-the-fly syntax checking.
;; https://github.com/flycheck/flycheck
(use-package flycheck
  :ensure   t
  :diminish flycheck-mode
  :config
  (setq flycheck-standard-error-navigation nil)
  (add-hook 'after-init-hook #'global-flycheck-mode))
