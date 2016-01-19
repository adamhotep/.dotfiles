" Vim syntax file
" Lanuage: JavaScript (multiline strings w/ alt syn, regex m flag)
" Maintainer: Adam Katz <scriptsATkhopiscom>
" Website: http://khopis.com/scripts
" Latest Revision: 2016-01-17
" Version: 0.5
" Copyright: (c) 2009+ by Adam Katz
" License: Same as vim v7

" Save this file to ~/.vim/after/syntax/javascript.vim and you're good to go.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" NST is NoSubstitutionTemplate, part of the ECMAScript 6 draft (late 2014),
" supported by Firefox 34+, Chrome 41+, Safari 9+, etc.  You can use it for
" multi-line strings.  Merely use back-ticks rather than quotes.
"
" I've also created a system by which you can place a comment before the
" opening back-tick to signify a different syntax highlighting scheme.
" Currently, html and css are the only ones that are supported.
" The formatting should look like this:
"     /* syn=css */ ` stuff `
" and it can be used inline, e.g.
"     ex1.innerHTML = /* syn=html */ `<p>foo <a href="bar">baz</a></p>`;
"     ex2 = /* syn=css */ `b { color:red; }`;
"     ex3 = document.querySelector( /* syn=css */ `a[href*="example.com/"]` );
"
" E4X is: https://en.wikipedia.org/wiki/ECMAScript_for_XML
" E4X used to have support in Firefox but (sadly) no longer does.
" In that era, E4X allowed multi-line strings via XML tags, which
" were a convenient way to cue an alternate syntax highlighting:
"     <html><![CDATA[ This is <b>formatted as HTML</b> ]]></html>
" Due to the lack of broad support, I've disabled E4X alt syntax
" and changed the highlighting to ERROR (red). -adam 20150314
"
" BUG: E4X regions are a bit off, me=s-1 isn't quite close enough
" BUG: Nested syntax seems to be broken now... (20150314)
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" NOTE: this adds /m and /y.  /y is a nonstandard flag introduced in Firefox 3.
" https://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/RegExp#Parameters
syn region  javaScriptRegexpString     start=+/[^/*]+me=e-1 skip=+\\\\\|\\/+ end=+/[gimy]\{0,4\}\s*$+ end=+/[gimy]\{0,4\}\s*[;.,)\]}]+me=e-1 oneline

syn match javaScriptE4xTag +<[^>]*><![[]CDATA[[]+ containedin=htmlE4X,cssE4X
syn match javaScriptE4xTag +[]][]]></[^>]*>+ containedin=htmlE4X,cssE4X
syn match javaScriptCdata "<![[]CDATA[[]" containedin=javaScriptE4xTag
syn match javaScriptCdata "[]][]]>" containedin=javaScriptE4xTag

" general NoSubstitutionTemplate (exclude when internal syn=js or syn=javascript)
if exists("javaScript_fold")
  syn region NSTplain start="\%(/\*\s*syn=\%(javascript\|js\)\s*\*/\s*\)\@<!`" end="`" fold
else
  syn region NSTplain start="\%(/\*\s*syn=\%(javascript\|js\)\s*\*/\s*\)\@<!`" end="`"
endif

" general E4Xplain
if exists("javaScript_fold")
  syn region E4Xplain start="<\z([^>]*\)><![[]CDATA[[]" end="[]][]]></\z1>"me=s-1 fold
else
  syn region E4Xplain start="<\z([^>]*\)><![[]CDATA[[]" end="[]][]]></\z1>"me=s-1
endif

" NST containing Cascading Style Sheets (CSS)
"if exists("java_css")
if !exists("nest_css")
  let nest_css = 1
  if !empty(b:current_syntax)
    unlet b:current_syntax
  endif
  syn include @htmlCss syntax/css.vim
  syn match NSTcssCue "\/\*\s*syn\s*[=:]\s*\%(style\%(sheet\)\?\|css\)\s*\*\/" nextgroup=NSTcss contains=javaScriptComment skipwhite
  if exists("javaScript_fold")
    syn region NSTcss matchgroup=NSTcssSyn start="`" end="`" fold contains=@htmlCss contained
  else
    syn region NSTcss matchgroup=NSTcssSyn start="`" end="`" contains=@htmlCss contained
  endif
endif
"endif

" NST containing HTML (last as it might trigger the above via its js and/or css)
if !exists("nest_html")
  "if !exists("java_html")
    let nest_html = 1
    if !empty(b:current_syntax)
      unlet b:current_syntax
    endif
    syn include @javaScriptHTML syntax/html.vim
    syn match NSThtmlCue "\/\*\s*syn\s*[=:]\s*x\?html\s*\*\/" nextgroup=NSThtml contains=javaScriptComment skipwhite
    if exists("javaScript_fold")
      syn region NSThtml matchgroup=NSThtmlSyn start="`" end="`" fold contains=@javaScriptHTML contained
    else
      syn region NSThtml matchgroup=NSThtmlSyn start="`" end="`" contains=@javaScriptHTML contained
    endif
  "endif
endif

if version < 508
  command -nargs=+ NstHiLink hi! link <args>
else
  command -nargs=+ NstHiLink hi! def link <args>
endif

NstHiLink htmlE4X		String
NstHiLink cssE4X		String
NstHiLink E4Xplain		String
NstHiLink NSTplain		String
NstHiLink NSTcss		String
NstHiLink NSTcssSyn		String
NstHiLink NSThtml		String
NstHiLink NSThtmlSyn		String
NstHiLink javaScriptE4xTag 	Operator
NstHiLink javaScriptCdata 	Comment
NstHiLink htmlCssDefinition	Special

delcommand NstHiLink
