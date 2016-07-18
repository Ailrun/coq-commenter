# Coq Commenter #

![Emacs Version][Emacs]
![Update Status][Status]

[Emacs]: https://img.shields.io/badge/Emacs->=24.1-blue.svg
[Status]: https://img.shields.io/badge/Status-Active-green.svg

Emacs commeting support tools for Coq proof assistance  
_In any case of problem, please contact me via [issue][issue]

[issue]: https://github.com/Ailrun/coq-commenter/issues

## How to use ##

Copy `coq-commenter.el` to your `.emacs.d` directory (all any equivalent), and add following codes in your `.emacs` or `.emacs.d/init.el`

```
(load "coq-commenter-path")
```

where `"coq-commenter-path"` be the real path that you place `coq-commenter.el`

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

- C-; (Ctrl-;)
  - comment-proof-in-region
- C-x C-; (Ctrl-x Ctrl-;)
  - comment-proof-to-cursor
- C-' (Ctrl-')
  - uncomment-proof-in-region
- C-x C-' (Ctrl-x Ctrl-')
  - uncomment-proof-in-buffer

You can change these key by using
`customize-group` `coq-commentor`

or by modifying front part of `coq-commenter.el` file.

## Author ##

Junyoung Clare Jang([@Ailrun][Github])

- [Blog][Blog]
- [Github][Github]

[Blog]: https://ailrun.github.io
[Github]: https://github.com/ailrun
