# ~/.bash_logout

RETVAL=$?

if [ "$TERM" = "Linux" ] # console login, not emulator/ssh
  then clear
  else printf "\033]0;\007" # reset titlebar
fi

# log out of sudo, just in case
command -v sudo >/dev/null 2>&1 && sudo -k 2>/dev/null

return $RETVAL
