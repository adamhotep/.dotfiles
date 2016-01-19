augroup filetypedetect
  au BufRead,BufNewFile *.wiki setfiletype Wikipedia
  " I don't think these properly pre-empt the spamassassin bit...
  au BufNewFile,BufRead sendmail.cf	setf sm 	" sendmail
  au BufNewFile,BufRead main.cf		setf pfmain	" postfix
  au BufRead,BufNewFile *.cf,*/[^.]\\\{1,\}.pre,user_prefs set nolinebreak syn=spamassassin
  au BufRead,BufNewFile msg.*[0-9][0-9][0-9][0-9][0-9] setfiletype mail
  " See http://en.wikipedia.org/wiki/Text_editor_support#Vim
  " Moved apache and itsalltext/wikipedia stuff to scripts.vim (as overrides)
  au BufRead,BufNewFile *.thtml,*.ctp setfiletype php " for cakePHP
  au BufRead,BufNewFile */.devilspie/*.ds setfiletype scheme|set ts=2
  au BufRead,BufNewFile */.aliases setfiletype sh " I use this in bashrc/zshrc
  au BufRead,BufNewFile */.zsh/* setfiletype zsh
  au BufRead,BufNewFile */.ssh/authorized_keys* set nolinebreak syn=conf
  au BufRead,BufNewFile */.ssh/known_hosts* set nolinebreak syn=conf
  au BufRead,BufNewFile apt.conf,*/apt.conf.d/* setfiletype c
  au BufRead,BufNewFile */apt/preferences,*/apt/preferences.d/*, setfiletype debprefs
  au BufRead,BufNewFile /etc/apache*/*/* setfiletype apache " a debian-ism
  au BufRead,BufNewFile /etc/bind/{named.conf,zones}.* setfiletype named
  au BufRead,BufNewFile /etc/cron.d/* setfiletype crontab
  au BufRead,BufNewFile /etc/default/* setfiletype sh " a debian-ism (+gentoo)
  au BufRead,BufNewFile /etc/procmailrc setfiletype procmail
  au BufRead,BufNewFile /etc/sudoers.d/* setfiletype sudoers
  au BufRead,BufNewFile /etc/X11/*xorg.conf* setfiletype xf86conf
augroup END

