;; init-30-default.el --- load default packages
;; Copyright (C) 2019 Andreas Wacknitz


;; Paradox Package Manager
;; https://github.com/Malabarba/paradox
(use-package paradox
  :config
  (progn
    (setq paradox-execute-asynchronously t)
    (setq paradox-automatically-star t)
    (paradox-enable)))


;; Dashboard
;; https://github.com/emacs-dashboard/emacs-dashboard
(use-package dashboard
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-items '((recents  . 5)
                          (bookmarks . 5)
                          (projects . 5)
                          (agenda . 5)
                          (registers . 5))))


;; Folding
(use-package hideshow
  :hook ((prog-mode . hs-minor-mode)))

(defun toggle-fold ()
  (interactive)
  (save-excursion
    (end-of-line)
    (hs-toggle-hiding)))


;; Ivy
;; https://github.com/abo-abo/swiper
;; Ivy, a generic completion mechanism for Emacs.
;; Counsel, a collection of Ivy-enhanced versions of common Emacs commands.
;; Swiper, an Ivy-enhanced alternative to isearch.
(use-package ivy)

(use-package swiper
  :diminish ivy-mode
  :bind (("C-r" . swiper)
         ("C-c C-r" . ivy-resume)
         ("C-c h m" . woman)
         ("C-x b" . ivy-switch-buffer)
         ("C-c u" . swiper-all))
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t))

(use-package counsel
  :commands (counsel-mode)
  :bind (("C-s" . counsel-grep-or-swiper)
         ("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("C-h f" . counsel-describe-function)
         ("C-h v" . counsel-describe-variable)
         ("C-h i" . counsel-info-lookup-symbol)
         ("C-h u" . counsel-unicode-char)
         ("C-c k" . counsel-rg)
         ("C-x l" . counsel-locate)
         ("C-c g" . counsel-git-grep)
         ("C-c h i" . counsel-imenu)
         ("C-x p" . counsel-list-processes))
  :init (counsel-mode)
  :config
  (ivy-set-actions
           'counsel-find-file
           '(("j" find-file-other-window "other")))
  (ivy-set-actions 'counsel-git-grep
                   '(("j" find-file-other-window "other"))))

(use-package ivy-hydra )
(use-package ivy-xref
  :init (setq xref-show-xrefs-function #'ivy-xref-show-xrefs))


;; Treat undo history as a tree
(use-package undo-tree
  :config
  (progn
    (global-undo-tree-mode)
    (setq undo-tree-visualizer-timestamps t))
  :diminish undo-tree-mode)
(add-to-list 'auto-mode-alist '("\\.zsh\\'" . sh-mode))
(winner-mode 1)
(global-unset-key (kbd "C-z"))
(put 'upcase-region 'disabled nil)
(setq require-final-newline t)


;; Unobtrusively trim extraneous white-space *ONLY* in lines edited.
(use-package ws-butler
  :diminish ws-butler-mode
  :config
  (progn
    (ws-butler-global-mode)
    (setq ws-butler-keep-whitespace-before-point nil)))


;; Company is a text completion framework for Emacs. The name stands for "complete anything".
;; http://company-mode.github.io
(use-package company
  :diminish company-mode
  :defer 2
  :bind ("C-<tab>" . company-complete)
  :config
  (global-company-mode t))


;;
;;
(use-package dired-subtree
  :commands (dired-subtree-insert))


;; Projectile
;; https://github.com/bbatsov/projectile
;; This library provides easy project management and navigation.
;; The concept of a project is pretty basic - just a folder containing special file.
;; Currently git, mercurial, darcs and bazaar repos are considered projects by default.
;; So are lein, maven, sbt, scons, rebar and bundler projects.
;; If you want to mark a folder manually as a project just create an empty .projectile file in it.
;;Some of Projectile's features:
;;
;;    jump to a file in project
;;    jump to files at point in project
;;    jump to a directory in project
;;    jump to a file in a directory
;;    jump to a project buffer
;;    jump to a test in project
;;    toggle between files with same names but different extensions (e.g. .h <-> .c/.cpp, Gemfile <-> Gemfile.lock)
;;    toggle between code and its test (e.g. main.service.js <-> main.service.spec.js)
;;    jump to recently visited files in the project
;;    switch between projects you have worked on
;;    kill all project buffers
;;    replace in project
;;    multi-occur in project buffers
;;    grep in project
;;    regenerate project etags or gtags (requires ggtags).
;;    visit project in dired
;;    run make in a project with a single key chord
;;    check for dirty repositories
;;    toggle read-only mode for the entire project
(use-package projectile
  :commands (projectile-mode)
  :demand
  :init   (setq projectile-use-git-grep t)
          (setq projectile-require-project-root nil)
		  (setq projectile-completion-system 'ivy)
;;		  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
;;		  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  :bind   (("s-f" . projectile-find-file)  ; Unter Windows ist der Super-Key die Windows-Taste
		   ("s-F" . projectile-grep)
		   ))

(use-package counsel-projectile
  :commands (counsel-projectile-mode)
  :init
  (progn
    (projectile-mode +1)
    (counsel-projectile-mode)))

