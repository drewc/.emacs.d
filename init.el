(desktop-save-mode 1)

(require 'package)
(setq package-archives
'(("melpa" . "http://melpa.org/packages/")
	("gnu" . "http://elpa.gnu.org/packages/")
	("org" . "https://orgmode.org/elpa/")))

;; add melpa stable
(add-to-list 'package-archives
	 '("melpa-stable" . "https://stable.melpa.org/packages/"))

;; Not needed? (package-initialize)

;; Make sure we load all packages
(setq package-load-list '(all))

;; This solution is better suited to "embed" Spacemacs into your own
;; configuration. Say you cloned Spacemacs in ~/.emacs.d/spacemacs/ then
;; drop these lines in ~/.emacs.d/init.el:

(setq spacemacs-start-directory "~/.emacs.d/spacemacs/")
(load-file (concat spacemacs-start-directory "init.el"))

(use-package notmuch)

(use-package slime
  :ensure  t 
  :config (setq inferior-lisp-program "sbcl")
    (setq slime-contribs '(slime-repl)))

(add-to-list 'load-path "~/.emacs.d/gerbil")
(require 'gerbil)
(add-hook 'gerbil-mode-hook 'slime-mode)

(use-package org
  :ensure org-plus-contrib
  :config
  (require 'org-notmuch)
  (require 'ob-sql)
  (require 'ob-shell))

;; spacemacs does this sort of thing
;; 

;; 

 ;; (eval-when-compile
 ;;   (add-to-list 'load-path "~/.emacs.d/use-package")
 ;;   (require 'use-package))
 ;; 
 ;;   ;; Make sure we install all packages.
 ;; (setq use-package-always-ensure t)  

 ;; (use-package auto-package-update
 ;;   :config
 ;;   (setq auto-package-update-delete-old-versions nil)
 ;;   (setq auto-package-update-hide-results nil)
 ;;   (auto-package-update-maybe))

 ;; spacemacs
 ;; (use-package magit :ensure t :pin melpa-stable)

 ;; (use-package helm
 ;;   :bind (("C-x b" . helm-mini)
 ;; 	 ([remap execute-extended-command]. helm-M-x)
 ;; 	 ([remap find-file] . helm-find-files)
 ;; 	 ([remap list-buffers] . helm-buffers-list))
 ;;   :config
 ;;   (define-key lisp-interaction-mode-map
 ;;     [remap completion-at-point] 'helm-lisp-completion-at-point)
 ;;   (define-key emacs-lisp-mode-map
 ;;     [remap completion-at-point] 'helm-lisp-completion-at-point))
 ;;
