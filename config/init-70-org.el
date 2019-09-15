;;(load-file "~/.emacs.d/config/init-70-org.el")

;; init-70-org.el --- load org packages
;; Copyright (C) 2019 Andreas Wacknitz

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
;    (setq org-agenda-files
;          (mapcar (lambda (path) (concat org-directory path))
;                  '("/org.org"
;                    "/gtd/gtd.org"
;                    "/gtd/inbox.org"
;                    "/gtd/tickler.org")))
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
