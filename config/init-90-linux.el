;; init-90-linux.el --- Linux specific settings
;; Copyright (C) 2019 Andreas Wacknitz

(setq-default tide-tsserver-executable "/home/andreas/npm/bin/tsserver")


;; We have a problem with graphics in OpenIndiana, thus we use the simpler neotree for it.
;; treemacs is also not working for Debian Stretch (emacs-25.1.1).
;;https://github.com/jaypei/emacs-neotree
(use-package neotree
  :init
  (setq-default neo-show-hidden-files t)
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  (global-set-key [f8] 'neotree-toggle)
  )
