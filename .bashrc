
# Settings
bind 'set show-all-if-ambiguous on'
bind '"\t":menu-complete'
bind '"\e[Z":menu-complete-backward'
bind 'set bell-style none'

# Alias

## Config
alias reload='. ~/.bashrc'
alias bashrc='nvim ~/.bashrc'
alias nvimc="nvim ~/.config/nvim/init.lua"

## Operations
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../../"
alias lg="lazygit"
alias ff='fd . | fzf'
alias ls='eza -lah --icons --no-git --header --group-directories-first --sort=name'

eval "$(starship init bash)"
fastfetch

export EDITOR='nvim'
