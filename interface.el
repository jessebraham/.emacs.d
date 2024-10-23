(setq backup-directory-alist        `((".*" . ,temporary-file-directory))
      auto-save-file-name-transform `((".*" ,temporary-file-directory t)))

;; Don't use double-spaces after periods (because I say so).
;; Also use unicode ellipses, because they're better.
(setq sentence-end-double-space nil
      truncate-string-ellipsis  "…")

;; Scroll line-by-line rather than jumping around haphazardly.
(setq scroll-conservatively           10000
      scroll-margin                       0
      scroll-preserve-screen-position     1)

;; Whitespace settings:
;;  - tabs are 4 space characters (as the gods intended)
;;  - ensure a newline character is present at the end files when saving
;;  - clean up extraneous whitespace when saving
(setq-default indent-tabs-mode nil
              tab-width        4)
(setq require-final-newline t)
(add-hook 'before-save-hook 'whitespace-cleanup)

;; Open new windows to the right, not on the bottom.
(setq split-height-threshold nil
      split-width-threshold  0)

;; Don't require full yes/no answers, allow y/n instead.
(fset 'yes-or-no-p 'y-or-n-p)

;; Change the default font face and crank up that size!
(set-frame-font "Source Code Pro 14")

;; Enable various global modes/features:
;;  - automatically reload files if modified outside of the editor
;;  - display line numbers
;;  - prettify symbols (eg. lambda -> λ)
(global-auto-revert-mode)
(global-display-line-numbers-mode)
(global-prettify-symbols-mode)

;; Enable various modes/features:
;;  - display the line number and cursor column position in the mode line
;;  - overwrite selected text when typing
;;  - display the date and time (using 24h format) in the mode line
;;  - display the file size in the mode line
(column-number-mode)
(setq display-time-string-forms
      '((propertize (format-time-string "%F %H:%M %Z"))))
(delete-selection-mode)
(display-time-mode)
(size-indication-mode)

;; Display a ruler in the 80th column.
(setq-default display-fill-column-indicator-column 80)
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)
(add-hook 'text-mode-hook #'display-fill-column-indicator-mode)

;; Make sure that UTF-8 is *ALWAYS* the default encoding.
(set-charset-priority 'unicode)
(prefer-coding-system 'utf-8-unix)
