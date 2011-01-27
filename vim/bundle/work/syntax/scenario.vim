if version < 600
        syntax clear
elseif exists ("b:current_syntax")
        finish
endif

" Comments -- TODO: not sure what a scenario file comment really is
syn match Comment /!.*$/
syn region Comment start=/\/\*/ end=/\*\//


" Keywords
syn match declKeyword /\#\(BEGINSCENARIO\|ENDSCENARIO\|BEGINDOC\|REQUIRED_XOPTS\|FEATURE\|NAME\|REFERENCE\|CREATOR\|DATE\|TEST_TYPE\|ENDDOC\|BEGINENV\|BEGINDEFS\|ENDDEFS\|ENDDEFS\|ENDENV\|BEGINCONTROL\|ENDCONTROL\)\>/
syn match structuralKeyword /\#\(IF\|ENDIF\|ELSE IF\|ELSE\)\>/
syn match actionKeyword /\#\(CMD\|ENDCMD\|RESOURCES_REQ\)\>/
syn match argumentKeyword /\#\(INPUT\|OPTS\|OUTPUT\|STDERR\|STDOUT\|VALIDRCS\)\>/

hi link declKeyword Type
hi link structuralKeyword Conditional
hi link actionKeyword Function
hi link argumentKeyword number

