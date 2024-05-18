#!/bin/sh

export GVIMINIT='let $MYGVIMRC="$XDG_CONFIG_HOME/vim/gvimrc" | source $MYGVIMRC'
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'

# ~/ Clean-up:
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

if [[ -z $TMUX ]]; then
  # Add all directories in `~/.local/bin` to $PATH
  export PATH="$PATH:$(find ~/.local/bin -type d | paste -sd ':' -)"
  export LD_LIBRARY_PATH=${XDG_DATA_HOME}/lib:$LD_LIBRARY_PATH
fi

# Start X if not started on tty 1 yet
HOST_NAME=$(uname -n)
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  SESSION_TYPE="remote/ssh"
elif systemctl -q is-active graphical.target; then
  if [[ ! $DISPLAY && $XDG_VTNR -eq 3 && $HOST_NAME = "AX15" ]]; then
    exec startx
  fi
  if [[ ! $DISPLAY && $XDG_VTNR -lt 2 && $HOST_NAME = "archpcx240" ]]; then
    exec startx
  fi
fi
