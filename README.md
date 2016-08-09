# Coq Commenter #

![Emacs Version][Emacs]
![Update Status][Status]

[Emacs]: https://img.shields.io/badge/Emacs->=24.1-blue.svg
[Status]: https://img.shields.io/badge/Status-Active-green.svg

Emacs commeting support tools for Coq proof assistance  
_In any case of problem, please contact me via [issue][issue]_

[issue]: https://github.com/Ailrun/coq-commenter/issues

## How to use ##

First, install dependencies. This .el file requires [s][s] and [dash][dash] emacs packages (you can install them via `package-install`)

Then, Copy `coq-commenter.el` to your `.emacs.d` directory (all any equivalent), and add following codes in your `.emacs` or `.emacs.d/init.el`

```
(load "coq-commenter-path")
```

where `"coq-commenter-path"` be the real path that you place `coq-commenter.el` in, and activate `coq-commenter-mode` on your target buffer.

On the other way, when you use [ProofGeneral][ProofGeneral], you can automatically turn on this mode by hooking to coq-mode.

```
(add-hook 'coq-mode-hook 'coq-commenter-mode)
```

[s]: https://github.com/magnars/s.el
[dash]: https://github.com/magnars/dash.el

## Commands ##

- comment-proof-in-region
  - commenting proof in selected region.
- comment-proof-in-buffer
  - commenting proof in current buffer.
- comment-proof-to-cursor
  - commenting proof from start to cursor
- uncomment-proof-in-region
  - uncommenting proof in selected region.
- uncomment-proof-in-buffer
  - uncommenting proof in current buffer.
- uncomment-proof-to-cursor
  - uncommenting proof from start to cursor

## Key setting ##

You can add these key setting yourself with following elisp code. Because of emacs key binding convention, these keys are not package integrated.

```
  (define-key coq-commenter-mode-map
              (kbd "C-;")
              #'coq-commenter-comment-proof-in-region)
  (define-key coq-commenter-mode-map
              (kbd "C-x C-;")
              #'coq-commenter-comment-proof-to-cursor)
  (define-key coq-commenter-mode-map
              (kbd "C-'")
              #'coq-commenter-uncomment-proof-in-region)
  (define-key coq-commenter-mode-map
              (kbd "C-x C-'")
              #'coq-commenter-uncomment-proof-in-buffer)
```

- C-; (Ctrl-;)
  - comment-proof-in-region
- C-x C-; (Ctrl-x Ctrl-;)
  - comment-proof-to-cursor
- C-' (Ctrl-')
  - uncomment-proof-in-region
- C-x C-' (Ctrl-x Ctrl-')
  - uncomment-proof-in-buffer

## Author ##

Junyoung Clare Jang([@Ailrun][Github])

- [Blog][Blog]
- [Github][Github]

[Blog]: https://ailrun.github.io
[Github]: https://github.com/ailrun
