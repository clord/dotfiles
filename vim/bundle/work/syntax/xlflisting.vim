if !exists("main_syntax")
   if version < 600
      syntax clear
   elseif exists ("b:current_syntax")
      finish
   endif
   let main_syntax='xlflisting'
endif

syn include @wcodeSyntax syntax/wcode.vim
unlet b:current_syntax
syn region wcode start="<<<wcode>>>" keepend end="<<</wcode>>>"me=s-1 contains=@wcodeSyntax

syn include @fortranSyntax syntax/fortran.vim
unlet b:current_syntax
syn region f77 start="<<<\f77>>>" keepend end="<<</\f77>>>"me=s-1 contains=@fortranSyntax

if main_syntax == "xlflisting"
  syn sync match listingf77Highlight grouphere f77 "<<<\f77>>>"
  syn sync match listingf77Highlight groupthere NONE  "<<</\f77>>>"
  syn sync match listingwcodeHighlight grouphere wcode "<<<wcode>>>"
  syn sync match listingwcodeHighlight groupthere NONE  "<<</wcode>>>"
endif


let b:current_syntax = "xlflisting"

if main_syntax == 'xlflisting'
   unlet main_syntax
endif

