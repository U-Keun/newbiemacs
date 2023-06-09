(defun nbm-org-toggle-strike-through ()
  "Toggle strike though the current item."
  (interactive)
  (let (end)
    (end-of-line) (setq end (point))
    (beginning-of-line) (re-search-forward "[*]+ \\|[-+] \\|[0-9]+[.)] " end t)
    (when (string= (char-to-string (char-after)) "[")
	(forward-sexp) (forward-char))
    (if (equal (char-after) ?+)
	(progn
	  (delete-char 1) (end-of-line) (delete-char -1))
      (progn
	(insert "+") (end-of-line) (insert "+")))))

(defun nbm-org-toggle-checkbox ()
  "Toggle checkbox in the current item. If there is no checkbox, create one."
  (interactive)
  (save-excursion
    (let (end)
      (end-of-line) (setq end (point))
      (beginning-of-line) (re-search-forward "\\(^[*]+ \\|^ *[-+] \\|^ *[0-9]+[.)] \\)" end t)
      (when (match-string 1)
	(if (equal (substring (match-string 1) 0 1) "*")
	    (progn
	      (when (and (<= (+ (point) 4) (point-max))
			 (equal (buffer-substring (point) (+ (point) 4)) "TODO"))
		(forward-char 5))
	      (if (and (<= (+ (point) 1) (point-max))
		       (equal (buffer-substring (point) (+ (point) 1)) "["))
		  (org-update-checkbox-count)
		(insert "[/] ")))
	  (if (and (char-after) (string= (char-to-string (char-after)) "["))
	      (org-toggle-checkbox)
	    (insert "[ ] ")))))))

