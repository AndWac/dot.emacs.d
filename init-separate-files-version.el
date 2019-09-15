;; My own .emacs / emacs.d/init.el file with collected configurations and packages.

;; User Info
(setq user-full-name "Andreas Wacknitz")
(setq user-mail-address "a.wacknitz@gmx.de")


(package-initialize nil)
(add-to-list 'package-archives
             '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
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


;; === General Settings ===
(load-file "~/.emacs.d/config/init-10-general.el")

;; === Keyboard Settings ===
(load-file "~/.emacs.d/config/init-20-keyboard.el")

;; === Generic Settings ===
(load-file "~/.emacs.d/config/init-30-generic.el")

;; === Develpoment Settings ===
(load-file "~/.emacs.d/config/init-40-dev.el")

;; === Web Settings ===
(load-file "~/.emacs.d/config/init-50-web.el")

;; === Python Settings ===
(load-file "~/.emacs.d/config/init-60-python.el")

;; === Org Settings ===
(load-file "~/.emacs.d/config/init-70-org.el")

;; === TeX Settings ===
(load-file "~/.emacs.d/config/init-80-tex.el")

;; === Experiments ===
(load-file "~/.emacs.d/config/init-95-experiments.el")


(cond
 ((string-equal system-type "windows-nt") ; Microsoft Windows
  (progn
    (load-file "~/.emacs.d/config/init-90-windows.el")
    ))
 ((string-equal system-type "darwin") ; Mac OS X
  (progn
    (load-file "~/.emacs.d/config/init-90-macos.el")
    ))
 ((string-equal system-type "usg-unix-v") ; UNIX System V
  (progn
    (load-file "~/.emacs.d/config/init-90-unix.el")
    ))
 ((string-equal system-type "gnu/linux") ; linux
  (progn
    (load-file "~/.emacs.d/config/init-90-linux.el")
    ))
 )


(load "server")
(unless (server-running-p) (server-start))
