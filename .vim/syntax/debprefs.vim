" Vim syntax file
" Language: Debian/Ubuntu APT preferences file
" Maintainer: Adam Katz <scriptsATkhopiscom>
" Last Change: 2016 Jan 16
" URL: http://khopis.com/scripts

" Save this file to ~/.vim/syntax/spamassassin.vim
" and add the following to your ~/.vim/filetype.vim:
" 
"     augroup filedetect
"         au BufRead,BufNewFile */apt/preferences,*/apt/preferences.d/*, setfiletype apt-preferences
"     augroup END

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" case sensitive
syn case match

" import debsources for source names (which aren't a group ... grumble)
"runtime! syntax/debsources.vim
"unlet b:current_syntax

set iskeyword+=-
set iskeyword+=:

syn match debprefsLine /^/ nextgroup=debprefsType,debprefsInvalid

syn keyword debprefsType Explanation: contained nextgroup=debprefsExplain
  syn match debprefsExplain /.*/ contains=@Spell contained
syn keyword debprefsType Package: contained
syn keyword debprefsType Pin: contained nextgroup=debprefsPinType
  syn keyword debprefsPinType origin release version nextgroup=debprefsPin
  syn match debprefsPin /.*/ contained contains=debprefsDist,debprefsXDist

" constant distro names (always relevant)
syn keyword debprefsDist oldstable stable testing unstable contained
syn keyword debprefsDist experimental sid devel rc-buggy contained

" Debian currently supported distro release names, includig backports
syn keyword debprefsDist squeeze wheezy jessie stretch contained
syn keyword debprefsDist squeeze-backports wheezy-backports contained
syn keyword debprefsDist jessie-backports stretch-backports contained

" Ubuntu currently supported distro release names, includig backports
syn keyword debprefsDist precise trusty vivid wily xenial contained
syn keyword debprefsDist precise-backports trusty-backports contained
syn keyword debprefsDist vivid-backports wily-backports contained
syn keyword debprefsDist xenial-backports contained

" Debian unsupported distro release names
syn keyword debprefsXDist buzz rex bo hamm slink potato woody sarge contained
syn keyword debprefsXDist etch lenny contained

" Ubuntu unsupported distro release names
syn keyword debprefsXDist warty hoary breezy dapper edgy feisty gutsy contained
syn keyword debprefsXDist hardy intrepid jaunty karmic lucid maverick contained
syn keyword debprefsXDist natty oneiric quantal raring saucy utopic contained

" Any other backport is unsupported
syn match debprefsXDist /\w\+-backports/ contained


" this doesn't work, so I added dash to iskeyword (affects backports handling)
"syn match debprefsType /Pin-Priority:/ contained
syn keyword debprefsType Pin-Priority: contained
" the debprefsPriority regex refuses to match...
"syn keyword debprefsType Pin-Priority: contained nextgroup=debprefsPriority,debprefsInvalid skipwhite
"  syn match debprefsPriority /-\?[0-9]\+/ contained nextgroup=debprefsInvalid

syn match debprefsInvalid /\S.*/ contained

"hi def link debprefsExplain 	Comment
hi def link debprefsType 	Statement
hi def link debprefsPinType 	Type
hi def link debprefsPin 	String
hi def link debprefsPriority	Comment
hi def link debprefsInvalid	Error
hi def link debprefsDist	Type
hi def link debprefsXDist	WarningMsg

let b:current_syntax = "debprefs"
