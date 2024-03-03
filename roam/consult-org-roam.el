(use-package consult-org-roam
 :straight t
 :after org-roam
 :init
 (require 'consult-org-roam)
 ;; Activate the minor mode
 (consult-org-roam-mode 1)
  :custom
 ;; ;; Use `ripgrep' for searching with `consult-org-roam-search'
 (consult-org-roam-grep-func #'consult-ripgrep)
 ;; ;; Configure a custom narrow key for `consult-buffer'
 ;; (consult-org-roam-buffer-narrow-key ?r)
 ;; ;; Display org-roam buffers right after non-org-roam buffers
 ;; ;; in consult-buffer (and not down at the bottom)
  (consult-org-roam-buffer-after-buffers t)
 ;; :config
 ;; ;; Eventually suppress previewing for certain functions
 ;; (consult-customize
 ;;  consult-org-roam-forward-links
 ;;  :preview-key "M-.")
 :bind
 ;; Define some convenient keybindings as an addition
 ("C-c n e" . consult-org-roam-file-find)
 ("C-c n b" . consult-org-roam-backlinks)
 ("C-c n B" . consult-org-roam-backlinks-recursive)
 ("C-c n l" . consult-org-roam-forward-links)
 ("C-c n r" . consult-org-roam-search))
