;; A better solution for incremental narrowing.
;; https://github.com/radian-software/selectrum
(use-package selectrum
  :ensure t
  :config
  (selectrum-mode +1))

;; Sorting and filtering of list candidates.
;; https://github.com/radian-software/prescient.el
(use-package selectrum-prescient
  :ensure t
  :config
  (prescient-persist-mode +1)
  (selectrum-prescient-mode +1))