(defun nbm-org-consecutive-dates ()
  "Insert consecutive dates."
  (interactive)
  (let (type)
    (setq type (read-char "Which type of consecutive dates?\ns) schedule\na) active time stamp\ni) inactive time stamp"))
    (cond ((equal type ?s)
	   (call-interactively 'org-schedule)
	   (save-excursion
	     (org-backward-heading-same-level 0)
	     (search-forward "SCHEDULED:")
	     (end-of-line)
	     (insert "--")
	     (call-interactively 'org-time-stamp)))
	  ((equal type ?a)
	   (call-interactively 'org-time-stamp)
	   (insert "--")
	   (call-interactively 'org-time-stamp))
	  ((equal type ?i)
	   (call-interactively 'org-time-stamp-inactive)
	   (insert "--")
	   (call-interactively 'org-time-stamp-inactive)))))

(defun nbm-org-jump-to-heading ()
  "Jump to a heading in the current org file."
  (interactive)
  (let (heading-list heading beg end)
    (save-excursion
      (beginning-of-buffer)
      (setq heading-list '())
      (while (re-search-forward "^[*]+ .+$" nil t)
	(beginning-of-line) (setq beg (point))
	(end-of-line) (setq end (point))
	(setq heading (buffer-substring beg end))
	(setq heading-list (nbm-append heading heading-list))))
    (setq heading (completing-read "Choose a heading to jump: "
				   heading-list))
    (beginning-of-buffer)
    (re-search-forward (format "^%s[ \t]*$" (regexp-quote heading)))))

(defun nbm-org-jump-to-tex ()
  "Jump to the tex file for the current org file."
  (interactive)
  (find-file (concat (file-name-sans-extension (buffer-file-name)) ".tex")))

(defun nbm-org-jump-to-archive ()
  "Jump to the archive file of the current org file."
  (interactive)
  (find-file (concat (buffer-file-name) "_archive")))

(defun nbm-org-jump-to-file ()
  "Jump to a file in the current org file."
  (interactive)
  (let (file-list file)
    (setq file-list (org-element-map (org-element-parse-buffer) 'link
		      (lambda (link)
			(when (string= (org-element-property :type link) "file")
			  (org-element-property :path link)))))
    (setq file (completing-read "Choose a file to open: " file-list nil t ""))
    (find-file file)))

(defun nbm-org-jump-to-dir-at-point ()
  "Jump to the directory of the current file link.
This does not recognize a link if it has an underscore."
  (interactive)
  (let (file dir)
    (when (string= (org-element-property :type (org-element-context)) "file")
      (setq file (org-element-property :path (org-element-context)))
      (setq dir (file-name-directory file))
      (find-file dir) (revert-buffer) (goto-char (point-min)) 
      (search-forward (file-name-nondirectory file)))))

(defun nbm-org-jump-to-url ()
  "Jump to a url in the current org file."
  (interactive)
  (let (url url-list)
    (setq url-list (org-element-map (org-element-parse-buffer) 'link
		      (lambda (link)
			(when (string-match-p "http" (org-element-property :type link))
			  (concat (org-element-property :type link) ":"
				  (org-element-property :path link))))))
    (setq url (completing-read "Choose a url to open: " url-list nil t ""))
    (org-link-open-from-string url)))

(defun nbm-org-html-export ()
  "Export to html and open it."
  (interactive)
  (org-html-export-to-html)
  (org-open-file (format "%s.html" (file-name-sans-extension (buffer-file-name)))))

(defun nbm-org-html-theme ()
  "Insert org-html-theme in the header."
  (interactive)
  (let (themes choice str)
    (unless (file-exists-p (nbm-f "nbm-user-settings/org-themes"))
      (find-file (nbm-f "nbm-user-settings"))
      (shell-command "git clone https://gitlab.com/OlMon/org-themes.git")
      (kill-buffer))
    (setq themes '("bigblow_inline"
		   "comfy_inline"
		   ;; "darksun"
		   "gray"
		   "imagine_light"
		   "latexcss"
		   "plain"
		   "readtheorg_inline"
		   "rethink_inline"
		   "retro_dark"
		   "simple_gray"
		   "simple_inline"
		   "simple_white"
		   "simple_whiteblue"
		   "solarized_dark"
		   "solarized_light"
		   "stylish_white"
		   "white_clean"))
    (setq choice (completing-read "Select the theme: " themes nil nil nil nil "readtheorg_inline"))
    (setq str (format "#+SETUPFILE: %snbm-user-settings/org-themes/src/%s/%s.theme"
		      *nbm-home* choice choice))
    (save-excursion
      (beginning-of-buffer)
      (while (re-search-forward "^#[+]SETUPFILE:\\|^#[+]REVEAL_" nil t)
	  (beginning-of-line) (kill-line) (kill-line))
      (beginning-of-buffer)
      (re-search-forward "^#[+]title:.*$")
      (re-search-forward "^#[+]author:.*$" nil t)
      (re-search-forward "^#[+]date:.*$" nil t)
      (insert (format "\n%s" str)))
    (message (format "Inserted %s" str))))

(defun nbm-org-reveal-theme ()
  "Insert org-reveal-theme in the header."
  (interactive)
  (let (theme-list trans-list theme trans)
    (setq theme-list '("league" "black" "white" "beige" "night" "serif" "simple" "solarized" "moon" "dracula" "sky" "blood"))
    (setq trans-list '("default" "cube" "page" "concave" "zoom" "linear" "fade" "none"))
    (setq theme (completing-read "Select the theme: " theme-list nil nil nil nil "league"))
    (setq trans (completing-read "Select the transition method: " trans-list nil nil nil nil "default"))
    (save-excursion
      (beginning-of-buffer)
      (while (re-search-forward "^#[+]SETUPFILE:\\|^#[+]REVEAL_" nil t)
	  (beginning-of-line) (kill-line) (kill-line))
      (beginning-of-buffer)
      (re-search-forward "^#[+]title:.*$")
      (unless (re-search-forward "^#[+]author:.*$" nil t)
	(insert (format "\n#+author: %s" (user-full-name))))
      (unless (re-search-forward "^#[+]date:.*$" nil t)
	(insert (format "\n#+date: %s" (format-time-string "%B%e, %Y"))))
      (insert (format "\n#+REVEAL_ROOT: https://cdn.jsdelivr.net/npm/reveal.js
#+REVEAL_THEME: %s
#+REVEAL_INIT_OPTIONS: transition: '%s'" theme trans)))
    (message (format "Inserted a presentation theme: %s" theme))))

(defun nbm-org-reveal-frag ()
  "Insert an option for org-reveal fragment."
  (interactive)
  (let (frag-list frag)
    (setq frag-list '("appear" "grow" "shrink" "roll-in" "fade-out" "highlight-red" "highlight-green" "highlight-blue" "none"))
    (setq frag (completing-read "Select the fragment option: " frag-list nil nil nil nil "appear"))
    (insert (format "#+ATTR_REVEAL: :frag (%s)" frag))))

(defun nbm-org-export-options ()
  "Add org export options."
  (interactive)
  (beginning-of-buffer)
  (re-search-forward "^#[+]title:") (next-line) (beginning-of-line)
  (insert "#+OPTIONS: title:t author:t date:t toc:t num:t timestamp:nil creator:nil\n")
  (message "Inserted options.
To modify options, change \"t\" to \"nil\" or vice versa.

\"t\" means the option is turned on.
\"nil\" means the option is turned off.

For example, \"toc:t\" will show the table of contents
and \"num:nil\" will hide the section numbers."))

(defun nbm-org-sage-tangle ()
  "Tangle the python blocks to a sage file.
If there is a sage shell, then load the sage file in the sage shell.
Otherwise, copy a string in the clipboard to load it."
  (interactive)
  (let (python sage str buf)
    (setq python (concat (file-name-sans-extension (buffer-file-name)) ".python"))
    (setq sage (concat (file-name-sans-extension (buffer-file-name)) ".sage"))
    (org-babel-tangle)
    (rename-file python sage t)
    (setq str (format "load(\"%s\")" sage))
    (if (gnus-buffer-exists-p "*Sage*")
	(save-excursion
	  (setq buf (current-buffer))
	  (switch-to-buffer "*Sage*")
	  (insert str) (sage-shell:send-input)
	  (switch-to-buffer buf)
	  (other-window 1)
	  (end-of-buffer))
      (progn
	(kill-new str)
	(message (format "Copied to clipboard: %s" str))))))

(defun nbm-org-move-to-archived ()
  "Move the current file to the archived directory: newbiemacs/archived/org/
and store the org link."
  (interactive)
  (let (archive html new-file)
    (unless (file-exists-p (nbm-f "archived"))
      (make-directory (nbm-f "archived"))
      (make-directory (nbm-f "archived/org")))
    (setq new-file (nbm-f (concat "archived/org/"
			   (file-name-nondirectory (buffer-file-name)))))
    (setq html (concat (file-name-sans-extension (buffer-file-name)) ".html"))
    (setq archive (concat (buffer-file-name) "_archive"))
    (if (file-exists-p html)
	(rename-file html (concat (file-name-sans-extension new-file) ".html")))
    (if (file-exists-p archive)
	(rename-file archive (concat new-file "_archive")))
    (rename-file (buffer-file-name) new-file)
    (kill-buffer) (find-file new-file)
    (push (list (concat "file:" new-file)
		(file-name-nondirectory (file-name-sans-extension new-file)))
	  org-stored-links)
    (message (concat "Moved and org link stored: " new-file))))

(defun nbm-org-yank-code ()
  "Yank the current code line."
  (interactive)
  (save-excursion
    (let (end)
      (end-of-line) (setq end (point))
      (beginning-of-line)
      (when (search-forward ": " end t)
	(kill-new (buffer-substring (point) end))
	(message (concat "Copied to clipboard: " (current-kill 0)))))))

(defun nbm-org-download-method (link)
  "Download a file to the folder with the buffer-file-name for org-download-method."
  (let ((filename
	 (file-name-nondirectory
	  (car (url-path-and-query
		(url-generic-parse-url link)))))
	(dirname (concat (file-name-sans-extension (buffer-name)) "-files")))
    (unless (file-exists-p dirname)
      (make-directory dirname))
    (expand-file-name filename dirname)))

(defun nbm-org-insert-file ()
  "Insert the most recent file from *nbm-screenshots* into the directory (buffer-file-name)-files. A file link is also inserted.
If the filename has [...], change it to (...)."
  (interactive)
  (let (files file choice dir newest)
    (setq files '())
    (dolist (dir *nbm-screenshots*)
      (if (file-exists-p dir)
	  (setq files (append files (directory-files dir t "^[^.].*[^~]$")))))
    (setq newest (nbm-newest-file files))
    (setq choice (read-char (concat "Move this file?: (Type y for yes.)\n" newest)))
    (when (equal choice ?y)
      (setq dir (concat (file-name-sans-extension (buffer-file-name)) "-files"))
      (unless (file-directory-p dir) (make-directory dir))
      (setq file (read-string "Enter the new file name (space will be change to dash): "
			      (file-name-nondirectory newest)))
      (setq file (string-replace " " "-" file))
      (setq file (string-replace "[" "(" file))
      (setq file (string-replace "]" ")" file))
      (copy-file newest (concat dir "/" file) t)
      (setq choice (read-char (concat "Delete this file?: (Type y for yes.)\n" newest)))
      (when (eq choice ?y) (delete-file newest))
      (insert (format "[[file:%s/%s]]" (file-name-nondirectory dir) file)))))

(defun nbm-org-quick-insert-image ()
  "Insert the most recent file from *nbm-screenshots* into the directory (buffer-file-name)-files."
  (interactive)
  (let (files file choice dir newest)
    (setq files '())
    (dolist (dir *nbm-screenshots*)
      (if (file-exists-p dir)
	  (setq files (append files (directory-files dir t "[.]jpeg\\|[.]png\\|[.]jpg")))))
    (setq newest (nbm-newest-file files))
    (setq ext (file-name-extension newest))
    (setq dir (concat (file-name-sans-extension (buffer-file-name)) "-files"))
    (unless (file-directory-p dir) (make-directory dir))
    (setq file (nbm-make-unique-filename dir "image" ext))
    (copy-file newest file t)
    (delete-file newest)
    (insert (format "[[file:%s/%s]]" (file-name-nondirectory dir) (file-name-nondirectory file)))))

(defun nbm-org-latex-preview-on ()
  "Turn on latex preview in the current file."
  (interactive)
  (org-latex-preview '(16)))

(defun nbm-org-latex-preview-off ()
  "Turn off latex preview in the current file."
  (interactive)
  (org-latex-preview '(64)))

(defun nbm-org-toggle-latex-mode ()
  "Toggle major mode between org and latex."
  (interactive)
  (let ((state evil-state))
    (cond ((equal major-mode 'latex-mode)
	   (when (texmathp) (nbm-latex-exit-math-mode))
	   (org-mode))
	  ((equal major-mode 'org-mode)
	   (LaTeX-mode)))
    (evil-change-state state)))
