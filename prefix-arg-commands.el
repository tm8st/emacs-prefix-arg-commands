;;; prefix-arg-commands.el --- 前置引数によってコマンドを呼び分ける為のマクロの提供用拡張

;; Copyright (C) 2010 tm8st

;; Author: tm8st <tm8st@hotmail.co.jp>
(defconst prefix-arg-commands "0.1")
;; Keywords: convenience, command, generate

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the

;; GNU General Public License for more details.

;; You should have received ba  copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.	If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; 前置引数によってコマンドを呼び分ける為のマクロの提供用拡張です。
;; 移動コマンドの呼びわけなどにご利用ください。

;; Installation:

;; (require 'prefix-arg-commands)
;; ;; exapmle commands
;; (global-set-key (kbd "C-f") 'prefix-arg-commands-forward-move-commands)
;; (global-set-key (kbd "C-b") 'prefix-arg-commands-backward-move-commands)
;; (global-set-key (kbd "C-a") 'prefix-arg-commands-back-to-indentation-move-commands)
;; (global-set-key (kbd "C-e") 'prefix-arg-commands-end-of-line-move-commands)
;; (global-set-key (kbd "C-l C-z") 'prefix-arg-commands-set-frame-alpha)

;;; Code:

(defun prefix-arg-commands-call-func (n cmds)
  (interactive)
  "インデックスチェック付き関数呼び出し"
  (if (and (> (length cmds) n))
      (funcall (nth n cmds))
    (message (concat "prefix-arg-commands: Index " (number-to-string n) " にコマンドは登録されていません。"))))

(defun prefix-arg-commands-calc-case-number (n)
  (interactive)
  "C-uの回数別引数の値の計算用関数"
  (if (eq n 0)
      1
    (* (prefix-arg-commands-calc-case-number (- n 1)) 4)))

(defvar prefix-arg-commands-arg-numbers (mapcar `prefix-arg-commands-calc-case-number `(0 1 2 3 4 5 6 7 8 9 10)))

(defmacro prefix-arg-commands-create (name cmds)
  "前置引数によってコマンドを呼びわけるコマンドを引数のリストから生成するマクロ"  
  (fset name
	`(lambda (arg) (interactive "P")
	   (cond
	    ((equal arg `(0)) (prefix-arg-commands-call-func 0 ,cmds))
	    ((equal arg `(4)) (prefix-arg-commands-call-func 1 ,cmds))	      ;;C-u
	    ((equal arg `(16)) (prefix-arg-commands-call-func 2 ,cmds))	      ;;C-u C-u
	    ((equal arg `(64)) (prefix-arg-commands-call-func 3 ,cmds))	      ;;C-u C-u C-u
	    ((equal arg `(256)) (prefix-arg-commands-call-func 4 ,cmds))      ;;C-u C-u C-u C-u
	    ((equal arg `(1024)) (prefix-arg-commands-call-func 5 ,cmds))     ;;C-u C-u C-u C-u C-u
	    ((equal arg `(4096)) (prefix-arg-commands-call-func 6 ,cmds))     ;;C-u C-u C-u C-u C-u C-u
	    ((equal arg `(16384)) (prefix-arg-commands-call-func 7 ,cmds))    ;;C-u C-u C-u C-u C-u C-u C-u
	    ((equal arg `(65536)) (prefix-arg-commands-call-func 8 ,cmds))    ;;C-u C-u C-u C-u C-u C-u C-u C-u
	    ((equal arg `(262144)) (prefix-arg-commands-call-func 9 ,cmds))   ;;C-u C-u C-u C-u C-u C-u C-u C-u C-u
	    ((equal arg `(1048576)) (prefix-arg-commands-call-func 10 ,cmds)) ;;C-u C-u C-u C-u C-u C-u C-u C-u C-u C-u
	    (t (prefix-arg-commands-call-func 0 ,cmds))))))

;; Examples
(prefix-arg-commands-create prefix-arg-commands-forward-move-commands '(forward-char forward-sexp forward-defun))
(prefix-arg-commands-create prefix-arg-commands-backward-move-commands '(backward-char backward-sexp backward-defun))
(prefix-arg-commands-create prefix-arg-commands-back-to-indentation-move-commands '(back-to-indentation beginning-of-buffer))
(prefix-arg-commands-create prefix-arg-commands-end-of-line-move-commands '(end-of-line end-of-buffer))

(defun prefix-arg-commands-set-frame-alpha-set (alpha)
  "サンプル用のフレームへのアルファ値の設定関数"
  (set-frame-parameter nil 'alpha alpha))

(prefix-arg-commands-create prefix-arg-commands-set-frame-alpha
			    (list
			      `(lambda () () (prefix-arg-commands-set-frame-alpha-set 100))
			      `(lambda () () (prefix-arg-commands-set-frame-alpha-set 90))
			      `(lambda () () (prefix-arg-commands-set-frame-alpha-set 70))
			      `(lambda () () (prefix-arg-commands-set-frame-alpha-set 50))
			      `(lambda () () (prefix-arg-commands-set-frame-alpha-set 30))
			      `(lambda () () (prefix-arg-commands-set-frame-alpha-set 15))
			      ))

(provide 'prefix-arg-commands)
