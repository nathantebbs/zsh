#SETUP
printf '\33c\e[3J'
for ZSH_FILE in "${ZDOTDIR:-$HOME}"/zsh.d/*.zsh(N); do
    source "${ZSH_FILE}"
done  

# zsh completions
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    autoload -Uz compinit
    compinit
  fi

# History configuration
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt APPEND_HISTORY            # append to history file
setopt HIST_NO_STORE             # Don't store history commands

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Prompt
fpath=($ZDOTDIR/prompts $fpath)

setopt PROMPT_SUBST
autoload -Uz promptinit; promptinit
prompt agkozak-zsh-prompt

# Colors
AGKOZAK_COLORS_PROMPT_CHAR=yellow


# MISC

# press Alt+. to insert the last word from the previous command
autoload -U smart-insert-last-word
zle -N smart-insert-last-word
bindkey "\e." smart-insert-last-word

# Highlight on tab
zstyle ':completion:*' menu select


# FUNCTIONS

# Fuzzy find history
function fh() {
    eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

# Search history with ripgrep
function h() {
	if [ -z "$*" ]; then
		history 1
	else
		history 1 | rg "$@"
	fi
}




# Add the ability to print >> << for the portion of the cli we'll be using
autoload -Uz narrow-to-region

# define our function
function _history-incremental-preserving-pattern-search-backward
{
  local state
  MARK=CURSOR  
  narrow-to-region -p "$LBUFFER${BUFFER:+>>}" -P "${BUFFER:+<<}$RBUFFER" -S state
  zle end-of-history
  zle history-incremental-pattern-search-backward
  narrow-to-region -R state
}

# load the function into zle
zle -N _history-incremental-preserving-pattern-search-backward

# bind it to ctrl+r
bindkey "^R" _history-incremental-preserving-pattern-search-backward
bindkey -M isearch "^R" history-incremental-pattern-search-backward
bindkey "^S" history-incremental-pattern-search-forward





# ALIAS's
alias zc="vim $ZDOTDIR/.zshrc"
alias zd="vim $ZDOTDIR"
alias zu="source $ZDOTDIR/.zshrc"
alias r="fc -e -"
alias vim="nvim"
alias ls="ls --color"
alias la="ls -la"
alias l="ls -l"

alias kd="vim ~/.config/kitty/"

alias devlog="cd ~/dev/personal/webapps/devlog/"

# tmux alias
alias tmls="tmux ls"
alias tmks="tmux kill-server"
alias tmn="tmux new"
alias tmc="vim ~/.tmux.conf"
alias tma="tmux a"

# Docker

# 252
alias 252docker="docker run -ti -v .:/root ghcr.io/russ-lewis/csc252-students"

# Go
alias godoc="go doc"
alias gr="go run ./main.go"


# dirs
alias dev="cd ~/dev"
alias class="~/dev/class/cs/"
alias personal="cd ~/dev/personal/"
alias 252="cd ~/dev/class/cs/252/projects/"


# PATH edits
PATH=$PATH:/opt/homebrew/Cellar/postgresql@15/15.7/bin
PATH=$PATH:$HOME/go/bin/




# DIRENV
eval "$(direnv hook zsh)"
# fzf
source <(fzf --zsh)
