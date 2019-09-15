;; init-40-development.el --- Development packages and settings
;; Copyright (C) 2019 Andreas Wacknitz

(use-package yaml-mode :mode "\\.ya?ml$")


;; Unix config files mode
(use-package conf-mode)


;; Emacs Lisp files
(use-package elisp-format)


;; SLIME is the Superior Lisp Interaction Mode for Emacs.
;; https://github.com/slime/slime
(use-package slime)
    :init
    ;; Set your lisp system and, optionally, some contribs
    (setq inferior-lisp-program "/usr/bin/sbcl")
    (setq slime-contribs '(slime-fancy))


;; Markdown
(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
	     ("\\.md\\'"       . markdown-mode)
	     ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown")
  :bind (("<f9>" . markdown-preview))
  )


(use-package cmake-mode
  :mode "CMakeLists\\.txt\\'")


(use-package docker
  :commands docker-mode
  :bind ("C-c d" . docker))

(use-package dockerfile-mode
  :mode "Dockerfile.*\\'")


(use-package prolog
  :load-path "~/code/emacs/prolog"
  :mode ("\\.pl\\'" . prolog-mode)
  :config
    (setq-default prolog-system 'swi)
    (setq prolog-system 'swi))


;; Git
(use-package magit
  :commands magit-status
  :config
  (progn
    (magit-auto-revert-mode 1)
    (setq magit-completing-read-function 'ivy-completing-read))
  :init
  (add-hook 'magit-mode-hook 'magit-load-config-extensions)
  :bind ("C-x g" . magit-status))

(use-package magithub
  :after magit
  :disabled
  :config (magithub-feature-autoinject t))


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


;; Python
(use-package py-autopep8
  :init
  (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save))


;; Use Company for auto-completion interface.
(defun my/python-mode-hook ()
  (add-to-list 'company-backends 'company-jedi))

(use-package company-jedi
  :init
  (add-hook 'python-mode-hook 'my/python-mode-hook))

;; Python IDE
(use-package elpy
  :defer 2
  :config
  (progn
    ;; Use Flycheck instead of Flymake
    (when (require 'flycheck nil t)
      (remove-hook 'elpy-modules 'elpy-module-flymake)
      (remove-hook 'elpy-modules 'elpy-module-yasnippet)
      (remove-hook 'elpy-mode-hook 'elpy-module-highlight-indentation)
      (add-hook 'elpy-mode-hook 'flycheck-mode))
    (elpy-enable)
    ;; jedi is great
    ;; (setq elpy-rpc-backend "jedi")
    (setq python-shell-interpreter "jupyter"
          python-shell-interpreter-args "console --simple-prompt"
          python-shell-prompt-detect-failure-warning nil)
    (add-to-list 'python-shell-completion-native-disabled-interpreters "jupyter")))


