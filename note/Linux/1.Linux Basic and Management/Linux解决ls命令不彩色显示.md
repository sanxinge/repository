---
date: 2016-06-27 20:29
status: public
title: Linux解决ls命令不彩色显示
---

1、临时生效
临时生效彩色的话可以通过执行alias ls='ls --color'，关掉终端就不再显示了
2、永久生效
修改~/.bashrc ，将干面的行首的"#"去掉即可

export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias la='ls $LS_OPTIONS -la'