if !exists("main_syntax")
if version < 600
        syntax clear
elseif exists ("b:current_syntax")
        finish
endif
let main_syntax="bookmaster"
endif

syn case ignore



syn match Comment /\.\*.*$/
syn match Special /\.\w\+/

syn region  endTag             start=+:e+      end=+\.+
syn region  startTag           start=+:[a-dA-DF-Zf-z]\++   end=+\.+
syn region  entity             start=+&+   end=+\.+

hi startTag  ctermfg=Yellow
hi endTag  ctermfg=Green
hi entity  ctermfg=Red



let b:current_syntax = "bookmaster"
if main_syntax == 'bookmaster'
   unlet main_syntax
endif


