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

syn match debugInstruction /\<\(TDLOC\|DXP\|DPXP\|XP[BE]\?\|ARRY\|TP\|COND\|RANGE\|FORM\|B\?CLS\|LEVEL\|CMEM\|CMFC\|CTYP\|ECON\|END[PR]\|ENUM\|FPAR\|FRND\|FUNC\|MPTR\|NCON\|PRIM\|PTR\|QUAL\|REC\|REF\|RREF\|RMEM\|SET\|TDEF\|VBP\|VREC\|BB\|EB\|TEST\|UDECL\|ANS\|ENS\|NMEM\|NS\)\>/
syn match subprogramInstruction /\<\(CFP\|CUP\|END\|ENT\|LEX\|PSTR\|RET\|ASM\|RSTR\({\w*}\)\?\|SNEW\)\>/
syn match conditionInstruction /\<\(EQU\|NEQ\|GRT\|GEQ\|LES\|LEQ\|NOT\|CHKO\?\)\>/
syn match flowInstruction /\<\([FUXT]JP\|IJMP\|CMP\|G\?LAB\|SWE\|CASE\|BRK\|ENDS\|DO\|ENDL\|SEL\|CIND\|CSTO\)\>/
syn match expressionInstruction /\<\(S[LR][AL]\|SHF[ALD]\|ADDA\?\|MPY\|\(AND\|X\?OR\|SET\)I\|EQU\|EXPI\?\|NEQ\|INC\|IXA\|DEC\|SUBA\?\|CONV\|ABS\|DIVR\?\|NEG\)\>/
syn match referenceInstruction /\<\(LOD\|IND\|PIND\|LODL\|LDC\|LCA\|LDA\|IXA\|STR\|STO\|PSTO\|FILL\)\>/
syn match dictionaryInstruction /\<\(SYM\({\w*}\)\?\|SYMT\|SYMA\|SYMB\|PALI\|CPIN\|CPOUT\|LIT\|EMAP\|KILL\)\>/
syn match stackInstruction /\<\(DUP\|OVER\|POP\|SWP\|BLK\)\>/
syn match informationalInstruction /\<\(BGN\|DEF\|DIR\|ENV\|EOF\|INFO\|MODE\|LOC\|IMAP\|NOP\|OPTN\|SRC\)\>/


" Instruction lines
syn region InstructionBlock start=/^([A-Z]+)/ end=";" contains=debugInstruction,subprogramInstruction,conditionInstruction,flowInstruction,expressionInstruction,referenceInstruction,dictionaryInstruction,stackInstruction,informationInstruction



hi debugInstruction ctermfg=Yellow guifg=#5f5faf
hi subprogramInstruction ctermfg=Blue guifg=#0087ff
hi conditionInstruction ctermfg=Red
hi flowInstruction ctermfg=Magenta
hi expressionInstruction ctermfg=red guifg=#5f5f00
hi referenceInstruction ctermfg=cyan
hi dictionaryInstruction ctermfg=Magenta guifg=#5f5fff
hi stackInstruction ctermfg=darkred  guifg=#5f0000
hi informationalInstruction ctermfg=DarkGray guifg=#5f5f5f

hi StreamHeader ctermfg=Red
hi ErrorComment ctermfg=Red

hi literalDoubleString ctermfg=34 guifg=#00af00
hi literalSingleString ctermfg=darkgreen

let b:current_syntax = "wcode"
if main_syntax == 'wcode'
   unlet main_syntax
endif


