;; Text completion framework. Uses pluggable back-ends and front-ends to
;; retrieve and display completion candidates.
;; https://github.com/company-mode/company-mode
(use-package company
  :ensure   t
  :diminish company-mode
  :config
  (setq company-idle-delay            0.4
        company-minimum-prefix-length 3
        company-echo-delay            0
        company-show-numbers          t
        company-transformers          '(company-sort-by-occurrence))
  (add-hook 'after-init-hook #'global-company-mode)
  :bind
  (:map company-active-map
        ("C-n" . company-select-next)
        ("C-p" . company-select-previous)
        ("M-<" . company-select-first)
        ("M->" . company-select-last))
  (:map company-mode-map
    ("<tab>" . tab-indent-or-complete)
    ("TAB"   . tab-indent-or-complete)))
