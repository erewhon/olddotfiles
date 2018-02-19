;;; package --- Summary
;;
;; .emacs - starting to put one back together again after years and years...
;;    Lots of helpful info from various sources.  EmacsWiki, ErgoEmacs, etc.
;;
;;    1989 or so (gulp!) to present
;;
;;    I've moved to the Emacs package manager for most things these days.
;;
;;    I do most development under Windows + Cygwin & Mac.  I try to
;;    adapt to the peculiarities of such an environment.  Mostly I don't
;;    have to.
;;
;;    I have toyed around with an Org-mode / Babel-driven config.  (I used
;;    it, then I stopped, then I started using it again.)
;;
;;    It's still better than the olden days when my .emacs file loaded a byte
;;    compiled init file.  (At least until it got so unwieldy that I ended up dumping
;;    my own copy of Emacs.  Hey, this was back in the early 90s...)
;;
;; Requirements:
;;   Emacs 25.x
;;   use-package needs to be installed already
;;
;; Resources:
;;   emacs wiki
;;   https://github.com/purcell/emacs.d/blob/master/init.el
;;
;;; Commentary:
;;
;; To do:
;;   fix use-package needing to be installed
;;   include ~/.dotfiles-local/dotfiles/.emacs

;; Verify that we're running a recent enough version

;; If we don't keep this line here, package.el will put it back.  ARGH!
;; (package-initialize)

;;; Code:

(when (< emacs-major-version 25)
  (message "Your emacs is way too old!"))

;; https://emacs.stackexchange.com/questions/32150/how-to-add-a-timestamp-to-each-entry-in-emacs-messages-buffer
(defun sh/current-time-microseconds ()
  "Create a microsecond timestamp."
  (let* ((nowtime (current-time))
         (now-ms (nth 2 nowtime)))
    (concat (format-time-string "[%Y-%m-%dT%T" nowtime) (format ".%d] " now-ms))))

(defadvice message (before sh/advice-timestamp-messages activate compile)
  "Instrument 'message' to timestamp."
  (if (not (string-equal (ad-get-arg 0) "%s%s"))
      (let ((deactivate-mark nil))
        (with-current-buffer "*Messages*"
          (read-only-mode 0)
          (goto-char (point-max))
          (if (not (bolp))
              (newline))
          (insert (sh/current-time-microseconds))))))

(message "Starting .emacs")

;; Now, do package management related bootstrap.  Set up proxy, then
;; make sure packages and melpa are configured.  We do it here so
;; we can make sure we have a more modern version of orgmode.

;; (setq url-proxy-services
;;        '(("no_proxy" . "^\\(localhost\\|10.*\\)")
;;          ("http" . "proxy.com:8080")
;;          ("https" . "proxy.com:8080")))

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

(message "About to package-initialize")

(package-initialize)

;;(require 'org-install)
;; (require 'ob-tangle)

(setq custom-file "~/.emacs.custom")

(org-babel-load-file "~/.emacs.d/elisp.org")

;;; .emacs ends here
