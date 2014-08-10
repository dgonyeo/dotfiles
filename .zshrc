#!/bin/zsh

# The following lines were added by compinstall
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' format 'completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list '' 'r:|[._-/]=** r:|=**' 'l:|=* r:|=*' 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' menu select=long-list select=0
zstyle ':completion:*' original false
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

## Enables auto completion
autoload -Uz compinit
compinit

## Enables colors
autoload -U colors 
colors

## HISTORY ##
# set the history file and size
HISTFILE=~/.zhistory
HISTSIZE=10000
SAVEHIST=10000

# ignore duplicates and append to the file incrementally
setopt HIST_IGNORE_DUPS
setopt INC_APPEND_HISTORY

# search through the history with the arrow keys
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# maintain a list of recent directories, for quick cd'ing to
DIRSTACKFILE="$HOME/.zdirs"
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
  dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
  [[ -d $dirstack[1] ]] && cd $dirstack[1]
fi
chpwd() {
  print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}
DIRSTACKSIZE=20
setopt autopushd pushdsilent pushdtohome

# Remove duplicate entries in the recent directories list
setopt pushdignoredups
# This reverts the +/- operators.
setopt pushdminus

## PROMPT ##
PROMPT="%(?..%{$fg_bold[red]%}%?%{$reset_color%} )%n@%m %~> "
RPROMPT="%D %*"
# don't beep and use emacs bindings
unsetopt beep
bindkey -e

# file with various aliases
source $HOME/.zaliases

## KEYS ##
# Assigns certain keys to the correct actions
# On a new system, type in autoload zkdb and then zkdb to generate a new zkdb file
autoload zkbd
source ~/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE}

[[ -n ${key[Backspace]} ]] && bindkey "${key[Backspace]}" backward-delete-char
[[ -n ${key[Insert]} ]]    && bindkey "${key[Insert]}"    overwrite-mode
[[ -n ${key[Home]} ]]      && bindkey "${key[Home]}"      beginning-of-line
[[ -n ${key[PageUp]} ]]    && bindkey "${key[PageUp]}"    up-line-or-history
[[ -n ${key[Delete]} ]]    && bindkey "${key[Delete]}"    delete-char
[[ -n ${key[End]} ]]       && bindkey "${key[End]}"       end-of-line
[[ -n ${key[PageDown]} ]]  && bindkey "${key[PageDown]}"  down-line-or-history
[[ -n ${key[Up]} ]]        && bindkey "${key[Up]}"        up-line-or-search
[[ -n ${key[Left]} ]]      && bindkey "${key[Left]}"      backward-char
[[ -n ${key[Down]} ]]      && bindkey "${key[Down]}"      down-line-or-search
[[ -n ${key[Right]} ]]     && bindkey "${key[Right]}"     forward-char

#extended globbing
setopt extendedglob

# Terminal title
case $TERM in
    xterm*|*rxvt*)
        precmd () { print -Pn "\e]0;%n@%m: %~\a" }
        preexec () {
            print -Pn "\e]0;%n@%m: $1\a"
        }
        ;;
esac