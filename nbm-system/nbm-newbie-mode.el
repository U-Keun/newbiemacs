;; This is newbie-mode.

(defun newbie-key ()
  (interactive)
  (if (buffer-file-name)
      (setq *newbie-current-file* (buffer-file-name))
    (setq *newbie-current-file* *nbm-home*))
  (if (equal major-mode 'dired-mode)
      (setq *newbie-current-file* (dired-current-directory)))
  (if (get-buffer "newbie") (kill-buffer "newbie"))
  (split-window-below)
  (other-window -1)
  (switch-to-buffer "newbie")
  (erase-buffer)
  (newbie-mode)
  (read-only-mode)
  (newbie-init))

(defun newbie ()
  (interactive)
  (if (buffer-file-name)
      (setq *newbie-current-file* (buffer-file-name))
    (setq *newbie-current-file* *nbm-home*))
  (if (equal major-mode 'dired-mode)
      (setq *newbie-current-file* (dired-current-directory)))
  (if (get-buffer "newbie") (kill-buffer "newbie"))
  (switch-to-buffer "newbie")
  (erase-buffer)
  (newbie-mode)
  (read-only-mode)
  (newbie-init)
  ;; (evil-local-set-key 'normal (kbd "a") ')
  ;; (evil-local-set-key 'normal (kbd "b") ')
  ;; (evil-local-set-key 'normal (kbd "c") ')
  ;; (evil-local-set-key 'normal (kbd "d") ')
  ;; (evil-local-set-key 'normal (kbd "e") 'nbm-find-el)
  (evil-local-set-key 'normal (kbd "f") 'newbie-latex-insert-figure)
  (evil-local-set-key 'normal (kbd "g") 'torus)
  (evil-local-set-key 'normal (kbd "h") 'newbie-latex-convert-to-hwp)
  (evil-local-set-key 'normal (kbd "i") 'newbie-org-roam-node-insert)
  ;; (evil-local-set-key 'normal (kbd "j") ')
  ;; (evil-local-set-key 'normal (kbd "k") ')
  ;; (evil-local-set-key 'normal (kbd "l") ')
  (evil-local-set-key 'normal (kbd "m") 'nbm-move-pdf-from-downloads)
  (evil-local-set-key 'normal (kbd "n") 'nbm-new-file)
  (evil-local-set-key 'normal (kbd "o") 'newbie-open-file)
  (evil-local-set-key 'normal (kbd "p") 'nbm-find-pdf)
  (evil-local-set-key 'normal (kbd "q") 'newbie-quit)
  (evil-local-set-key 'normal (kbd "r") 'org-roam-node-find)
  (evil-local-set-key 'normal (kbd "s") 'nbm-find-sage)
  (evil-local-set-key 'normal (kbd "t") 'nbm-find-tex)
  (evil-local-set-key 'normal (kbd "u") 'org-roam-ui-mode)
  (evil-local-set-key 'normal (kbd "v") 'newbie-latex-change-variable)
  ;; (evil-local-set-key 'normal (kbd "w") ')
  (evil-local-set-key 'normal (kbd "x") 'newbie-setting)
  (evil-local-set-key 'normal (kbd "y") 'newbie-yank-file-name)
  ;; (evil-local-set-key 'normal (kbd "z") ')
  ;; (evil-local-set-key 'normal (kbd "A") ')
  ;; (evil-local-set-key 'normal (kbd "B") ')
  ;; (evil-local-set-key 'normal (kbd "C") ')
  ;; (evil-local-set-key 'normal (kbd "D") ')
  ;; (evil-local-set-key 'normal (kbd "E") ')
  (evil-local-set-key 'normal (kbd "F") 'newbie-finder)
  ;; (evil-local-set-key 'normal (kbd "G") ')
  ;; (evil-local-set-key 'normal (kbd "H") ')
  ;; (evil-local-set-key 'normal (kbd "I") ')
  ;; (evil-local-set-key 'normal (kbd "J") ')
  ;; (evil-local-set-key 'normal (kbd "K") ')
  ;; (evil-local-set-key 'normal (kbd "L") ')
  ;; (evil-local-set-key 'normal (kbd "M") ')
  ;; (evil-local-set-key 'normal (kbd "N") ')
  ;; (evil-local-set-key 'normal (kbd "O") ')
  ;; (evil-local-set-key 'normal (kbd "P") ')
  ;; (evil-local-set-key 'normal (kbd "Q") ')
  ;; (evil-local-set-key 'normal (kbd "R") ')
  (evil-local-set-key 'normal (kbd "S") 'newbie-latex-add-to-symlinks)
  (evil-local-set-key 'normal (kbd "T") 'newbie-toggle-dotemacs)
  ;; (evil-local-set-key 'normal (kbd "U") ')
  ;; (evil-local-set-key 'normal (kbd "V") ')
  ;; (evil-local-set-key 'normal (kbd "W") ')
  ;; (evil-local-set-key 'normal (kbd "X") ')
  (evil-local-set-key 'normal (kbd "Y") 'newbie-yas-new-snippet)
  ;; (evil-local-set-key 'normal (kbd "Z") ')
  (evil-force-normal-state)
  )

(defun newbie-mode ()
  (setq major-mode 'newbie-mode)
  (font-lock-mode)
  (setq mode-name "Newbie")
  (use-local-map newbie-mode-map))

(defun newbie-init ()
  "Start newbie."
  (newbie-print-all))

(defun nbm-insert (color string)
  "Insert STRING with foreground color COLOR."
  (cond ((equal color 1) (insert (propertize string 'font-lock-face '(:foreground "Systemgraycolor"))))
        ((equal color 2) (insert (propertize string 'font-lock-face '(:foreground "Systemorangecolor"))))
        ((equal color 3) (insert (propertize string 'font-lock-face '(:foreground "Systemyellowcolor"))))
        ((equal color 4) (insert (propertize string 'font-lock-face '(:foreground "Systempurplecolor"))))
        ((equal color 6) (insert (propertize string 'font-lock-face '(:foreground "Systemgreencolor"))))
        ((equal color 7) (insert (propertize string 'font-lock-face '(:foreground "Systemredcolor"))))
        ((equal color 8) (insert (propertize string 'font-lock-face '(:foreground "Systembluecolor"))))
        ((equal color 9) (insert (propertize string 'font-lock-face '(:foreground "Systembrowncolor"))))
        ((equal color 5) (insert (propertize string 'font-lock-face '(:foreground "Systempinkcolor"))))
        ))

(defun newbie-print-version ()
  "Start newbie."
    (nbm-insert 1 (format "%83s" "Newbiemacs 0.6")))

(defun newbie-print-logo ()
  "Start newbie."
    (nbm-insert 6 "
  +-+    +-+ +----; +-+    +-+ +----,  +-+ +----; +-+    +-+   ,--,   +----; +----;
  |  \\   | | | +--' | |    | | | ,_, \\ | | | +--' |  \\  /  |  / __ \\  | +--' | +--'
  | . \\  | | | |    | |    | | | | | | | | | |    | . \\/ . | / /  \\ \\ | |    | |
  | |\\ \\ | | | +--; | | /\\ | | | '-' / | | | +--; | |\\  /| | | |__| | | |    | +--+
  | | \\ \\| | | +--' | |/  \\| | | ,-, \\ | | | +--' | | \\/ | | | ,__, | | |    +--+ |
  | |  \\ ' | | |    | ' /\\ ' | | | | | | | | |    | |    | | | |  | | | |       | |
  | |   \\  | | +--; |  /  \\  | | '-' / | | | +--; | |    | | | |  | | | +--; ;--+ |
  +-+    +-+ +----' +-+    +-+ +----'  +-+ +----' +-+    +-+ +-+  +-+ +----' '----+
")
    (nbm-insert 1 "          Newbiemacs is designed for mathematicians who are new to Emacs.          \n\n"))

(defun newbie-print-menu ()
  "Start newbie."
  (nbm-insert 9 "                           <BACKSPACE>: Newbiemacs screen                         \n\n")
  (nbm-insert 3 (format "%2s%-15s->  " "" "Find files"))
  (nbm-insert 3 (format "%2s%-19s" "" "t: tex find"))
  (nbm-insert 3 (format "%2s%-19s" "" "p: pdf find"))
  (nbm-insert 3 (format "%2s%-19s\n" "" "s: sage find"))
  (nbm-insert 6 (format "%2s%-15s->  " "" "Manage files"))
  (nbm-insert 6 (format "%2s%-19s" "" "m: move pdf"))
  (nbm-insert 6 (format "%2s%-19s" "" "n: new file"))
  (nbm-insert 6 (format "%2s%-19s\n" "" "S: symlink create"))
  (nbm-insert 8 (format "%2s%-15s->  " "" "External"))
  (nbm-insert 8 (format "%2s%-19s" "" "F: Finder"))
  (nbm-insert 8 (format "%2s%-19s" "" "o: open file"))
  (nbm-insert 8 (format "%2s%-19s\n" "" "y: yank filename"))
  (nbm-insert 5 (format "%2s%-15s->  " "" "Latex mode"))
  (nbm-insert 5 (format "%2s%-19s" "" "f: figure add"))
  (nbm-insert 5 (format "%2s%-19s" "" "v: variable change"))
  (nbm-insert 5 (format "%2s%-19s\n" "" "h: hwp convert"))
  (nbm-insert 2 (format "%2s%-15s->  " "" "Org mode"))
  (nbm-insert 2 (format "%2s%-19s" "" "r: org-roam"))
  (nbm-insert 2 (format "%2s%-19s" "" "u: org-roam-ui"))
  (nbm-insert 2 (format "%2s%-19s\n" "" "i: insert node"))
  (nbm-insert 4 (format "%2s%-15s->  " "" "Extra"))
  (nbm-insert 4 (format "%2s%-19s" "" "g: game"))
  (nbm-insert 4 (format "%2s%-19s" "" "x: setting"))
  (nbm-insert 4 (format "%2s%-19s\n" "" "q: quit"))

  ;; (insert "\n")
  ;; (nbm-insert 1 "color 1  ")
  ;; (nbm-insert 2 "color 2  ")
  ;; (nbm-insert 3 "color 3  ")
  ;; (nbm-insert 4 "color 4  ")
  ;; (nbm-insert 5 "color 5  ")
  ;; (nbm-insert 6 "color 6  ")
  ;; (nbm-insert 7 "color 7  ")
  ;; (nbm-insert 8 "color 8  ")
  ;; (nbm-insert 9 "color 9\n")
  )

(defun newbie-print-all ()
  "Start newbie."
  (let ((inhibit-read-only t))
    (newbie-print-version)
    (newbie-print-logo)
    (newbie-print-menu)
    ;; (newbie-print-variables)
    (newbie-print-current-file)
    (beginning-of-buffer)
    ))

(defun newbie-quit ()
  (interactive)
  (kill-buffer)
  (delete-window))

(defun newbie-print-variables ()
  (nbm-insert 9 (format "  %-17s: %s\n" "*nbm-home*" *nbm-home*))
  (nbm-insert 9 (format "  %-17s: %s\n" "*nbm-pdf*" *nbm-pdf*))
  (nbm-insert 9 (format "  %-17s: %s\n" "*nbm-downloads*" *nbm-downloads*))
  (nbm-insert 9 (format "  %-17s: %s\n" "*nbm-desktop*" *nbm-desktop*))
  (nbm-insert 9 (format "  %-17s: %s\n" "*nbm-screenshots*" *nbm-screenshots*))
  )

(defun newbie-print-current-file ()
  (nbm-insert 1 (format "\n  The current file is:\n  %s" *newbie-current-file*)))

;; key bindings
(defvar newbie-mode-map (make-sparse-keymap))
(evil-global-set-key 'normal (kbd "<backspace>") 'newbie)
(when (commandp 'spacemacs/get-last-version)
  (evil-global-set-key 'motion (kbd "<backspace>") 'newbie)
  (evil-global-set-key 'evilified (kbd "<backspace>") 'newbie))

(defun newbie-finder ()
  "Open the current file in Finder."
  (interactive)
  (shell-command (format "open -R \"%s\"" *newbie-current-file*)))

(defun newbie-latex-add-to-symlinks ()
  (interactive) (kill-buffer)
  (nbm-latex-add-to-symlinks))

(defun newbie-latex-convert-to-hwp ()
  (interactive) (kill-buffer)
  (nbm-latex-convert-to-hwp))

(defun newbie-latex-insert-figure ()
  (interactive) (kill-buffer)
  (nbm-latex-insert-figure))

(defun newbie-latex-change-variable ()
  (interactive) (kill-buffer)
  (nbm-latex-change-variable))

(defun newbie-open-file ()
  (interactive) (kill-buffer)
  (shell-command (format "open \"%s\"" (buffer-file-name))))

(defun newbie-yank-file-name ()
  (interactive)
  (kill-new *newbie-current-file*)
  (message (concat "The following string is copied to the clipboard.\n"
                   *newbie-current-file*)))

(defun newbie-org-roam-node-insert ()
  (interactive) (kill-buffer)
  (org-roam-node-insert))

(defun newbie-setting ()
  (interactive)
  (let ((inhibit-read-only t) choice)
    (erase-buffer)
    (insert "\n  Current variables are shown below.\n\n")
    (newbie-print-variables)
    (insert "\n  To change a variable ")
    (nbm-insert 9 "*VAR*")
    (insert ", edit the content of the file \"VAR.txt\".")
    (insert "\n\n  ")
    (nbm-insert 9 "*nbm-home*")
    (insert " and ")
    (nbm-insert 9 "*nbm-pdf*")
    (nbm-insert 5 " cannot be changed.")
    (insert "\n  Each of ")
    (nbm-insert 9 "*nbm-downloads*")
    (insert " and ")
    (nbm-insert 9 "*nbm-desktop*")
    (insert " must have only one folder path.")
    (nbm-insert 9 "\n\n  *nbm-screenshots*")
    (insert " may have several folder paths, ")
    (nbm-insert 8 "one folder path in one line.")
    (nbm-insert 5 "\n\n  Warning:")
    (insert " Make sure that the last string of a folder path is \"/\".")
    (insert "\n  For example, it should be something like \"~/Desktop/\" rather than \"~/Desktop\".")
    (insert "\n  There must be ")
    (nbm-insert 5 "no space")
    (insert " before or after each folder path.")
    (nbm-insert 2 "\n\n  See the minibuffer at the bottom of this screen.
  You need to reload Newbiemacs after you change a variable.
  (Newbiemacs reload short-cut: SPC N r)")
    (setq choice (read-char "What do you want to do?
1) Change *nbm-desktop*
2) Change *nbm-downloads*
3) Change *nbm-screenshots*
4) Change the tex template file \"template.tex\"
5) Change the bib file \"ref.bib\"
"))
    (cond
     ((equal choice ?1)
      (shell-command (format "open \"%s%s\"" *nbm-home*
                             "nbm-user-settings/nbm-variables/nbm-desktop.txt")))
     ((equal choice ?2)
      (shell-command (format "open \"%s%s\"" *nbm-home*
                             "nbm-user-settings/nbm-variables/nbm-downloads.txt")))
     ((equal choice ?3)
      (shell-command (format "open \"%s%s\"" *nbm-home*
                             "nbm-user-settings/nbm-variables/nbm-screenshots.txt")))
     ((equal choice ?4)
      (shell-command (format "open \"%s%s\"" *nbm-home*
                             "nbm-user-settings/templates/")))
     ((equal choice ?5)
      (shell-command (format "open \"%s%s\"" *nbm-home*
                             "nbm-user-settings/references"))))
    (newbie)))

