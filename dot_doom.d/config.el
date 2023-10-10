;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Wyatt Hauben"
      user-mail-address "whauben11@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-molokai)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.






;;====================================================
;;===================|Personal Config|================
;;====================================================

;; allow clipboard stuff
(setq select-enable-clipboard t)

;;Turns on Word Counts for the modes listed in doom-modeline-continuous-word-count-modes
(setq doom-modeline-enable-word-count t)

;; Work in progress to add the fundamental mode to word count list
;;(push doom-modeline-continuous-word-count-modes fundamental-mode)

;;When navigating symlinks, will use parent directy from which user entered
(setq find-file-visit-truename nil)

;; Dimitri's latex classes
(with-eval-after-load 'ox-latex
        (add-to-list 'org-latex-classes
                '("plain-letter"
                "\\documentclass{article}\n[NODEFAULT-PACKAGES]\n[PACKAGES]\n[EXTRA]"
                ("\\section{%s}"       . "\\section*{%s}")
                ("\\subsection{%s}"    . "\\subsection*{%s}")
                ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                ("\\paragraph{%s}"     . "\\paragraph*{%s}")
                ("\\subparagraph{%s}"  . "\\subparagraph*{%s}"))))

(with-eval-after-load 'ox-latex
        (add-to-list 'org-latex-classes
                '("two_col_article" "\\documentclass[10pt,twocolumn]{article}"
                        ("\\section{%s}" . "\\section*{%s}")
                        ("\\subsection{%s}" . "\\subsection*{%s}")
                        ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                        ("\\paragraph{%s}" . "\\paragraph*{%s}")
                        ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))
;; redefines lsp leader away from s-l as this is captured by i3
;;(define-key lsp-mode-map (kbd "C-c C-l") lsp-command-map)

(map! :map lsp-mode-map
      :leader
      :g "c p" 'project-compile)

(map! :map vterm-mode-map
      :m "C-v" 'term-paste)

(map! :map org-agenda-mode-map
      :leader
      :m "o m" #'org-agenda-month-view
      :desc "Org month agenda")


;; Compilation buffer
(defun close-all-compilation-buffers ()
  "Close all buffers running in Compilation mode and show a message in the status bar."
  (interactive)
  (let ((closed-buffers 0))
    (dolist (buffer (buffer-list))
      (with-current-buffer buffer
        (when (derived-mode-p 'compilation-mode)
          (kill-buffer buffer)
          (setq closed-buffers (1+ closed-buffers)))))
    (if (zerop closed-buffers)
      (message "No Compilation mode buffers to close.")
      (message "Closed %d Compilation mode buffers." closed-buffers))))

(map! :leader
      :n "c q" 'close-all-compilation-buffers
      :desc "Closes all open test/compilation buffers")

;;(add-hook 'org-mode-hook 'turn-on-auto-fill)

(setq doom-font (font-spec :family "monospace" :size 18))

;;#+begin_src emacs-lisp :tangle yes
(use-package! matlab
        :defer t
        :ensure t
        :mode ("\\.m$" . matlab-mode)
        :custom
        (matlab-indent-function t)
        (matlab-shell-command "/usr/local/MATLAB/R2022a/bin/matlab"))

(setq org-babel-default-header-args:matlab '((:session . "*MATLAB*")))
(setq org-hide-emphasis-markers t)


;; (load! "ob-octave-fix")
;;(after! 'ob-octave-fix.el nil t)
;;#+end_src

;;Increases the size of latex fragments in org mode.
(after! org
  (progn
    (setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))
    (setq org-export-babel-evaluate nil)))

(after! ox-latex
  (setq org-latex-listings t))

;; Makes emphasis markdown characters visible in org mode.
(setq org-hide-emphasis-markers nil)

;; Org-Roam config
(after! org (setq org-roam-directory "~/Documents/org/roam/") (setq org-roam-index-file "~/Documents/org/roam/index.org"))

;;Enables saving buffers on exit
;; (desktop-save-mode t) ;;breaks things with "unprintable entites and vterm toggle"

;; Utility Function for getting the title of an org file. Used in latex header snippet.
;; https://emacs.stackexchange.com/questions/27620/orgmode-capturing-original-document-title
(defun get-title-org (file)
  (interactive)
  (let (title)
    (when file
      (with-current-buffer
          (get-file-buffer file)
        (pcase (org-collect-keywords '("TITLE"))
          (`(("TITLE" . ,val))
           (setq title (car val)))))
      title)))

;; Arduino mode setup
(setq auto-mode-alist (cons '("\\.\\(pde\\|ino\\)$" . arduino-mode) auto-mode-alist))
(autoload 'arduino-mode "arduino-mode" "Arduino editing mode." t)

;; Smooth Scrolling
(use-package! good-scroll)
(after! good-scroll
  (map!
   :desc "Toggle smooth scrolling."
   :leader
   :prefix "t"
   "s" #'good-scroll-mode
   )
)
(setq undo-limit 80000000                         ; Raise undo-limit to 80Mb
      evil-want-fine-undo t                       ; By default while in insert all changes are one big blob. Be more granular
      auto-save-default t)
(global-subword-mode 1)                           ; Iterate through CamelCase words

(setq org-directory "~/Documents/org")
(setq org-default-notes-file (concat org-directory "/todo.org"))

;; Macros
(fset 'sqlmover
      ;; Copies selection from code block to a console window to the right and runs its.
      (kmacro-lambda-form [?\{ ?V ?\} ?k ?y ?j ?  ?w ?l ?p ?i return escape ?  ?w ?h] 0 "%d"))
