;;; coq-commenter.el --- Coq commenting utility for proof

;; Version: 0.3.0
;; Package-Version: 20160712.001
;; Keywords: comment coq proof
;; Author: Junyoung Clare Jang <jjc9310@gmail.com>
;; Maintainer: Junyoung Clare Jang <jjc9310@gmail.com>
;; URL: -

;;; Commentary:

;; Key settings:

;; "C-<f2>" comment-proof-in-region
;; "C-x C-;" comment-proof-to-cursor
;;
;; "C-'" uncomment-proof-in-region
;; "C-x C-'" uncomment-proof-in-buffer

;; (require 'f)
;; (defconst coq-commenter-file (f-this-file))

(require 's)
(require 'dash)

(defvar comment-proof-in-region-key-old "")

(defvar comment-proof-in-buffer-key-old "")

(defvar comment-proof-to-cursor-key-old "")

(defvar uncomment-proof-in-region-key-old "")

(defvar uncomment-proof-in-buffer-key-old "")

(defvar uncomment-proof-to-cursor-key-old "")

(defun comment-proof-in-region-key-set (symn k)
  "set custom value"
  (progn (global-unset-key (kbd comment-proof-in-region-key-old))
		 (setq comment-proof-in-region-key-old k)
		 (global-set-key (kbd k)
						 (lambda ()
						   (interactive)
						   (comment-proof-in-region)))))

(defun comment-proof-in-buffer-key-set (symn k)
  "set custom value"
  (progn (global-unset-key (kbd comment-proof-in-buffer-key-old))
		 (setq comment-proof-in-buffer-key-old k)
		 (global-set-key (kbd k)
						 (lambda ()
						   (interactive)
						   (comment-proof-in-buffer)))))

(defun comment-proof-to-cursor-key-set (symn k)
  "set custom value"
  (progn (global-unset-key (kbd comment-proof-to-cursor-key-old))
		 (setq comment-proof-to-cursor-key-old k)
		 (global-set-key (kbd k)
						 (lambda ()
						   (interactive)
						   (comment-proof-to-cursor)))))

(defun uncomment-proof-in-region-key-set (symn k)
  "set custom value"
  (progn (global-unset-key (kbd uncomment-proof-in-region-key-old))
		 (setq uncomment-proof-in-region-key-old k)
		 (global-set-key (kbd k)
						 (lambda ()
						   (interactive)
						   (uncomment-proof-in-region)))))

(defun uncomment-proof-in-buffer-key-set (symn k)
  "set custom value"
  (progn (global-unset-key (kbd uncomment-proof-in-buffer-key-old))
		 (setq uncomment-proof-in-buffer-key-old k)
		 (global-set-key (kbd k)
						 (lambda ()
						   (interactive)
						   (uncomment-proof-in-buffer)))))

(defun uncomment-proof-to-cursor-key-set (symn k)
  "set custom value"
  (progn (global-unset-key (kbd uncomment-proof-to-cursor-key-old))
		 (setq uncomment-proof-to-cursor-key-old k)
		 (global-set-key (kbd k)
						 (lambda ()
						   (interactive)
						   (uncomment-proof-to-cursor)))))

(defgroup coq-commenter nil
  "coq-commenter customization group"
  :group 'convenience)

;;
;;
;; Start of Key Setting
;;
;;

(defcustom comment-proof-in-region-key "C-;"
  "key for comment-proof-in-region command"
  :set 'comment-proof-in-region-key-set
  :initialize 'custom-initialize-set)

(defcustom comment-proof-in-buffer-key ""
  "key for comment-proof-in-buffer command"
  :set 'comment-proof-in-buffer-key-set
  :initialize 'custom-initialize-set)

(defcustom comment-proof-to-cursor-key "C-x C-;"
  "key for comment-proof-to-cursor command"
  :set 'comment-proof-to-cursor-key-set
  :initialize 'custom-initialize-set)

(defcustom uncomment-proof-in-region-key "C-'"
  "key for uncomment-proof-in-region command"
  :set 'uncomment-proof-in-region-key-set
  :initialize 'custom-initialize-set)

(defcustom uncomment-proof-in-buffer-key "C-x C-'"
  "key for uncomment-proof-in-buffer command"
  :set 'uncomment-proof-in-buffer-key-set
  :initialize 'custom-initialize-set)

(defcustom uncomment-proof-to-cursor-key ""
  "key for uncomment-proof-to-cursor command"
  :set 'uncomment-proof-to-cursor-key-set
  :initialize 'custom-initialize-set)

;;
;;
;; End of Key Setting
;;
;;

(defcustom added-keyword-indent 2
  "Indentation of added keyword(default is Admit)."
  )

;; Common Codes

(defconst coq-commenter-v
  "154303401202")
(defconst coq-commenter-comment
  (s-concat
   "coq-commenter automat"
   coq-commenter-v
   "ic"
   ))
(defconst coq-commenter-comment-regex
  (s-concat
   "coq-commenter automat"
   "[[:digit:]]"
   "ic"))

(defconst coq-proof-start-regex
  "\\(Proof\\(?:\\.\\| with .*\\.\\)\\|Obligation [0-9]*\\.\\|Next Obligation\\.\\)")

(defconst coq-proof-end-regex
  "\\(Qed\\(?:\\.\\| exporting\\.\\)\\)")
;; (defconst coq-proof-end-abnormal-regex
;;   "\\(\\(Abort\\.\\)\\|\\(Defined\\.\\)\\|\\(Admitted\\.\\)\\|\\(Admit\\.\\)\\)")

;; (defconst coq-proof-end-regex
;;   (s-concat
;;    coq-proof-end-normal-regex
;;    "\\|"
;;    coq-proof-end-abnormal-regex
;;    ))

(defconst spaces-regex
  "[[:space:]]*")

;; Commenting Codes

(defconst commenting-from
  (s-concat
   coq-proof-start-regex
   "\\([[:print:] \t\r\n]*\\)"
   coq-proof-end-regex
   ))
(defconst commenting-to-prefix
  (s-concat
   "\\1"
   "\n(" (s-repeat 20 "*") "\n"
   "\\2"
   "\\3"
   coq-commenter-comment
   "\n" (s-repeat 20 "*") ")\n"
   ))
(defconst commenting-to
  (s-concat
   commenting-to-prefix
   (s-repeat added-keyword-indent " ")
   "Admitted."
   ))

(defun between-pos (a b)
  (and (< (car a) (car b)) (> (cdr a) (cdr b))))

(defun between-poss (a bl)
  (--none? (between-pos it a) bl))

(defun distance (a b)
  (- (car b) (cdr a)))

(defun find-closest-start (startl end)
  (let ((closest  '(0 . 0))
		(lst      startl))
	(progn
	  (while (and (not (null lst)) (< 0 (distance (car lst) end)))
		(if (< (distance (car lst) end) (distance closest end))
			(setq closest (car lst)))
		(setq lst (cdr lst)))
	  (if (and (/= (car closest) 0) (/= (cdr closest) 0))
		  (cons closest (cons end nil))))))

(defun find-proofs (str comments proofstarts proofends)
  ""
;;  (print (cons "comment  " comments))
;;  (print (cons "proofends" proofends))
  (if (or (null proofstarts) (null proofends))
	  nil
	(let ((proofstarts1 (--filter (between-poss it comments) proofstarts))
		  (proofends1   (--filter (between-poss it comments) proofends)))
	  (--filter (not (null it)) (--map (find-closest-start proofstarts1 it) proofends1)))))

(defun comment-proof-at (proofpos qedpos)
  (print (cons (car proofpos) (cdr qedpos)))
  (perform-replace
   commenting-from
   commenting-to
   nil t nil nil nil
   (- (car proofpos) 1) (cdr qedpos)))

(defun coq-add-start-positions (pl start)
  (--map (cons (+ (car it) start) (+ (cdr it) start)) pl))

(defun comment-proof-from-to (start end)
  "Commenting proofs from start to end."
  (save-excursion
	(let ((fullstr   (buffer-substring-no-properties (point-min) (point-max)))
		  (str       (buffer-substring-no-properties start end)))
	  (let ((comments    (s-matched-positions-all
						  "(\\*[[:print:] \t\r\n]*?\\*)"
						  fullstr))
			(proofstarts (coq-add-start-positions
						  (s-matched-positions-all coq-proof-start-regex str)
						  start))
			(proofends   (coq-add-start-positions
						  (s-matched-positions-all coq-proof-end-regex str)
						  start)))
		(let ((proofs (find-proofs str comments proofstarts proofends)))
		  (progn
			(setq proofs (reverse proofs))
			(--map (comment-proof-at (car it) (cadr it)) proofs)))))))

(defun comment-proof-in-region ()
  (interactive)
  "Commenting proofs in the region."
  (if (null (use-region-p))
          (print "No region specified!")
        (comment-proof-from-to (region-beginning) (region-end))))

(defun comment-proof-in-buffer ()
  "Commenting proofs in the buffer."
  (interactive)
  (comment-proof-from-to (point-min) (point-max)))

(defun comment-proof-to-cursor ()
  "Commenting proofs to the cursor point."
  (interactive)
  (comment-proof-from-to (point-min) (point)))




;; Uncommenting functions

(defconst uncommenting-from
  (s-concat
   coq-proof-start-regex
   "\\(?:\n\\|\\)(" (s-repeat 20 "\\*") "\n"
   "\\(\\(?:[[:print:] \n\r\t]\\)*?\\)"
   coq-proof-end-regex
   "coq-commenter automat-?\\(?:[[:digit:]]*\\)ic"
   "\n" (s-repeat 20 "\\*") ")\n"
   spaces-regex
   "Admitted."))

(defconst uncommenting-to
  (s-concat
   "\\1"
   "\\2"
   "\\3"))

(defun uncomment-proof-from-to (start end)
  "Uncommenting proofs from start to end."
  (save-excursion
	(let ((windstart (window-start)))
	  (progn
		(perform-replace
		 uncommenting-from
		 uncommenting-to
		 nil t nil nil nil
		 start end)
		(set-window-start (selected-window) windstart)))))

(defun uncomment-proof-in-region ()
  "Uncommenting proofs in the region."
  (interactive)
  (if (null (use-region-p))
          (print "No region specified!")
        (uncomment-proof-from-to (region-beginning) (region-end))))

(defun uncomment-proof-in-buffer ()
  "Uncommenting proofs in the buffer."
  (interactive)
  (uncomment-proof-from-to (point-min) (point-max)))

(defun uncomment-proof-to-cursor ()
  "Uncommenting proofs to the cursor point."
  (interactive)
  (uncomment-proof-from-to (point-min) (point)))

(provide 'coq-commenter)
