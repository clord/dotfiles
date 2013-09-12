
if !exists("main_syntax")
if version < 600
        syntax clear
elseif exists ("b:current_syntax")
        finish
endif
let main_syntax="vim"
endif

" Comments
syn match Comment /#.*$/


" special section headers
syn match terminal         /\<\([A-Z0-9_]*\)\>/ contained
syn match noperator         /\(;\|[?:]=\|<\||\|>\)/ contained

" Instruction lines
syn region grammar_rule start=/^\([a-zA-Z0-9_]\+\)/ end=";" contains=terminal,noperator,Comment



hi terminal ctermfg=DarkGreen
hi noperator ctermfg=DarkRed

let b:current_syntax = "ll"
if main_syntax == 'll'
   unlet main_syntax
endif


