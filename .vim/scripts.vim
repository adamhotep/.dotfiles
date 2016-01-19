" See also http://en.wikipedia.org/wiki/Text_editor_support#Vim

"if &filetype == "" && &syntax == ""
if expand("%:p") =~ "/.mozilla/firefox/.[^/]*/itsalltext/"   " It's All Text!
  if expand("%:p") =~ '\v/([a-z_0-9.-]*\.)?(userscripts\.org|slashdot.org)\.[^/]*$'
    setfiletype html
  elseif expand("%:p") =~ '\v/([a-z_0-9.-]*\.)?(issues.apache.org|iaf-track|bug(s|zilla))\.[^/]*$'
    setfiletype mail
    syn match bug "\<bug\s\+\d\+\>\%(\s\+comment\s\+#?\s*\d+\>\)?"
    syn match bug "\<comment\s\+#?\s*\d+\>"
    hi def link bug Identifier
    if has('gui_running')
      autocmd GuiEnter * set columns=76 lines=40
    endif
  elseif expand("%:p") =~ '\v/([a-z_0-9.-]*\.)?(wikicentral|confluence)\.[^/]*$'
    setfiletype confluencewiki
  else " default itsalltext to wiki syntax
    setfiletype Wikipedia
  endif
elseif expand("%:p") =~ '\v^/(etc|usr(/local)?)/(httpd/conf|apache2?)/.'
  setfiletype apache " see also the /etc/apache*/*/* debian-ism in filetype.vim
elseif getline(1) =~# '\v<(!DOCTYPE [^>]*)?(HTML|html).*>'
  setfiletype html " override w/ html
endif
finish

