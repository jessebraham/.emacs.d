;; Display the minimap on the right hand side of the buffer.
;; https://github.com/dengste/minimap
(use-package minimap
  :ensure t
  :config
  (setq minimap-width-fraction  0.1
        minimap-minimum-width   20
        minimap-window-location 'right
        minimap-update-delay    0.05
        minimap-recenter-type   'free
        minimap-hide-fringes    t))
