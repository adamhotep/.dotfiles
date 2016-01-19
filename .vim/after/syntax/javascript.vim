" Vim syntax file
" Lanuage: JavaScript (E4X support w/ nested code, regex m flag support)
" Maintainer: Adam Katz <scriptsATkhopiscom>
" Website: http://khopis.com/scripts
" Latest Revision: 2009-10-05
" Version: 0.3
" Copyright: (c) 2009-2010 by Adam Katz
" License: Same as vim v7

" Save this file to ~/.vim/after/syntax/javascript.vim and you're good to go.

" Nesting other syntax inside CDATA is awesome.  We key on the bounding tag,
" e.g. <html><![CDATA[ This part is <b>formatted as HTML</b> ]]></html>

" TODO: regions are a bit off, me=s-1 is as close as i can get at the moment.

syn match javaScriptE4xTag +<[^>]*><![[]CDATA[[]+ containedin=htmlE4X,cssE4X
syn match javaScriptE4xTag +[]][]]></[^>]*>+ containedin=htmlE4X,cssE4X
syn match javaScriptCdata "<![[]CDATA[[]" containedin=javaScriptE4xTag
syn match javaScriptCdata "[]][]]>" containedin=javaScriptE4xTag

" general E4X
if exists("javaScript_fold")
  syn region plainE4X start="<\z([^>]*\)><![[]CDATA[[]" end="[]][]]></\z1>"me=s-1 fold
else
  syn region plainE4X start="<\z([^>]*\)><![[]CDATA[[]" end="[]][]]></\z1>"me=s-1
endif

" E4X containing Cascading Style Sheets (CSS)
"if exists("java_css")
if !exists("nest_css")
  let nest_css = 1
  syn include @htmlCss syntax/css.vim
  unlet b:current_syntax
  if exists("javaScript_fold")
    syn region cssE4X start="<\z(style\|css\)><![[]CDATA[[]" end="[]][]]></\z1>"me=s-1 fold contains=@htmlCss
  else
    syn region cssE4X start="<\z(style\|css\)><![[]CDATA[[]" end="[]][]]></\z1>"me=s-1 contains=@htmlCss
  endif
endif

" E4X containing JavaScript
" doesnt' work, arguably shouldn't be here
"if !exists("nest_js")
"  let nest_js = 1
"  syn include @htmlJavaScript syntax/javascript.vim
"  unlet b:current_syntax
"  if exists("javaScript_fold")
"    syn region javaScriptE4X start="<\z(script\)><![[]CDATA[[]" end="[]][]]></\z1>"me=s-1 fold contains=@htmlJavaScript
"    syn region javaScriptE4X start="<\z(javascript\)><![[]CDATA[[]" end="[]][]]></\z1>"me=s-1 fold contains=@htmlJavaScript
"  else
"    syn region javaScriptE4X start="<\z(script\)><![[]CDATA[[]" end="[]][]]></\z1>"me=s-1 contains=@htmlJavaScript
"    syn region javaScriptE4X start="<\z(javascript\)><![[]CDATA[[]" end="[]][]]></\z1>"me=s-1 contains=@htmlJavaScript
"  endif
"endif

" E4X containing HTML (last as it might trigger the above via its js and/or css)
if !exists("nest_html")
  "if !exists("java_html")
    let nest_html = 1
    syn include @javaScriptHtml syntax/html.vim
    unlet b:current_syntax
    if exists("javaScript_fold")
      syn region htmlE4X start="<\z(x\?html\w*\)><![[]CDATA[[]" end="[]][]]></\z1>"me=s-1 fold contains=@javaScriptHtml
    else
      syn region htmlE4X start="<\z(x\?html\w*\)><![[]CDATA[[]" end="[]][]]></\z1>"me=s-1 contains=@javaScriptHtml
    endif
  "endif
endif

" NOTE: this adds /m and /y.  /y is a nonstandard flag introduced in Firefox 3.
" https://developer.mozilla.org/en/Core_JavaScript_1.5_Reference/Global_Objects/RegExp#Parameters
syn region  javaScriptRegexpString     start=+/[^/*]+me=e-1 skip=+\\\\\|\\/+ end=+/[gimy]\{0,4\}\s*$+ end=+/[gimy]\{0,4\}\s*[;.,)\]}]+me=e-1 oneline

if version < 508
  command -nargs=+ E4xHiLink hi! link <args>
else
  command -nargs=+ E4xHiLink hi! def link <args>
endif

E4xHiLink plainE4X		String
E4xHiLink htmlE4X		String
E4xHiLink cssE4X		String
E4xHiLink javaScriptE4xTag 	Operator
E4xHiLink javaScriptCdata 	Comment
E4xHiLink htmlCssDefinition	Special

delcommand E4xHiLink
