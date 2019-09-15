;; init-40-development.el --- Development packages and settings
;; Copyright (C) 2019 Andreas Wacknitz

(use-package yaml-mode :mode "\\.ya?ml$")


;; Unix config files mode
(use-package conf-mode)


;; Emacs Lisp files
(use-package elisp-format)


;; Markdown
(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
	     ("\\.md\\'"       . markdown-mode)
	     ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown")
  :bind (("<f9>" . markdown-preview))
  )


(use-package docker
  :commands docker-mode
  :bind ("C-c d" . docker))

(use-package dockerfile-mode
  :mode "Dockerfile.*\\'")


;; Git
(use-package magit
  :bind ("C-x g" . magit-status))


;; Syntax checker:
(use-package flycheck
  :diminish ""
  :init
  (progn
    (setq flycheck-indication-mode 'left-fringe)
    ;; disable the annoying doc checker
    (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc javascript-jshint))
    ;(flycheck-add-mode 'javascript-eslint 'js2-mode)
    )
  :config
  (global-flycheck-mode 1))
