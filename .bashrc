# Sample .bashrc for SUSE Linux
# Copyright (c) SUSE Software Solutions Germany GmbH

# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than
# here, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.

test -s ~/.alias && . ~/.alias || true

# Alias
alias sudo="sudo "
alias z="zypper if"
alias zs="zypper se"
alias zi="zypper in"
alias zu="zypper up"
alias et="enter"
alias config='/usr/bin/git --git-dir=/home/noctor/.cfg/ --work-tree=/home/noctor'

# Startship
eval "$(starship init bash)"
