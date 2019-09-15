;; init-95-experiments.el --- emacs experiments
;; Copyright (C) 2019 Andreas Wacknitz

;; https://github.com/jacktasia/dumb-jump
;;
;; dumb-jump-go C-M-g core functionality. Attempts to jump to the definition for the thing under point
;; dumb-jump-back C-M-p jumps back to where you were when you jumped. These are chained so if you go down a rabbit hole you can get back out or where you want to be.
;; dumb-jump-quick-look C-M-q like dumb-jump-go but only shows tooltip with file, line, and context it does not jump.
;; dumb-jump-go-other-window exactly like dumb-jump-go but uses find-file-other-window instead of find-file
;; dumb-jump-go-prefer-external like dumb-jump-go but will prefer definitions not in the current buffer
;; dumb-jump-go-prefer-external-other-window expected combination of dumb-jump-go-prefer-external and dumb-jump-go-other-window
;; dumb-jump-go-prompt exactly like dumb-jump-go but prompts user for function to jump to instead of using symbol at point



(use-package dumb-jump
  :bind (("M-g o" . dumb-jump-go-other-window)
         ("M-g j" . dumb-jump-go)
         ("M-g i" . dumb-jump-go-prompt)
         ("M-g x" . dumb-jump-go-prefer-external)
         ("M-g z" . dumb-jump-go-prefer-external-other-window))
  :config (setq dumb-jump-selector 'ivy) ;; (setq dumb-jump-selector 'helm)
  )
;; Makes use of the_silver_searcher (https://github.com/ggreer/the_silver_searcher)
;; MacOS: brew install the_silver_searcher
;; OpenIndiana: pkg install text/the_silver_searcher
;;(use-package ag)



;; https://github.com/pashky/restclient.el
(use-package restclient)
