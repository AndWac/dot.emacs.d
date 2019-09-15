;;(load-file "~/.emacs.d/config/init-80-tex.el")
;; init-80-tex.el --- load TeX packages
;; Copyright (C) 2019 Andreas Wacknitz


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
;; (use-package tex-site
;;   :ensure auctex
;;   :mode ("\\.tex\\'" . latex-mode)
;;   :config
;;   (setq-default TeX-master nil)
;;   (add-hook 'LaTeX-mode-hook
;; 	    (lambda ()
;; 	      (rainbow-delimiters-mode)
;; 	      (company-mode)
;; 	      (smartparens-mode)
;; 	      (turn-on-reftex)
;; 	      ))

;; Update PDF buffers after successful LaTeX runs
;;  (add-hook 'TeX-after-TeX-LaTeX-command-finished-hook #'TeX-revert-document-buffer)

;; to use pdfview with auctex
;;  (add-hook 'LaTeX-mode-hook 'pdf-tools-install))
