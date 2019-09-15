;; init-20-keyboard.el --- emacs keyboard settings
;; Copyright (C) 2019 Andreas Wacknitz

(require 'use-package)

;; Explanation about Emacs special keys
;;
;; Notation | Symbolics Keyboard | PC keyboard   | Mac keyboard
;; C           Control             <ctrl>          <ctrl>
;; M           Meta                <alt>           <option>
;; s           Super                               <command>
;; H           Hyper               <windows>       <fn>
;; S           Shift               <shift>         <shift>
;;

;; Page scroll
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

;; Additional assignments:
(global-set-key (kbd "<f12>") 'make-frame-command)
(global-set-key (kbd "<f5>") 'speedbar)
