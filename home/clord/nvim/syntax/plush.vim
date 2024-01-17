" Vim syntax file for plush
" Language:     Plush (oto)
" Maintainer:   Christopher Lord <christopher@pliosoft.com>
" Last Change:  2023-05-26

" Quit when a syntax file was already loaded
if exists("b:current_syntax")
    finish
endif

" clear any old syntax stuff hanging around
syntax clear


syntax keyword plushStdlibFuncs def format_comment_text camelize_down contained

" Set the default syntax region to a string
syntax region plushString start=/^/ end=/$/ keepend contains=plushDelimiters,plushKeywords

" Define the plush template syntax
syntax region plushDelimiters start=/<%/ end=/%>/ contained contains=plushKeywords,plushStdlibFuncs

" Define the plush keywords
syntax keyword plushKeywords for in type if else return contained

" Define the punctuation
syntax match plushPunctuation "[{}():=]" contained

" Link the highlight groups to the default groups
highlight default link plushString String
" "highlight default link plushDelimiters Special
highlight default link plushKeywords Keyword
highlight default link plushPunctuation Punctuation
highlight default link plushStdlibFuncs Function

let b:current_syntax = "plush"

