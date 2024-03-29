;; Straight bootstrap
(defvar bootstrap-version)
(let ((bootstrap-file
	 (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
	(bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	  (url-retrieve-synchronously
	   "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
	   'silent 'inhibit-cookies)
	(goto-char (point-max))
	(eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Set up use-package for tidier package configuration/installation
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

(setq ns-command-modifier 'meta)
(setq  mac-command-modifier 'meta)

(straight-use-package 'org)
(require 'ox-md) (require 'org-indent)
(org-babel-do-load-languages
   'org-babel-load-languages
   '((sql . t)
     (shell . t)))

(let ((rd (expand-file-name "./roam/" (file-name-directory user-init-file))))
  (dolist (f (directory-files rd t "\.el$")) (load f)))

(use-package outli
  :straight (outli :type git :host github :repo "jdtsmith/outli")
  :bind (:map outli-mode-map ; convenience key to get back to containing heading
	      ("C-c C-p" . (lambda () (interactive) (outline-back-to-heading)))))

(use-package ox-gfm)
(require 'ox-gfm)

(use-package org-make-toc
  :config
   (setq org-make-toc-insert-custom-ids t))

(desktop-save-mode 1)

(use-package evil)
(require 'evil)
(evil-mode 1)

(use-package bnf-mode)

(eval-and-compile
  (setq *gerbil-path*
	(or (getenv "GERBIL_INSTALL_PREFIX")
	    (shell-command-to-string "gxi -e '(display (path-expand \"~~\"))'\
   -e '(flush-output-port)'")))
  (setq font-lock-reference-face font-lock-constant-face)
  (defun %gerbil-load-path ()
     (expand-file-name "share/emacs/site-lisp/" *gerbil-path*)))

(use-package gerbil-mode
  :when (file-directory-p *gerbil-path*)
  :load-path (lambda () (list (%gerbil-load-path)))
  :ensure nil
  :straight nil
  ;;:demand t
 ;; :defer t
  :mode (("\\.ss\\'"  . gerbil-mode)
         ("\\.pkg\\'" . gerbil-mode))
  :bind (:map comint-mode-map
	      (("C-S-n" . comint-next-input)
	       ("C-S-p" . comint-previous-input)
	       ("C-S-l" . clear-comint-buffer))
	      :map gerbil-mode-map
	      (("C-S-l" . clear-comint-buffer)))
  ;; :init
  ;; (autoload 'gerbil-mode
  ;;   (expand-file-name "share/emacs/site-lisp/gerbil-mode.el" *gerbil-path*)
  ;;   "Gerbil editing mode." t)
   :hook
   ((gerbil-mode . display-line-numbers-mode)
    (inferior-scheme-mode . gambit-inferior-mode)
    (scheme-mode . gerbil-mode))

  :config
  (require 'gambit
           (expand-file-name "share/emacs/site-lisp/gambit.el" *gerbil-path*))
  (setf scheme-program-name (expand-file-name "bin/gxi -:te" *gerbil-path*))

  (let ((tags (locate-dominating-file default-directory "TAGS")))
    (when tags (visit-tags-table tags)))
  (let ((tags (expand-file-name "src/TAGS" *gerbil-path*)))
    (when (file-exists-p tags) (visit-tags-table tags)))

  (when (package-installed-p 'smartparens)
    (sp-pair "'" nil :actions :rem)
    (sp-pair "`" nil :actions :rem))

  (defun clear-comint-buffer ()
    (interactive)
    (with-current-buffer "*scheme*"
      (let ((comint-buffer-maximum-size 0))
        (comint-truncate-buffer))))

)

(defun gerbil-setup-buffers ()
  "Change current buffer mode to gerbil-mode and start a REPL"
  (interactive)
  (gerbil-mode)
  (split-window-right)
  (shrink-window-horizontally 2)
  (let ((buf (buffer-name)))
    (other-window 1)
    (run-scheme "gxi")
    (switch-to-buffer-other-window "*scheme*" nil)
    (switch-to-buffer buf)))

;; (global-set-key (kbd "C-c C-g") 'gerbil-setup-buffers)


(use-package markdown-mode
  :mode ("README\\.md\\'" . gfm-mode))

;;(use-package org-sidebar)

(use-package magit)
(use-package simple-httpd)
(use-package slime)

(use-package haskell-mode)

(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
	  doom-themes-enable-italic t) ; if nil, italics is universally disabled
  ;(load-theme 'doom-one t)
  (load-theme 'doom-nord t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))
(use-package multi-vterm
	  :config
	  (add-hook 'vterm-mode-hook
			  (lambda ()
			  (setq-local evil-insert-state-cursor 'box)
			  (evil-insert-state)))
	  (define-key vterm-mode-map [return]                      #'vterm-send-return)

	  (setq vterm-keymap-exceptions nil)
	  (evil-define-key 'insert vterm-mode-map (kbd "C-e")      #'vterm--self-insert)
	  (evil-define-key 'insert vterm-mode-map (kbd "C-f")      #'vterm--self-insert)
	  (evil-define-key 'insert vterm-mode-map (kbd "C-a")      #'vterm--self-insert)
	  (evil-define-key 'insert vterm-mode-map (kbd "C-v")      #'vterm--self-insert)
	  (evil-define-key 'insert vterm-mode-map (kbd "C-b")      #'vterm--self-insert)
	  (evil-define-key 'insert vterm-mode-map (kbd "C-w")      #'vterm--self-insert)
	  (evil-define-key 'insert vterm-mode-map (kbd "C-u")      #'vterm--self-insert)
	  (evil-define-key 'insert vterm-mode-map (kbd "C-d")      #'vterm--self-insert)
	  (evil-define-key 'insert vterm-mode-map (kbd "C-n")      #'vterm--self-insert)
	  (evil-define-key 'insert vterm-mode-map (kbd "C-m")      #'vterm--self-insert)
	  (evil-define-key 'insert vterm-mode-map (kbd "C-p")      #'vterm--self-insert)
	  (evil-define-key 'insert vterm-mode-map (kbd "C-j")      #'vterm--self-insert)
	  (evil-define-key 'insert vterm-mode-map (kbd "C-k")      #'vterm--self-insert)
	  (evil-define-key 'insert vterm-mode-map (kbd "C-r")      #'vterm--self-insert)
	  (evil-define-key 'insert vterm-mode-map (kbd "C-t")      #'vterm--self-insert)
	  (evil-define-key 'insert vterm-mode-map (kbd "C-g")      #'vterm--self-insert)
	  (evil-define-key 'insert vterm-mode-map (kbd "C-c")      #'vterm--self-insert)
	  (evil-define-key 'insert vterm-mode-map (kbd "C-SPC")    #'vterm--self-insert)
	  (evil-define-key 'normal vterm-mode-map (kbd "C-d")      #'vterm--self-insert)
	  (evil-define-key 'normal vterm-mode-map (kbd ",c")       #'multi-vterm)
	  (evil-define-key 'normal vterm-mode-map (kbd ",n")       #'multi-vterm-next)
	  (evil-define-key 'normal vterm-mode-map (kbd ",p")       #'multi-vterm-prev)
	  (evil-define-key 'normal vterm-mode-map (kbd "i")        #'evil-insert-resume)
	  (evil-define-key 'normal vterm-mode-map (kbd "o")        #'evil-insert-resume)
	  (evil-define-key 'normal vterm-mode-map (kbd "<return>") #'evil-insert-resume))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values
   '((eval setq-local org-roam-db-location
	   (expand-file-name "org-roam.db" org-roam-directory))
     (eval setq-local org-roam-directory
	   (expand-file-name "./roam/"
			     (locate-dominating-file default-directory ".dir-locals.el")))
     (elisp-lint-indent-specs
      (describe . 1)
      (it . 1)
      (thread-first . 0)
      (cl-flet . 1)
      (cl-flet* . 1)
      (org-element-map . defun)
      (org-roam-dolist-with-progress . 2)
      (org-roam-with-temp-buffer . 1)
      (org-with-point-at . 1)
      (magit-insert-section . defun)
      (magit-section-case . 0)
      (org-roam-with-file . 2))
     (elisp-lint-ignored-validators "byte-compile" "package-lint")
     (org-src-preserve-indentation . t)))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Andale Mono" :foundry "nil" :slant normal :weight regular :height 180 :width normal)))))
