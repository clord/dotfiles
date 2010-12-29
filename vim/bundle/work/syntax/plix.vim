if version < 600
        syntax clear
elseif exists ("b:current_syntax")
        finish
endif

" plix is case insensitive
syn case ignore

" Comments
syn match Comment /!.*$/
syn region Comment start=/\/\*/ end=/\*\//

" Strings and literals
syn region literalSingleString start=+'+ end=+'+ skip=+''+
syn region literalDoubleString start=+"+ end=+"+ skip=+""+
syn keyword literalKeyword true false

" Literal numbers
syn match	pNumbers	display transparent "\<\d\|\.\d" contains=pNumber,pFloat,pOctalError,pOctal
syn match	pNumber		display contained "\d\+\(u\=l\{0,2}\|ll\=u\)\>"
"hex number
syn match	pNumber		display contained "0x\x\+\(u\=l\{0,2}\|ll\=u\)\>"
" Flag the first zero of an octal number as something special
syn match	pOctal		display contained "0\o\+\(u\=l\{0,2}\|ll\=u\)\>" contains=pOctalZero
syn match	pOctalZero	display contained "\<0"
syn match	pFloat		display contained "\d\+f"
"floating point number, with dot, optional exponent
syn match	pFloat		display contained "\d\+\.\d*\(e[-+]\=\d\+\)\=[fl]\="
"floating point number, starting with a dot, optional exponent
syn match	pFloat		display contained "\.\d\+\(e[-+]\=\d\+\)\=[fl]\=\>"
"floating point number, without dot, with exponent
syn match	pFloat		display contained "\d\+e[-+]\=\d\+[fl]\=\>"

" flag an octal number with wrong digits
syn match	pOctalError	display contained "0\o*[89]\d*"

" Keywords
syn keyword datatypeNameKeyword integer bit 
syn keyword declKeyword dcl declare
syn keyword structuralKeyword do if else then while repeat end return select when otherwise call

hi link pNumber number 
hi link datatypeNameKeyword keyword
hi link declKeyword keyword
hi link literalDoubleString string
hi link literalSingleString string
hi link literalKeyword constant
hi link structuralKeyword keyword

