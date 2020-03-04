;;; useful-single-key.el --- customized multi key strokes into one

;; copyleft (C) 2015 gniuk

;; Author: gniuk <isgniuk@gmail.com>
;; Keywords: useful key strokes
;; URL:
;; Version: DEV

;; This file is not part of GNU Emacs.

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this file.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Usage:
;; add this to init file.
;; (push "~/.emacs.d/mylisp" load-path)
;; (require 'useful-single-key)

;;; Code:

(defun gniuk/insert-line-below ()
  "Insert line below current line and goto it."
  (interactive)
  (move-end-of-line 1)
  (newline-and-indent))

; like Vim o command, fast open a new line and goto it no matter where you are
; in current line.
(global-set-key (kbd "C-o") 'gniuk/insert-line-below)

;; clear eshell buffer, by type clear and execute
(defun eshell/clear ()
  "Clear the eshell buffer."
  (let ((inhibit-read-only t))
    (erase-buffer)
    (eshell-send-input)))


(defun gniuk/dd ()
  "Like vim dd, but no prefix blank chars or tailing newline char.
No more indentation adjustment after paste to the destination point."
  (interactive)
  (back-to-indentation)
  (kill-line)
  (delete-blank-lines))
;(global-set-key (kbd "C-c C-d") 'gniuk/dd)

(defvar p1 nil)                         ; assignment to free variable warning
(defvar p2 nil)
(defun gniuk/cpAboveLine ()
  "Copy above line at cursor position."
  (interactive)
  (forward-line -1)
  ;(back-to-indentation)
  (move-beginning-of-line 1)
  (setq p1 (point))
  (move-end-of-line 1)
  (setq p2 (point))
  (kill-ring-save p1 p2)
  (forward-line)
  (yank))
(defun gniuk/cpAndCommentOutAboveLine ()
  "Copy above line at cursor position and comment out the previous one."
  (interactive)
  (forward-line -1)
  (move-beginning-of-line 1)
  (setq p1 (point))
  (move-end-of-line 1)
  (setq p2 (point))
  (kill-ring-save p1 p2)
  (comment-line 1)
  (beginning-of-line 1)
  (yank))
(global-set-key (kbd "C-x x c") 'gniuk/cpAboveLine)
(global-set-key (kbd "C-x x x") 'gniuk/cpAndCommentOutAboveLine)

(defun gniuk/copyLine (arg)
  "Copy lines (as many as prefix ARG) in the kill ring."
  (interactive "p")
  (kill-ring-save (line-beginning-position)
                  (line-beginning-position (+ 1 arg)))
  (message "%d line%s copied" arg (if (= 1 arg) "" "s")))
(global-set-key (kbd "C-c C-k") 'gniuk/copyLine)

;; overload highlight-symbol M-n and M-p, to quickly navigate pairs
; pairs: (),[],{},<>
(defun gniuk/goto-pair-forward ()
  "Goto pair forward."
  (interactive)
  (if (looking-at "(\\|\\[\\|{\\|<\\|\"")
      (forward-sexp)
    ;(highlight-symbol-next)))
    (symbol-overlay-jump-next)))
(global-set-key (kbd "M-n") 'gniuk/goto-pair-forward)

(defun gniuk/goto-pair-backward ()
  "Goto pair backward."
  (interactive)
  (backward-char)
  (if (looking-at ")\\|\\]\\|}\\|>\\|\"")
      (progn (forward-char)
             (backward-sexp))
    (progn (forward-char)
           ;(highlight-symbol-prev))))
           (symbol-overlay-jump-prev))))
(global-set-key (kbd "M-p") 'gniuk/goto-pair-backward)

;; make C-w a bit like when it is in bash command line
(defun gniuk/kill-region-or-kill-backward-to-whitespace ()
  "Kill region when there is a region marked, otherwise kill backward to whitespace."
  (interactive)
  (if (region-active-p)
      (call-interactively #'kill-region)
    (zap-up-to-char -1 ?\s)))
(global-set-key (kbd "C-w") 'gniuk/kill-region-or-kill-backward-to-whitespace)

(provide 'useful-single-key)

;; Local Variables:
;; coding: utf-8
;; indent-tabs-mode: nil
;; require-final-newline: t
;; End:

;;; useful-single-key.el ends here
