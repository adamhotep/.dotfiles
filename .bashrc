# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc 2>/dev/null
fi

OS=`uname -s`
OS="${OS/IRIX64/IRIX}"
[ "$OS" != "${OS#*CYGWIN}" -a -z "$CYGWIN" ] && CYGWIN="ntsec" # was "ntsec tty"
HOSTNAME=`uname -n`
HOST="${HOSTNAME%%.*}"
USER="${USER:-LOGNAME}"

# clean up given path
pathtok() {
  local IFS=: p=: d
  for d in ${*:-$PATH}; do
    # if a dir,  is absolute,        isn't already in p   then append to p
    [ -d "$d" -a "$d" != "${d#/}" -a "$p" = "${p#*:$d:}" ] && p="$p$d:"
  done
  IFS=' '
  p=${p%%:}	# remove trailing colon (which would otherwise include .)
  echo ${p##:}	# remove leading colon (which would be insanely dangerous)
}

PATH=`pathtok "$HOME/$OS/bin:$HOME/bin:/usr/local/sbin:/usr/local/bin:$PATH"`

export OS HOST HOSTNAME USER PATH

set -o emacs
shopt -s checkwinsize
HISTCONTROL=ignoreboth  # don't remember duplicate or space-leading commands


if [ -n "$PS1" ]; then

case $OS in
  Linux )
    TERMCMD='gnome-terminal'
    ;;
  SunOS )
    # TERM='dtterm'
    ;;
  HP-UX )
    # set sane keybindings; make backspace, @, and ctrl+c work.
    stty intr "^c" erase "^?" kill "^u"
    [ -x ~/HP-UX/bin/which ] && [ -z "$(which -V 2>&1|grep GNU)" ] \
      && alias which='. ~/HP-UX/bin/which'
    ;;
  * )
    ;;
esac


#PS1="\[\e[${PSCOLOR}m\][\u@\h \[\e[0;33m\]\w\[\e[${PSCOLOR}m\]]\$\[\e[0;0m\] "

### PROMPT + TITLEBAR
#PSC() { echo -ne "\[\033[${1:-0;38}m\]"; }
PSC() { echo -ne "\[\e[${1:-0;0}m\]"; } # (run `ansimodes` for codes)
dollar='$' # I lost the ability to specify this as \$ because it's in a helper

# Shorten home dir, cygwin drives, paths that are too long
# (I actually managed to do this with just bourne; no perl, sed, or bashisms!)
# As I posted to https://unix.stackexchange.com/a/178816/87770
function PSWD() {
  local p="$*" parta partb
  if [ "$p" = "${HOME:-empty}${p#$HOME}" ]
    then p="~${p#$HOME}"
  fi
  # Fix Cygwin drive designations
  if [ "$OS" != "${OS#*CYGWIN}" -a "${p#/cygdrive}" != "$p" ]; then
    p="${p#/cygdrive/}"
    parta="${p%%/*}"
    if [ -z "$parta" ]
      then p="$p:"
      else p="$parta:${p#?}"
    fi
  fi
  # if the resulting path is 34+ characters, truncate it
  parta="${p#??????????????????????????????????}"
  if [ "${parta:-$p}" != "$p" ]; then
    parta="${p#??????????}"		# the path, minus the first 10 chars
    parta="${p%$parta}" 		# the first 10 chars of the path
    partb="${p%????????????????????}"	# the path, minus the last 20 chars
    partb="${p#$partb}" 		# the last 20 chars of the path
    p="$parta...$partb" 		# 10 chars plus 3 dots plus 20 chars = 33
  fi
  echo "$p"
}

is() { ls -d "$@" >/dev/null 2>&1; }

# color system name
if [ "$OS" = "${OS#*[Ll]inux}" -a "$OS" = "${OS#*[Bb][Ss][Dd]}" ]
  then PR='0;31' # non-F/OSS: red
elif [ -n "$SSH_TTY$inscreen" ]
  then PR='0;35' # remote: pink
elif [ -n "$GDMSESSION" ] || is ~/.xsession* || is ~/.config/*/
  then PR='0;34' # local: blue
else PR='0;32' # other F/OSS: green
fi

# color username if root or if otherwise not me
if [ "$(id -u 2>/dev/null || id|sed 's/uid=0[^0-9].*/0/' 2>/dev/null)" = 0 ]
  then sudo=41 dollar='#'	# root is red background, # instead of $
  #elif [ "$USER" != "${HOME##*}" ]
  elif [ "${SUDO_USER:-$USER}" != "$USER" ]
    then sudo=31	# not root, not self: red text
  else sudo="$PR"	# standard user color
fi

# toggle prompt between dumb failsafe and risky colorful version
alias PS1='[ "$PS1" = "${PSold:=$PS1}" ] && PS1="\u@\h \w\\$ " || PS1="$PSold"'

PSB="$(PSC '1;32')" # bold green
# vim (and presumably bash) treats "PS1=blah" lines specially.  Don't.
PSbase="$PSB[$(PSC $sudo)\u$(PSC $PR)@\h $(PSC '0;33')\$(PSWD \w)$PSB]"
# colorize 'dollar' w.r.t. whether last cmd worked.  y=green(32), n=red(31)
PSbase="$PSbase$(PSC 32)\$PSY$(PSC 31)\$PSN$(PSC) " # PSY/N set by PROMPT_COMMAN
PS1="$PSbase"
unset sudo PR PSB PSbase

# safely print to titlebar (and stdout unless -q is passed)
title_say() {
  [[ "$1" != "-q" ]] && echo "$*" || shift
  printf "\033]0;$*\007"
}

title_prompt() { title_say -q "$USER@${HOST%%.*}:${PWD/#$HOME/~}"; }
pr_err() { [ $? = 0 ] && PSY="$dollar" PSN='' || PSN="$dollar" PSY=''; }
__path_log() { true; }  # to be overridden in ~/.aliases
PROMPT_COMMAND="pr_err; title_prompt; __path_log"

export PS1 TERMCMD

### DONE PROMPT + TITLEBAR


screen -r >/dev/null 2>&1

for file in ~/.pathfix ~/.aliases; do
  [ -r $file ] && . $file
done

# in FC8, this inexplicably terminates the script
[ -z "$BASH_COMPLETION" -a -r /etc/bash_completion ] && . /etc/bash_completion

fi # end interactive (PS1) stuff

true
