;; Boostrapping
(require 'gnutls)
(if (string-equal system-type "usg-unix-v")
    (add-to-list 'gnutls-trustfiles "/etc/certs/ca-certificates.crt"))

(require 'package)

(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("org" . "https://orgmode.org/elpa/"))
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(setq package-archive-priorities '(("org" . 3)
                                   ("melpa" . 2)
                                   ("gnu" . 1)))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(org-babel-load-file (expand-file-name "myinit.org" user-emacs-directory))
