if !exists("main_syntax")
if version < 600
        syntax clear
elseif exists ("b:current_syntax")
        finish
endif
let main_syntax="ins"
endif

" Comments
syn match Comment /\/\/.*$/
syn region Comment start=/\/\*/ end=/\*\//
syn region nestComment start=/\/\// end=/$/ contained

syn match instruction  /\<\(B\?U[A-Z0-9]\+\)\>/ contained

" Strings and literals
syn region literalSingleString start=+'+ end=+'+ skip=+''+
syn region literalDoubleString start=+"+ end=+"+ skip=+""+

syn match slash_newline /\\$/ contained
syn match preptoken    /\<\(define\|if\|else\|ifdef\|endif\)\>/ contained
syn region prepblk start=/\#/ end=/$/ contains=slash_newline,preptoken,instruction

" special section headers
syn match opcode         /\<\([a-zA-Z0-9_]*_opcode\)\>/ contained
syn match class          /\<\([a-zA-Z0-9_]\+_class\)\>/ contained
syn match field          /\<\([a-zA-Z0-9_]\+_field\)\>/ contained
syn match layoutmember   /\<W_Code *:: *\w\+\>/ contained
syn match instrkeywords  /\<\(layout_of\|annotater\|sizeof\|signed\|raw\|set\|value\|unsigned\|offsetof\|value\|decimal\|hex\)\>/ contained

" Instruction lines
syn region instrblk start=/^\([a-zA-Z0-9_]\+\)_opcode/ end=";" contains=opcode,class,field,instrkeywords,instruction,layoutmember,Comment



hi instruction ctermfg=Red
hi opcode ctermfg=DarkGreen
hi class ctermfg=Cyan
hi field ctermfg=Yellow
hi link instrkeywords keyword
hi prepblk ctermfg=DarkGreen
hi preptoken ctermfg=Green
hi layoutmember ctermfg=Blue
hi slash_newline ctermfg=Magenta

let b:current_syntax = "ins"
if main_syntax == 'ins'
   unlet main_syntax
endif


