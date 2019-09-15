;; init-60-python.el --- load python development packages
;; Copyright (C) 2019 Andreas Wacknitz

;; Python
;; (use-package jedi
;;   :init
;;   (add-hook 'python-mode-hook 'jedi:setup)
;;   (setq jedi:complete-on-dot t))

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
    (add-to-list 'python-shell-completion-native-disabled-interpreters "jupyter")
    )
  )
