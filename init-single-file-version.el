;; My own .emacs / emacs.d/init.el file with collected configurations and packages.

;; User Info
(setq user-full-name "Andreas Wacknitz")
(setq user-mail-address "a.wacknitz@gmx.de")


(package-initialize nil)
(add-to-list 'package-archives
             '("org" . "https://orgmode.org/elpa/"))
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(setq package-archive-priorities '(("org" . 3)
                                   ("melpa" . 2)
                                   ("gnu" . 1)))
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(setq use-package-verbose t)
(setq use-package-always-ensure t)  ;; Set the default to automatically install packages if they are not availably yet.
(eval-when-compile
  (require 'use-package))

(use-package diminish)


;; init-10-general.el --- General settings
;; Copyright (C) 2019 Andreas Wacknitz
(require 'use-package)


;(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))     ;; Remove menu bar
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))      ;; Remove toolbar
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))  ;; Remove scrollbar
(if window-system (scroll-bar-mode -1))
(if (fboundp 'tooltip-mode)    (tooltip-mode -1))     ;; No tooltips
(setq inhibit-startup-message t)   ;; Disable startup message
(setq inhibit-splash-screen t)
(setq ring-bell-function 'ignore)  ;; Disable raping your ears with error ring tone
(setq initial-scratch-message nil) ;; Disable text in scratch

;; UTF-8 please
(set-language-environment "UTF-8")   ; Set input
(setq locale-coding-system 'utf-8)   ; pretty
(set-terminal-coding-system 'utf-8)  ; pretty
(set-keyboard-coding-system 'utf-8)  ; pretty
(set-selection-coding-system 'utf-8) ; please
(prefer-coding-system 'utf-8)        ; with sugar on top

;; Set font
(if (> (x-display-pixel-height) 1200)
    (set-frame-font "Fira Code 20" nil t)
  (set-frame-font "Fira Code 15" nil t))


(use-package telephone-line
	:config
	(setq telephone-line-lhs
	  '((evil   . (telephone-line-evil-tag-segment))
		(accent . (telephone-line-vc-segment
					telephone-line-erc-modified-channels-segment
					telephone-line-process-segment))
		(nil    . (telephone-line-minor-mode-segment
					telephone-line-buffer-segment))))
	(setq telephone-line-rhs
		  '((nil    . (telephone-line-misc-info-segment))
			(accent . (telephone-line-major-mode-segment))
			(evil   . (telephone-line-airline-position-segment))))
	(telephone-line-mode t))


(defun set-frame-size-according-to-resolution ()
  (interactive)
  (if window-system
      (progn
        ;; use 120 char wide window for largeish displays
        ;; and smaller 80 column windows for smaller displays
        ;; pick whatever numbers make sense for you
        (if (> (x-display-pixel-width) 1280)
            (add-to-list 'default-frame-alist (cons 'width 120))
          (add-to-list 'default-frame-alist (cons 'width 80)))
        ;; for the height, subtract a couple hundred pixels
        ;; from the screen height (for panels, menubars and
        ;; whatnot), then divide by the height of a char to
        ;; get the height we want
        (add-to-list 'default-frame-alist
                     (cons 'height (/ (- (x-display-pixel-height) 320)
                                      (frame-char-height)))))))

(set-frame-size-according-to-resolution)


;; Pretty
;; Base set of pretty symbols.
(defvar base-prettify-symbols-alist '(("lambda" . ?λ)))

(defun my-lisp-prettify-symbols-hook ()
  "Set pretty symbols for lisp modes."
  (setq prettify-symbols-alist base-prettify-symbols-alist))

(defun my-python-prettify-symbols-hook ()
  "Set pretty symbols for python."
  (setq prettify-symbols-alist base-prettify-symbols-alist))

(defun my-js-prettify-symbols-hook ()
  "Set pretty symbols for JavaScript."
  (setq prettify-symbols-alist
        (append '(("function" . ?ƒ)) base-prettify-symbols-alist)))

(defun my-prettify-symbols-hook ()
  "Set pretty symbols for non-lisp programming modes."
  (setq prettify-symbols-alist
        (append '(("==" . ?≡)
                  ("!=" . ?≠)
                  ("<=" . ?≤)
                  (">=" . ?≥)
                  ("<-" . ?←)
                  ("->" . ?→)
                  ("<=" . ?⇐)
                  ("=>" . ?⇒))
                base-prettify-symbols-alist)))

;; Hook 'em up.
(add-hook 'emacs-lisp-mode-hook 'my-lisp-prettify-symbols-hook)
(add-hook 'web-mode-hook 'my-prettify-symbols-hook)
(add-hook 'js-mode-hook 'my-js-prettify-symbols-hook)
(add-hook 'python-mode-hook 'my-python-prettify-symbols-hook)
(add-hook 'prog-mode-hook 'my-prettify-symbols-hook)
;; (global-prettify-symbols-mode 1);; Base set of pretty symbols.

(setq tramp-default-method "ssh")          ;; Default connection method for TRAMP - remote files plugin
(setq gc-cons-threshold (* 100 1024 1024)) ;; Reduce the frequency of garbage collection (default is 0.76MB, this sets it to 100 MB)
(setq-default truncate-lines nil)          ;; Word Wrap (t is no wrap, nil is wrap)
(setq show-paren-delay 0)                  ;; Show matching parens
(show-paren-mode 1)
(save-place-mode t)                        ;; Save places
(setq save-place-file (expand-file-name "places" user-emacs-directory))
(cua-mode t)
;(global-linum-mode t)              ;; enable line numbers globally

(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
(setq-default c-basic-offset 4)
;(setq make-backup-files nil)        ;; stop creating backup~ files
(setq auto-save-default nil)        ;; stop creating #autosave# files
(setq vc-make-backup-files t)       ;; Make backups of files, even when they're in version control.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory)) ;; Keep emacs Custom-settings in separate file.
(load custom-file 'NOERROR)
(setq backup-directory-alist        ;; Write backup files to own directory
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))
(setq initial-major-mode 'org-mode) ;; Productive default mode
(setq-default x-stretch-cursor t)   ;; When on a tab, make the cursor the tab length.
(setq save-interprogram-paste-before-kill nil) ;; Fix empty pasteboard error.
(setq select-enable-primary nil)    ;; Don't automatically copy selected text
(setq-default frame-title-format    ;; Add filepath to frame title
              '(:eval (format "%s (%s)"
                              (buffer-name)
                              (when (buffer-file-name)
                                (abbreviate-file-name (buffer-file-name))))))

;; (defun display-startup-echo-area-message () ;; Change mini buffer startup message
;;   (message "system type: %s" system-type))

(defalias 'yes-or-no-p 'y-or-n-p) ;; y/n for yes/no confirmation dial

(setq-default fill-column 80)      ;; Set default fill column
(setq visible-bell nil)            ;; quiet, please! No dinging!
(setq ring-bell-function 'ignore)
(setq make-backup-files nil)       ;; No Backup Files

;;; Customize the modeline
(setq line-number-mode 1)
(setq column-number-mode 1)

(when window-system ;; Full path in frame title
  (setq frame-title-format '(buffer-file-name "%f" ("%b"))))

(global-auto-revert-mode 1)         ;; Auto refresh buffers when edits occur outside emacs
(setq echo-keystrokes 0.1)          ;; Show keystrokes in progress
(setq delete-by-moving-to-trash t)  ;; Move files to trash when deleting
(auto-compression-mode t)           ;; Transparently open compressed files
(global-font-lock-mode t)           ;; Enable syntax highlighting for older Emacsen that have it off
(electric-pair-mode 1)              ;; Auto-close brackets and double quotes
(defalias 'yes-or-no-p 'y-or-n-p)   ;; Answering just 'y' or 'n' will do

(delete-selection-mode 1)           ;; Remove text in active region if inserting text
(setq line-number-mode t)           ;; Always display line and numbers
(setq column-number-mode t)         ;; Always display column numbers
(setq fill-column 80)               ;; Lines should be 80 characters wide, not 72

;; Smooth Scroll:
(setq mouse-wheel-scroll-amount '(1 ((shift) .1))) ;; one line at a time
(setq scroll-conservatively 10000)                 ;; Scrol one line when hitting bottom of window

;; Change Cursor
(setq-default cursor-type 'box)
(blink-cursor-mode 0)

(global-subword-mode 1)                      ;; Easily navigate sillycased words
(set-default 'sentence-end-double-space nil) ;; Sentences do not need double spaces to end. Period.


;; Indentation
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)


;; Browser
(setq browse-url-browser-function 'browse-url-xdg-open)


;; eval-expression-print-level needs to be set to nil (turned off) so
;; that you can always see what's happening.
(setq eval-expression-print-level nil)

;; Allow clipboard from outside emacs
(setq save-interprogram-paste-before-kill t
      mouse-yank-at-point t)

;; Winner Mode allows you to “undo” (and “redo”) changes in the window configuration with the key commands ‘C-c left’ and ‘C-c right’.
(setq winner-mode 1)
(defalias 'list-buffers 'ibuffer)

;; ace-window: Enhance windows support (try C-X3, C-X3, C-Xo)
(use-package ace-window
  :init
  (global-set-key [remap other-window] 'ace-window)
  (custom-set-faces
   '(aw-leading-char-face
     ((t (:inherit ace-jump-face-background :height 3.0))))))


;; Ido - Interactively do things
;; show any name that has the chars I typed
;;  I don't use this because I prefer swiper:
;; (use-package ido
;;   :init
;;   (setq ido-enable-flex-matching t)
;;   (setq ido-everywhere t)
;;   (ido-mode 1)
;;   (setq ido-create-new-buffer 'always) ;; other choices are prompt and never
;;   (setq ido-file-extensions-order '(".org" ".txt" ".py" ".emacs" ".xml" ".el" ".ini"))
;;   (setq ido-ignore-extensions t)       ;; to make Ido use completion-ignored-extensions
;;   (setq ido-use-filename-at-point 'guess))


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


;; Folding
(use-package hideshow
  :hook ((prog-mode . hs-minor-mode)))

(defun toggle-fold ()
  (interactive)
  (save-excursion
    (end-of-line)
    (hs-toggle-hiding)))


;;
(use-package all-the-icons)


;; Theme
(use-package material-theme
	:config (load-theme 'material t))

;; (use-package zenburn-theme
;;   :config (load-theme 'zenburn t))

;; (use-package doom-themes
;;  :config
;;    (setq doom-one-brighter-comments t)
;;    (load-theme 'doom-vibrant t))


(setq holiday-general-holidays
      '((holiday-fixed 1 1 "Neujahr")
        (holiday-fixed 5 1 "Tag der Arbeit")
        (holiday-fixed 10 3 "Tag der deutschen Einheit")))
(setq holiday-christian-holidays
      '((holiday-fixed 12 25 "1. Weihnachtstag")
        (holiday-fixed 12 26 "2. Weihnachtstag")
        (holiday-fixed 1 6 "Heilige 3 Könige")
        (holiday-fixed 10 31 "Reformationstag")
        (holiday-fixed 11 1 "Allerheiligen")
        ;; Date of Easter calculation taken from holidays.el.
        (let* ((century (1+ (/ displayed-year 100)))
               (shifted-epact (% (+ 14 (* 11 (% displayed-year 19))
                                    (- (/ (* 3 century) 4))
                                    (/ (+ 5 (* 8 century)) 25)
                                    (* 30 century))
                                 30))
               (adjusted-epact (if (or (= shifted-epact 0)
                                       (and (= shifted-epact 1)
                                            (< 10 (% displayed-year 19))))
                                   (1+ shifted-epact)
                                 shifted-epact))
               (paschal-moon (- (calendar-absolute-from-gregorian
                                 (list 4 19 displayed-year))
                                adjusted-epact))
               (easter (calendar-dayname-on-or-before 0 (+ paschal-moon 7))))
          (holiday-filter-visible-calendar
           (mapcar
            (lambda (l)
              (list (calendar-gregorian-from-absolute (+ easter (car l)))
                    (nth 1 l)))
            '(( -2 "Karfreitag")
              (  0 "Ostersonntag")
              ( +1 "Ostermontag")
              (+39 "Christi Himmelfahrt")
              (+49 "Pfingstsonntag")
              (+50 "Pfingstmontag")
              (+60 "Fronleichnam")))))))
(setq calendar-holidays (append holiday-general-holidays holiday-christian-holidays))

;; init-20-bindings.el  --- keyboard bindings
;;
;; Explanations about Emacs special keys
;;
;; Notation | Symbolics Keyboard | PC keyboard   | Mac keyboard
;; C           Control             <ctrl>          <ctrl>
;; M           Meta                <alt>           <option>
;; s           Super                               <command>
;; H           Hyper               <windows>       <fn>
;; S           Shift               <shift>         <shift>
;;

(global-set-key (kbd "<f5>") 'speedbar)
(global-set-key (kbd "<f12>") 'make-frame-command)


;; Bindings to own functions: 
(defun gcm-scroll-down ()
  (interactive)
  (scroll-up 4))
(defun gcm-scroll-up ()
  (interactive)
  (scroll-down 4))
(global-set-key (kbd "M-p") 'gcm-scroll-up)
(global-set-key (kbd "M-n") 'gcm-scroll-down)


(defun duplicate-line ()
  (interactive)
  (let ((col (current-column)))
    (move-beginning-of-line 1)
    (kill-line)
    (yank)
    (newline)
    (yank)
    (move-to-column col)))
(global-set-key (kbd "C-S-d") 'duplicate-line)


(defun move-line-down ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (forward-line)
      (transpose-lines 1))
    (forward-line)
    (move-to-column col)))
(global-set-key (kbd "C-S-j") 'move-line-down)


(defun move-line-up ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (forward-line)
      (transpose-lines -1))
    (forward-line -1)
    (move-to-column col)))
(global-set-key (kbd "C-S-k") 'move-line-up)

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
         ("C-c k" . counsel-ag)
         ("C-x l" . counsel-locate)
         ("C-c g" . counsel-git-grep)
         ("C-c h i" . counsel-imenu)
         ("C-x p" . counsel-list-processes))
  :init (counsel-mode 1)
  :config
  (ivy-set-actions
           'counsel-find-file
           '(("j" find-file-other-window "other")))
  (ivy-set-actions 'counsel-git-grep
                   '(("j" find-file-other-window "other"))))

;; avy - jump to character
(use-package avy
  :config
  (avy-setup-default)
  :bind ("M-s" . avy-goto-char))

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
    (ws-butler-global-mode 1)
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
;; Easy project management and navigation.
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


(use-package nginx-mode
  :mode "\\.nginx\\'")



;; (use-package mu4e
;; ;;  :load-path "/usr/share/emacs/site-lisp/mu4e"
;;   :commands mu4e
;;   :config
;;   (use-package mu4e-contrib)
;;   (if mail-on
;;       (progn
;;         (setq mu4e-html2text-command
;;               'mu4e-shr2text)
;;         (setq mu4e-context-policy 'pick-first)
;;         (setq mu4e-completing-read-function 'ivy-completing-read)
;;         (setq message-send-mail-function 'smtpmail-send-it)
;;         (setq mu4e-view-html-plaintext-ratio-heuristic 50)
;;         (setq mu4e-contexts
;;               (list ((make-mu4e-context
;;                      :name "gmx"
;;                      :enter-func (lambda () (mu4e-message "Switch to the gmx context"))
;;                      :match-func (lambda (msg)
;;                                    (when msg
;;                                      (s-prefix? "/gmx" (mu4e-message-field msg :maildir))))
;;                      :vars '((user-mail-address . "a.wacknitz@gmx.de")
;;                              (mu4e-sent-folder . "/gmx/sent")
;;                              (mu4e-drafts-folder . "/gmx/drafts")
;;                              (mu4e-trash-folder . "/gmx/trash")
;;                              (mu4e-sent-messages-behavior . delete)
;;                              (smtpmail-default-smtp-server . "smtp.gmx.net")
;;                              (smtpmail-smtp-server . "smtp.gmx.net")
;;                              (smtpmail-stream-type . starttls)
;;                              (smtpmail-smtp-service . 587)))
;;                     (make-mu4e-context
;;                      :name "webde"
;;                      :enter-func (lambda () (mu4e-message "Switch to web.de context"))
;;                      :match-func (lambda (msg)
;;                                    (when
;;                                        msg (mu4e-message-contact-field-matches
;;                                             msg :to "lurge@web.de")))
;;                      :vars '((user-mail-address . "lurge@web.de")
;;                              (mu4e-sent-folder . "/web/sent")
;;                              (mu4e-drafts-folder . "/web/drafts")
;;                              (mu4e-sent-messages-behavior . sent)
;;                              (smtpmail-default-smtp-server . "smtp.web.de")
;;                              (smtpmail-smtp-server . "smtp.web.de")
;;                              (smtpmail-stream-type . starttls)
;;                              (smtpmail-smtp-service . 587)))))
;;         (setq mu4e-maildir "~/mail")
;;         (setq mu4e-get-mail-command "mbsync -a")
;;         (setq mu4e-update-interval 300)
;;         (setq mu4e-view-show-addresses t)
;;         (setq mu4e-headers-include-related t)
;;         (setq mu4e-headers-show-threads nil)
;;         (setq mu4e-headers-skip-duplicates t)
;;         (setq mu4e-split-view 'vertical)
;;         (setq
;;          user-full-name  "Andreas Wacknitz"
;;          mu4e-compose-signature ""
;;          mu4e-compose-signature-auto-include nil
;;          mu4e-attachment-dir "~/Downloads")
;;         (setq mu4e-maildir-shortcuts
;;               '(("/gmx/inbox"     . ?g)
;;                 ("/webde/inbox"       . ?w)
;;                 ("/purelyfunctional/inbox" . ?p)))

;;         (setq mu4e-bookmarks '(("flag:unread AND NOT flag:trashed AND NOT maildir:/gmail/spam AND NOT maildir:/purelyfunctional/haskell AND NOT maildir:/purelyfunctional/github"
;;                                 "Unread messages"     ?u)
;;                                ("date:today..now"                  "Today's messages"     ?t)
;;                                ("date:7d..now"                     "Last 7 days"          ?w)
;;                                ("mime:image/*"                     "Messages with images" ?p)
;;                                ("maildir:/purelyfunctional/haskell" "haskell" ?h)))

;;         (add-hook 'mu4e-compose-mode-hook 'mml-secure-message-sign)
;;         (add-hook 'mu4e-view-mode-hook '(lambda ()
;;                                           (local-set-key (kbd "<end>") 'end-of-line)
;;                                           (local-set-key (kbd "<home>") 'beginning-of-line)))
;;         (when (fboundp 'imagemagick-register-types)
;;           (imagemagick-register-types))
;;         (add-to-list 'mu4e-view-actions
;;                      '("View in browser" . mu4e-action-view-in-browser) t)

;;         ;; don't keep message buffers around
;;         (setq message-kill-buffer-on-exit t))))


;; org mode, markdown on steroids
(use-package org
  :ensure t
  :mode ("\\.org\\'" . org-mode)
  :bind (("C-c l" . org-store-link)
         ("C-c c" . org-capture)
         ("C-c a" . org-agenda)
         ("C-c b" . org-iswitchb)
         ("C-c C-w" . org-refile)
         ("C-c j" . org-clock-goto)
         ("C-c C-x C-o" . org-clock-out))
  :config
  (progn
    ;; The GTD part of this config is heavily inspired by
    ;; https://emacs.cafe/emacs/orgmode/gtd/2017/06/30/orgmode-gtd.html
    (setq org-directory "~/org")
    (setq org-agenda-files
          (mapcar (lambda (path) (concat org-directory path))
                  '("/org.org"
                    "/gtd/gtd.org"
                    "/gtd/inbox.org"
                    "/gtd/tickler.org")))
    (setq org-log-done 'time)
    (setq org-src-fontify-natively t)
    (setq org-use-speed-commands t)
    (setq org-capture-templates
          '(("t" "Todo [inbox]" entry
             (file+headline "~/org/gtd/inbox.org" "Tasks")
             "* TODO %i%?")
            ("T" "Tickler" entry
             (file+headline "~/org/gtd/tickler.org" "Tickler")
             "* %i%? \n %^t")))
    (setq org-refile-targets
          '(("~/org/gtd/gtd.org" :maxlevel . 3)
            ("~/org/gtd/someday.org" :level . 1)
            ("~/org/gtd/tickler.org" :maxlevel . 2)))
    (setq org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))
    (setq org-agenda-custom-commands
          '(("@" "Contexts"
             ((tags-todo "@email"
                         ((org-agenda-overriding-header "Emails")))
              (tags-todo "@phone"
                         ((org-agenda-overriding-header "Phone")))))))
    (setq org-clock-persist t)
    (org-clock-persistence-insinuate)
    (setq org-time-clocksum-format '(:hours "%d" :require-hours t :minutes ":%02d" :require-minutes t))))

(use-package org-bullets
  :ensure t
  :commands (org-bullets-mode)
  :init (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))


;; PDF Tools
(use-package pdf-tools
  ;;:pin manual ;; manually update
  :magic ("%PDF" . pdf-view-mode)
  :config
  ;; initialise
  (pdf-tools-install)
  ;; open pdfs scaled to fit page
  (setq-default pdf-view-display-size 'fit-width)
  ;; use normal isearch
  (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward))


;; LaTeX
(use-package tex-site
   :ensure auctex
   :mode ("\\.tex\\'" . latex-mode)
   :config
   (setq-default TeX-master nil)
   (add-hook 'LaTeX-mode-hook
 	    (lambda ()
 	      (rainbow-delimiters-mode)
 	      (company-mode)
 	      (smartparens-mode)
 	      (turn-on-reftex)))
    ;; Update PDF buffers after successful LaTeX runs
    (add-hook 'TeX-after-TeX-LaTeX-command-finished-hook #'TeX-revert-document-buffer)
    ;; to use pdfview with auctex
    (add-hook 'LaTeX-mode-hook 'pdf-tools-install))



(cond
 ((string-equal system-type "gnu/linux")
  (progn
    (setq-default tide-tsserver-executable "/home/andreas/npm/bin/tsserver")
    ;;https://github.com/jaypei/emacs-neotree
    (use-package neotree
      :init
      (setq-default neo-show-hidden-files t)
      (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
      (global-set-key [f8] 'neotree-toggle))
    ))
 ((string-equal system-type "darwin")
  (progn
    (setq-default tide-tsserver-executable "/Users/andreas/npm/bin/tsserver")

    ;; set keys for Apple keyboard, for emacs in OS X
    (setq mac-command-modifier 'super)   ; make cmdhk key do Meta
    (setq mac-option-modifier  'meta)    ; make opt key do Super
    (setq mac-control-modifier 'control) ; make Control key do Control
    (setq ns-function-modifier 'hyper)   ; make Fn key do Hyper

    ;; MacOS has bindings for <home> and <end> to *-of-buffer:
    (global-set-key (kbd "<home>") 'beginning-of-line)
    (global-set-key (kbd "C-<home>") 'beginning-of-buffer)
    (global-set-key (kbd "<end>") 'end-of-line)
    (global-set-key (kbd "C-<end>") 'end-of-buffer)
    
    ;; https://github.com/Alexander-Miller/treemacs
    (use-package treemacs
      :defer t
      :init
      (with-eval-after-load 'winum
        (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
      :config
      (progn
        (setq treemacs-collapse-dirs              (if (executable-find "python") 3 0)
              treemacs-deferred-git-apply-delay   0.5
              treemacs-display-in-side-window     t
              treemacs-file-event-delay           5000
              treemacs-file-follow-delay          0.2
              treemacs-follow-after-init          t
              treemacs-recenter-distance          0.1
              treemacs-git-command-pipe           ""
              treemacs-goto-tag-strategy          'refetch-index
              treemacs-indentation                2
              treemacs-indentation-string         " "
              treemacs-is-never-other-window      nil
              treemacs-max-git-entries            5000
              treemacs-no-png-images              nil
              treemacs-no-delete-other-windows    t
              treemacs-project-follow-cleanup     nil
              treemacs-persist-file               (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
              treemacs-recenter-after-file-follow nil
              treemacs-recenter-after-tag-follow  nil
              treemacs-show-cursor                nil
              treemacs-show-hidden-files          t
              treemacs-silent-filewatch           nil
              treemacs-silent-refresh             nil
              treemacs-sorting                    'alphabetic-desc
              treemacs-space-between-root-nodes   t
              treemacs-tag-follow-cleanup         t
              treemacs-tag-follow-delay           1.5
              treemacs-width                      35)

        ;; The default width and height of the icons is 22 pixels. If you are
        ;; using a Hi-DPI display, uncomment this to double the icon size.
        ;;(treemacs-resize-icons 44)

        (treemacs-follow-mode t)
        (treemacs-filewatch-mode t)
        (treemacs-fringe-indicator-mode t)
        (pcase (cons (not (null (executable-find "git")))
                     (not (null (executable-find "python3"))))
          (`(t . t)
           (treemacs-git-mode 'deferred))
          (`(t . _)
           (treemacs-git-mode 'simple))))
      :bind
      (:map global-map
            ("M-0"       . treemacs-select-window)
            ("C-x t 1"   . treemacs-delete-other-windows)
            ;; ("C-x t t"   . treemacs)
            ("<f8>"      . treemacs)
            ("C-x t B"   . treemacs-bookmark)
            ("C-x t C-t" . treemacs-find-file)
            ("C-x t M-t" . treemacs-find-tag)))

    (use-package treemacs-projectile
      :after treemacs projectile)

    (use-package treemacs-icons-dired
      :after treemacs dired
      :config (treemacs-icons-dired-mode))

    (use-package treemacs-magit
      :after treemacs magit)
    ))
 ((string-equal system-type "usg-unix-v") ; UNIX System V
  (progn
    (setq-default tide-tsserver-executable "/export/home/andreas/npm/bin/tsserver")
    ;; We have a problem with graphics in OpenIndiana, thus we use the simpler neotree for it.
    ;; treemacs is also not working for Debian Stretch (emacs-25.1.1).
    ;;https://github.com/jaypei/emacs-neotree
    (use-package neotree
      :init
      (setq-default neo-show-hidden-files t)
      (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
      (global-set-key [f8] 'neotree-toggle)
      )
    ))
 ((string-equal system-type "windows-nt") ; Microsoft Windows
  (progn
    (setq-default tide-tsserver-executable "c:/Users/andreas/AppData/Roaming/npm/bin/tsserver")
    ;; make PC keyboard's Win key or other to type Super or Hyper, for emacs running on Windows.
    (setq w32-pass-lwindow-to-system nil)
    (setq w32-lwindow-modifier 'super)    ; Left Windows key
    (setq w32-pass-rwindow-to-system nil)
    (setq w32-rwindow-modifier 'super)    ; Right Windows key
    (setq w32-pass-apps-to-system nil)
    (setq w32-apps-modifier 'hyper)       ; Menu/App key

    ;; https://github.com/Alexander-Miller/treemacs
    (use-package treemacs
      :defer t
      :init
      (with-eval-after-load 'winum
        (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
      :config
      (progn
        (setq treemacs-collapse-dirs              (if (executable-find "python") 3 0)
              treemacs-deferred-git-apply-delay   0.5
              treemacs-display-in-side-window     t
              treemacs-file-event-delay           5000
              treemacs-file-follow-delay          0.2
              treemacs-follow-after-init          t
              treemacs-recenter-distance          0.1
              treemacs-git-command-pipe           ""
              treemacs-goto-tag-strategy          'refetch-index
              treemacs-indentation                2
              treemacs-indentation-string         " "
              treemacs-is-never-other-window      nil
              treemacs-max-git-entries            5000
              treemacs-no-png-images              nil
              treemacs-no-delete-other-windows    t
              treemacs-project-follow-cleanup     nil
              treemacs-persist-file               (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
              treemacs-recenter-after-file-follow nil
              treemacs-recenter-after-tag-follow  nil
              treemacs-show-cursor                nil
              treemacs-show-hidden-files          t
              treemacs-silent-filewatch           nil
              treemacs-silent-refresh             nil
              treemacs-sorting                    'alphabetic-desc
              treemacs-space-between-root-nodes   t
              treemacs-tag-follow-cleanup         t
              treemacs-tag-follow-delay           1.5
              treemacs-width                      35)

        ;; The default width and height of the icons is 22 pixels. If you are
        ;; using a Hi-DPI display, uncomment this to double the icon size.
        ;;(treemacs-resize-icons 44)

        (treemacs-follow-mode t)
        (treemacs-filewatch-mode t)
        (treemacs-fringe-indicator-mode t)
        (pcase (cons (not (null (executable-find "git")))
                     (not (null (executable-find "python3"))))
          (`(t . t)
           (treemacs-git-mode 'deferred))
          (`(t . _)
           (treemacs-git-mode 'simple))))
      :bind
      (:map global-map
            ("M-0"       . treemacs-select-window)
            ("C-x t 1"   . treemacs-delete-other-windows)
            ;; ("C-x t t"   . treemacs)
            ("<f8>"      . treemacs)
            ("C-x t B"   . treemacs-bookmark)
            ("C-x t C-t" . treemacs-find-file)
            ("C-x t M-t" . treemacs-find-tag)))

    (use-package treemacs-projectile
      :after treemacs projectile)

    (use-package treemacs-icons-dired
      :after treemacs dired
      :config (treemacs-icons-dired-mode))

    (use-package treemacs-magit
      :after treemacs magit)
    ))
 )


(use-package server
  :config
  (progn
    (defun server-enable ()
      (unless (server-running-p)
        (server-start)))
    (add-hook 'after-init-hook 'server-enable t)))
