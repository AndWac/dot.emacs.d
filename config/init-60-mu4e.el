

(use-package mu4e
;;  :load-path "/usr/share/emacs/site-lisp/mu4e"
  :commands mu4e
  :config
  (use-package mu4e-contrib)
  (if mail-on
      (progn
        (setq mu4e-html2text-command
              'mu4e-shr2text)
        (setq mu4e-context-policy 'pick-first)
        (setq mu4e-completing-read-function 'ivy-completing-read)
        (setq message-send-mail-function 'smtpmail-send-it)
        (setq mu4e-view-html-plaintext-ratio-heuristic 50)
        (setq mu4e-contexts
              (list ((make-mu4e-context
                     :name "gmx"
                     :enter-func (lambda () (mu4e-message "Switch to the gmx context"))
                     :match-func (lambda (msg)
                                   (when msg
                                     (s-prefix? "/gmx" (mu4e-message-field msg :maildir))))
                     :vars '((user-mail-address . "a.wacknitz@gmx.de")
                             (mu4e-sent-folder . "/gmx/sent")
                             (mu4e-drafts-folder . "/gmx/drafts")
                             (mu4e-trash-folder . "/gmx/trash")
                             (mu4e-sent-messages-behavior . delete)
                             (smtpmail-default-smtp-server . "smtp.gmx.net")
                             (smtpmail-smtp-server . "smtp.gmx.net")
                             (smtpmail-stream-type . starttls)
                             (smtpmail-smtp-service . 587)))
                    (make-mu4e-context
                     :name "webde"
                     :enter-func (lambda () (mu4e-message "Switch to web.de context"))
                     :match-func (lambda (msg)
                                   (when
                                       msg (mu4e-message-contact-field-matches
                                            msg :to "lurge@web.de")))
                     :vars '((user-mail-address . "lurge@web.de")
                             (mu4e-sent-folder . "/web/sent")
                             (mu4e-drafts-folder . "/web/drafts")
                             (mu4e-sent-messages-behavior . sent)
                             (smtpmail-default-smtp-server . "smtp.web.de")
                             (smtpmail-smtp-server . "smtp.web.de")
                             (smtpmail-stream-type . starttls)
                             (smtpmail-smtp-service . 587)))))
        (setq mu4e-maildir "~/mail")
        (setq mu4e-get-mail-command "mbsync -a")
        (setq mu4e-update-interval 300)
        (setq mu4e-view-show-addresses t)
        (setq mu4e-headers-include-related t)
        (setq mu4e-headers-show-threads nil)
        (setq mu4e-headers-skip-duplicates t)
        (setq mu4e-split-view 'vertical)
        (setq
         user-full-name  "Andreas Wacknitz"
         mu4e-compose-signature ""
         mu4e-compose-signature-auto-include nil
         mu4e-attachment-dir "~/Downloads")
        (setq mu4e-maildir-shortcuts
              '(("/gmx/inbox"     . ?g)
                ("/webde/inbox"       . ?w)
                ("/purelyfunctional/inbox" . ?p)))

        (setq mu4e-bookmarks '(("flag:unread AND NOT flag:trashed AND NOT maildir:/gmail/spam AND NOT maildir:/purelyfunctional/haskell AND NOT maildir:/purelyfunctional/github"
                                "Unread messages"     ?u)
                               ("date:today..now"                  "Today's messages"     ?t)
                               ("date:7d..now"                     "Last 7 days"          ?w)
                               ("mime:image/*"                     "Messages with images" ?p)
                               ("maildir:/purelyfunctional/haskell" "haskell" ?h)))

        (add-hook 'mu4e-compose-mode-hook 'mml-secure-message-sign)
        (add-hook 'mu4e-view-mode-hook '(lambda ()
                                          (local-set-key (kbd "<end>") 'end-of-line)
                                          (local-set-key (kbd "<home>") 'beginning-of-line)))
        (when (fboundp 'imagemagick-register-types)
          (imagemagick-register-types))
        (add-to-list 'mu4e-view-actions
                     '("View in browser" . mu4e-action-view-in-browser) t)

        ;; don't keep message buffers around
        (setq message-kill-buffer-on-exit t))))
