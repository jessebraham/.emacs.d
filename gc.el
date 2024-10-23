(defconst GC-CONS-THRESHOLD    250000000) ; 250MB
(defconst LARGE-FILE-THRESHOLD  50000000) ; 50MB

(setq gc-cons-threshold            GC-CONS-THRESHOLD
      large-file-warning-threshold LARGE-FILE-THRESHOLD)

(defun defer-garbage-collection ()
  "Defer garbage collection indefinitely, or rather until we restore it."
  (setq gc-cons-threshold most-positive-fixnum))

(defun restore-garbage-collection ()
  "Restore garbage collection with the configured threshold."
  (run-at-time
   1 nil (lambda () (setq gc-cons-threshold GC-CONS-THRESHOLD))))

(add-hook 'minibuffer-setup-hook #'defer-garbage-collection)
(add-hook 'minibuffer-exit-hook  #'restore-garbage-collection)
