;; Boostrapping
(require 'gnutls)
(if (string-equal system-type "usg-unix-v")
    (add-to-list 'gnutls-trustfiles "/etc/certs/ca-certificates.crt"))

(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(
;;                         ("org"       . "https://orgmode.org/elpa/")
                         ("melpa"     . "https://melpa.org/packages/")
                         ("gnu"       . "http://elpa.gnu.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(org-babel-load-file (expand-file-name "myinit.org" user-emacs-directory))
