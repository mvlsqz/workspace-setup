# Fish Shell Configuration

# Disable greeting
set -g fish_greeting

# Environment variables
set -gx EDITOR nvim
set -gx VISUAL nvim

# Aliases
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias vim='nvim'
alias v='nvim'

# Git aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'

# Navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Add local bin to PATH if it exists
if test -d ~/.local/bin
    set -gx PATH ~/.local/bin $PATH
end

# Homebrew (if on macOS)
if test -d /opt/homebrew/bin
    set -gx PATH /opt/homebrew/bin $PATH
end
