[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Prompt: tangerine user, mint path
PS1='\[\e[38;2;255;122;61m\]\u\[\e[0m\]@\h \[\e[38;2;61;219;168m\]\w\[\e[0m\] ❯ '

# Show system info once per terminal
command -v fastfetch >/dev/null && [[ -z $SMLINUX_FETCHED ]] && export SMLINUX_FETCHED=1 && fastfetch
