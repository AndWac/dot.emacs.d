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

;;(use-package doom-themes
;;  :config
;;  (progn
;;    (setq doom-one-brighter-comments t)
;;    (load-theme 'doom-vibrant t)))


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

