if !exists("main_syntax")
if version < 600
        syntax clear
elseif exists ("b:current_syntax")
        finish
endif
let main_syntax="wcode"
endif
" Comments
syn match ErrorComment /\/\/>>>.*$/
syn match Comment /\/\/[^>].*$/
syn region Comment start=/\/\*/ end=/\*\//

" Strings and literals
syn region literalSingleString start=+'+ end=+'+ skip=+''+
syn region literalDoubleString start=+"+ end=+"+ skip=+""+



" special section headers
syn match StreamHeader /^\s*@stream\s*\([^>]*\)\s*;\s*$/

syn match expressionInstruction /\<\(ADDA\?\|MPY\|\(AND\|OR\)I\|EQU\|NEQ\|SUB\|CONV\|DIV\|IXA\|IND\|SWP\|DUP\|OVER\|POP\|PUSH\|NEG\)\>/
syn match memoryInstruction /\<\(LDC\|LOD\|LDA\|INDA\|STO\|STR\|RSTR\|LCA\)\>/
syn match branchInstruction /\<\(FJP\|LAB\|DO\|ENDL\|SWE\|BRK\|CASE\|ENDS\|UJP\)\>/
syn match invocationInstruction /\<\(SECTION\|CUP\|RET\)\>/
syn match headerInstruction /SYM{\w*}\|\(\<\(DATA\|SYM\(A\|B\)\|SYM\|SYMT\|INFO\|LOC\|PSTR\|DIR\|EOF\|ENT\|END\|DEF\|LIT\|SRC\|ENV\|BGN\|PALI\)\>\)/
syn match argument /\w*=/

" Instruction lines
syn region InstructionBlock start=/^([A-Z]+)/ end=";" contains=invocationInstruction,branchInstruction,headerInstruction,expressionInstruction,memoryInstruction,argument,literalSingleString,literalDoubleString

hi expressionInstruction ctermfg=DarkGreen
hi memoryInstruction ctermfg=Cyan
hi invocationInstruction ctermfg=Red
hi branchInstruction ctermfg=Magenta
hi headerInstruction ctermfg=Yellow
hi StreamHeader ctermfg=Red
hi ErrorComment ctermfg=Red
hi literalDoubleString ctermfg=darkgreen
hi literalSingleString ctermfg=darkgreen

let b:current_syntax = "wcode"
if main_syntax == 'wcode'
   unlet main_syntax
endif


