;; init-10-generic.el --- Generic emacs settings
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

;; eval-expression-print-level needs to be set to nil (turned off) so
;; that you can always see what's happening.
(setq eval-expression-print-level nil)

;; Allow clipboard from outside emacs
(setq save-interprogram-paste-before-kill t
      mouse-yank-at-point t)

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
