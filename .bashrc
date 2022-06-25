# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=-1
HISTFILESIZE=-1 # sets to infinite history length

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
alias ls='ls -Alh --color=auto'
alias ai='sudo apt install'
alias aud='sudo apt update -y; sudo apt upgrade -y'
alias as='apt search'
alias ar='sudo apt remove'
alias aar='sudo apt autoremove'
alias gc='git clone' #clone a git repo
alias gpl='git pull' #pull updates from a git repo
alias gph='git push' #push local updates to a git repo
alias gl='git log' #check git log
alias ga='git add -A' #add all changes to commit
alias gs='git status' #check git status
alias ga='git add -A'
alias dfh='df -h' #disk space
alias dush='du -sh'
alias untar='tar -zxvf' #extract files from archive
alias ipe='curl ipinfo.io/ip' #check external ip address
alias c='clear' #clear terminal
alias words='wc -w' #check word count of a file
alias eb='clear && exec bash' #reload bash and clear the terminal screen
alias back='cd -' #go back to the directory you were in previously (should probably add some pushd stuff here)
# -v adds verbosity, -i makes it interactive
alias mkdir='mkdir -pv' #make a directory allowing for layering e.g. mkdir foo/bar/
alias rm='rm -vi' #remove file
alias rmr='rm -rv' #remove recursively
alias rmdir='rmdir -v' #remove directory
alias cp='cp -vi'  #copy
alias cpdir='cp -vr' #copy directory and contents
alias mv='mv -vi' #move
alias upstats='echo "Up since:" && uptime -s && uptime -p' #displays uptime stats
alias pullall='for i in */.git; do cd $(dirname $i); git pull -q; cd ..; done; echo done'
alias gzipc='gzip --keep -9' #max compression keeping the file
alias gitamendcomment='git commit --amend'
alias reboot='sudo reboot'
alias docker='sudo docker'
alias builddocs='git pull; docker stop docs; docker rm docs; JEKYLL_ENV=production bundle exec jekyll b; docker build -t docs .; docker run -d --name=docs -p 2001:80 docs:latest'
alias updatebashrc='read -p "cancel if you do not want your bashrc to change. Press enter if you want to overwrite your bashrc" ;cd ~/dotfiles;git pull; cat .bashrc > ~/.bashrc; exec bash' # change into your config repo and update it. overwrite your current bashrc with the remote contents and restart bash

up () { #goes up x directories
  local d=""
  local limit="$1"

  # Default to limit of 1
  if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
    limit=1
  fi

  for ((i=1;i<=limit;i++)); do
    d="../$d"
  done

  # perform cd. Show error if cd fails
  if ! cd "$d"; then
    echo "Couldn't go up $limit dirs.";
  fi
}

# from https://github.com/dylanaraps/pure-bash-bible/blob/master/README.md

bkr() { #runs a command in the background
    (nohup "$@" &>/dev/null &)
}

trim_all() { #trim all y from string x
    # Usage: trim_all "   example   string    "
    set -f
    set -- $*
    printf '%s
' "$*"
    set +f
}

split() { #split a string based on a delimiter
   # Usage: split "string" "delimiter"
   IFS=$'
' read -d "" -ra arr <<< "${1//$2/$'
'}"
   printf '%s
' "${arr[@]}"
}

lower() { #convert to lowercase
    # Usage: lower "string"
    printf '%s
' "${1,,}"
}

upper() { #convert to uppercase
    # Usage: upper "string"
    printf '%s
' "${1^^}"
}

reverse_case() { #reverse the case of a string
    # Usage: reverse_case "string"
    printf '%s
' "${1~~}"
}

strip_all() { #strp all y from x
    # Usage: strip_all "string" "pattern"
    printf '%s
' "${1//$2}"
}

lines() { #show line count of file
    # Usage: lines "file"
    mapfile -tn 0 lines < "$1"
    printf '%s
' "${#lines[@]}"
}

# # ex = EXtractor for all kinds of archives
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   unzstd $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

#some functions from https://ohshitgit.com
gitresettoremote() {
  read -p "Enter branch name: " branchname
  git fetch origin
  git checkout $branchname
  git reset --hard origin/$branchname
  git clean -d --force
}
gitamendfiles() {
  git add . # or add individual files
  git commit --amend --no-edit
}
gittimemachine() {
  git reflog
  read -p "Enter index: " index
  # you will see a list of every thing you've
  # done in git, across all branches!
  # each one has an index HEAD@{index}
  # find the one before you broke everything
  git reset HEAD@{$index}
  # magic time machine
}
gitcloneorg() {
  read -p "Enter org name: " name
  GHORG={$name}; curl "https://api.github.com/orgs/$GHORG/repos?per_page=1000" | grep -o 'git@[^"]*' | xargs -L1 git clone

}

