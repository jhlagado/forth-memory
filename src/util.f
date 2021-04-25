( adr len -- adr1 adr2 )
: range                                 \ convert adr len to address range
    cells over +
;

0 cells constant ARGS
1 cells constant VARS
2 cells constant SOURCE
3 cells constant SINK


: [:    POSTPONE AHEAD :noname ; IMMEDIATE COMPILE-ONLY
: ;]    POSTPONE ; POSTPONE THEN LATESTXT POSTPONE LITERAL ; IMMEDIATE COMPILE-ONLY

0 >body constant BODY-OFFSET
:noname ; @ constant CFA-VALUE
variable cfa-addr

: local-exit    postpone ;s ; immediate
: [:            postpone ahead align HERE dup cfa-addr ! BODY-OFFSET allot CFA-VALUE swap ! ; immediate
: ;]            postpone local-exit postpone then cfa-addr @ postpone literal ; immediate

: [: postpone ahead :noname ; immediate

: ;] postpone ; postpone then ; immediate

:noname ; @ constant CFA-VALUE
: [:            postpone ahead align HERE >r 0 >body allot CFA-VALUE r@ ! r> ; immediate
: ;]            >r postpone exit postpone then r> postpone literal ; immediate
