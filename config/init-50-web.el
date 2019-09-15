;;(load-file "~/.emacs.d/config/init-50-web.el")
;; init-50-web.el --- Web development packages and settings
;; Copyright (C) 2019 Andreas Wacknitz

;; Web
(use-package web-mode
  :mode "\\.phtml\\'"
  :mode "\\.volt\\'"
  :mode "\\.html\\'"
  :mode "\\.tsx$\\'"
  :init
  (add-hook 'web-mode-hook 'variable-pitch-mode)
  (add-hook 'web-mode-hook 'company-mode)
  (add-hook 'web-mode-hook 'prettier-js-mode)
  (add-hook 'web-mode-hook (lambda () (pcase (file-name-extension buffer-file-name)
                      ("tsx" (my-tide-setup-hook))
                      (_ (my-web-mode-hook))))))

(use-package css-mode
  :init
  (progn
    (add-to-list 'auto-mode-alist '("\\.scss$" . css-mode))
    (add-to-list 'auto-mode-alist '("\\.sass$" . css-mode))
    (setq css-indent-offset 2)))

;; Emmet is supper cool, and emmet-mode brings support to Emacs.
(use-package emmet-mode
  :commands (emmet-expand-line emmet-expand)
  :defer 2
  :init
  (progn
    (add-hook 'sgml-mode-hook 'emmet-mode)
    (add-hook 'web-mode-hook 'emmet-mode)
    (add-hook 'css-mode-hook  'emmet-mode))
  :config
  (progn
    (bind-key "C-j" 'emmet-expand-line emmet-mode-keymap)
    (bind-key "<C-return>" 'emmet-expand emmet-mode-keymap)
    (setq emmet-indentation 2)
    (defadvice emmet-preview-accept (after expand-and-fontify activate)
      "Update the font-face after an emmet expantion."
      (font-lock-fontify-buffer))))


;; JavaScript
(use-package js2-mode
  :mode ("\\.js\\'")
  :interpreter "node")

(use-package angular-mode
  :config (setq js-indent-level 2))

;; Run eslint --fix
(defun eslint-fix-file ()
  (interactive)
  (add-node-modules-path)
  (message (concat "eslint --fix " (buffer-file-name)))
  (call-process "eslint" nil 0 nil "--fix" (buffer-file-name))
  (revert-buffer t t))

;; TypeScript
(defun my-web-mode-hook ())
(defun my-tide-setup-hook ()
  (tide-setup)
  (eldoc-mode)
  (tide-hl-identifier-mode +1)

  (setq web-mode-enable-auto-quoting nil)
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-attr-indent-offset 2)
  (setq web-mode-attr-value-indent-offset 2)
  (set (make-local-variable 'company-backends)
       '((company-tide company-files :with company-yasnippet)
         (company-dabbrev-code company-dabbrev)))
  (flycheck-add-mode 'typescript-tslint 'web-mode)
  (general-define-key
   :states 'normal
   :keymaps 'local
   :prefix ", ."
   "f" 'tide-fix
   "i" 'tide-organize-imports
   "u" 'tide-references
   "R" 'tide-restart-server
   "d" 'tide-documentation-at-point
   "F" 'tide-format

   "e s" 'tide-error-at-point
   "e l" 'tide-project-errors
   "e i" 'tide-add-tslint-disable-next-line
   "e n" 'tide-find-next-error
   "e p" 'tide-find-previous-error

   "r r" 'tide-rename-symbol
   "r F" 'tide-refactor
   "r f" 'tide-rename-file)
  (general-define-key
   :states 'normal
   :keymaps 'local
   :prefix "g"
   :override t

   "d" 'tide-jump-to-definition
   "D" 'tide-jump-to-implementation
   "b" 'tide-jump-back))

(use-package prettier-js
  :defer t)
(use-package tide
  :defer t)

(use-package typescript-mode
  :mode (("\\.ts$" . typescript-mode))
  :init
  (add-hook 'typescript-mode-hook 'my-tide-setup-hook)
  (add-hook 'typescript-mode-hook 'company-mode)
  (add-hook 'typescript-mode-hook 'prettier-js-mode))


(setq-default typescript-indent-level 2)
