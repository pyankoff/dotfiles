;;; prelude-common-lisp.el --- Emacs Prelude: lisp-mode and n
;; Author: Bozhidar Batsov <bozhidar@batsov.com>
;; URL: https://github.com/bbatsov/prelude
;; Version: 1.0.0
;; Keywords: convenience

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Configuration for lisp-mode and SLIME.

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

(require 'prelude-lisp)

(prelude-require-package 'slime)

;; the SBCL configuration file is in Common Lisp
(add-to-list 'auto-mode-alist '("\\.sbclrc\\'" . lisp-mode))

;; Open files with .cl extension in lisp-mode
(add-to-list 'auto-mode-alist '("\\.cl\\'" . lisp-mode))

;; a list of alternative Common Lisp implementations that can be
;; used with SLIME. Note that their presence render
;; inferior-lisp-program useless. This variable holds a list of
;; programs and if you invoke SLIME with a negative prefix
;; argument, M-- M-x slime, you can select a program from that list.
(load (expand-file-name "~/.roswell/impls/ALL/ALL/quicklisp/slime-helper.el"))
(setq inferior-lisp-program "/usr/local/bin/ros -L sbcl -Q -l ~/.sbclrc run")

;; select the default value from slime-lisp-implementations
(if (and (eq system-type 'darwin)
         (executable-find "ccl"))
    ;; default to Clozure CL on OS X
    (setq slime-default-lisp 'ccl)
  ;; default to SBCL on Linux and Windows
  (setq slime-default-lisp 'sbcl))

;; Add fancy slime contribs
(setq slime-contribs '(slime-fancy))

(add-hook 'lisp-mode-hook (lambda () (run-hooks 'prelude-lisp-coding-hook)))
;; rainbow-delimeters messes up colors in slime-repl, and doesn't seem to work
;; anyway, so we won't use prelude-lisp-coding-defaults.
(add-hook 'slime-repl-mode-hook (lambda ()
                                  (smartparens-strict-mode +1)
                                  (whitespace-mode -1)))

(eval-after-load "slime"
  '(progn
     (setq slime-enable-evaluate-in-emacs t
           slime-autodoc-use-multiline-p t
           slime-auto-start 'always)

     (define-key slime-mode-map (kbd "TAB") 'hippie-expand)
     (define-key slime-mode-map (kbd "C-c C-s") 'slime-selector)))

(provide 'prelude-common-lisp)

;;; prelude-common-lisp.el ends here