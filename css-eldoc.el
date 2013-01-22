;;; css-eldoc.el --- an eldoc-mode plugin for CSS source code

;; Copyright (C) 2012  Zeno Zeng

;; Author: Zeno Zeng <zenoes@qq.com>
;; Keywords: 

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:
(eval-when-compile
  (require 'cl nil t))

(require 'css-eldoc-hash-table)

;;;###autoload
(defun css-eldoc-function()
  (ignore-errors
    (save-restriction
      (narrow-to-region (line-beginning-position) (point))
      (let* ((beg
	      (save-excursion
		(+ 1 (or
		      (re-search-backward "\\(;\\|{\\)" nil t)
		      (- (point-min) 1)))))
	     (end
	      (save-excursion
		(or
		 (re-search-backward ":" nil t)
		 (point-max))))
	     (property (buffer-substring-no-properties beg end)))

	(setq property (replace-regexp-in-string "[\t\n ]+" "" property))

	(replace-regexp-in-string "|"
				  (propertize "|" 'face 'compilation-mode-line-run)
				  (gethash property css-eldoc-hash-table))))))

;;;###autoload
(add-hook 'css-mode-hook
	  '(lambda ()
	     (set
	      (make-local-variable 'eldoc-documentation-function)
	      'css-eldoc-function)
	     (eldoc-mode)))

(provide 'css-eldoc)
;;; css-eldoc.el ends here
