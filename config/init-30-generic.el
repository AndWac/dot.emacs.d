;; init-30-generic.el --- load generic packages
;; Copyright (C) 2019 Andreas Wacknitz

;; Theme
(use-package material-theme
  :config (load-theme 'material t))


(use-package telephone-line
  :config
  ;; (setq telephone-line-lhs
  ;;       '((evil   . (telephone-line-evil-tag-segment))
  ;;         (accent . (telephone-line-major-mode-segment))
  ;;         (evil   . (telephone-line-buffer-segment))
  ;;         (nil    . (telephone-line-minor-mode-segment))))
  
  ;; (setq telephone-line-rhs
  ;;       '((nil    . (telephone-line-misc-info-segment))
  ;;         (evil   . (mymacs-telephone-line-buffer-info))
  ;;         (accent . (telephone-line-vc-segment
  ;;                    telephone-line-erc-modified-channels-segment
  ;;                    telephone-line-process-segment))
  ;;         (evil   . (telephone-line-airline-position-segment))))

  (telephone-line-mode t))


;; helpful as an alternative help system
(use-package helpful
  :bind
  (("C-h f" . helpful-callable)
   ("C-h v" . helpful-variable)
   ("C-h k" . helpful-key)
   ("C-h F ". helpful-function)
   ("C-c C-d" . helpful-at-point)
   ("C-h C" . helpful-command)))

;; https://github.com/ryuslash/mode-icons
(use-package mode-icons
  :config
  (mode-icons-mode))


;; Paradox Package Manager
;; https://github.com/Malabarba/paradox
(use-package paradox
  :config
  (progn
    (setq paradox-execute-asynchronously t)
    (setq paradox-automatically-star t)
    (paradox-enable)))


;; Dashboard
;;  https://github.com/emacs-dashboard/emacs-dashboard
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-items '((recents  . 5)
                          (bookmarks . 5)
                          (projects . 5)
                          (agenda . 5)
                          (registers . 5)))
)


;; Smooth Scrolling
(use-package smooth-scrolling
  :config (smooth-scrolling-mode 1)
  (setq smooth-scroll-margin 5))


;; Which Key
(use-package which-key
  :init
  (setq which-key-separator " ")
  (setq which-key-prefix-prefix "+")
  :config
  (which-key-mode 1))


;; Projectile
;; https://github.com/bbatsov/projectile
(use-package projectile
  :demand
  :init   (setq projectile-use-git-grep t)
          (setq projectile-require-project-root nil)
          ;(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  :config (projectile-mode +1)
  :bind   (("s-f" . projectile-find-file)  ; Unter Windows ist der Super-Key die Windows-Taste :(
           ("s-F" . projectile-grep)
           ))


;; Parenthesis change color depending on depth
(use-package rainbow-delimiters
  :defer t 
  :init (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))


;; rainbow-blocks: Understand Clojure/Lisp code at a glance using block highlighting.
(use-package rainbow-blocks
  :defer t 
  :init (add-hook 'clojure-mode-hook 'rainbow-blocks-mode))


;; Automatic parenthesis
(use-package smartparens
  :diminish smartparens-mode
  :commands
    smartparens-strict-mode
    smartparens-mode
    sp-restrict-to-pairs-interactive
    sp-local-pair
  :config
    (require 'smartparens-config)
    (sp-use-smartparens-bindings)
    (sp-pair "(" ")" :wrap "C-(") ;; how do people live without this?
    (sp-pair "[" "]" :wrap "s-[") ;; C-[ sends ESC
    (sp-pair "{" "}" :wrap "C-{")
    ;; WORKAROUND https://github.com/Fuco1/smartparens/issues/543
    (bind-key "C-<left>"  nil smartparens-mode-map)
    (bind-key "C-<right>" nil smartparens-mode-map)
    (bind-key "s-<delete>"    'sp-kill-sexp smartparens-mode-map)
    (bind-key "s-<backspace>" 'sp-backward-kill-sexp smartparens-mode-map)
  :bind ("C-x j" . smartparens-mode)
)


;; Company - complete anything:
(use-package company
  :config
  (setq company-dabbrev-downcase 0)
  (setq company-idle-delay 0.2)
  (global-company-mode 1))
(use-package company-posframe
  :config (company-posframe-mode 1))


(use-package diff-hl
  :config
  (global-diff-hl-mode)
  (setq-default diff-hl-side 'right)
  :init
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))


;; Avy - Jump to location
(use-package avy
  :bind (("M-s" . avy-goto-word-1)))


;; Ido, Yes!
(use-package ido
  :config
  (ido-mode t)
  ;; show any name that has the chars I typed
  (setq ido-enable-flex-matching t))


;; Folding
(use-package hideshow
  :hook ((prog-mode . hs-minor-mode)))

(defun toggle-fold ()
  (interactive)
  (save-excursion
    (end-of-line)
    (hs-toggle-hiding)))


;; Integrate Emacs with your user env variables / paths
(use-package exec-path-from-shell 
  :config (when (memq window-system '(mac ns x)) 
	        (exec-path-from-shell-initialize)))


;; https://github.com/deb0ch/emacs-winum
(use-package winum
  :init
  (winum-mode))
