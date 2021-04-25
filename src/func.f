( quotations )

:noname ; @ constant cfa-value

: head          align here 0 >body allot cfa-value over ! ;
: [:            postpone ahead head ; immediate
: ;]            >r postpone exit postpone then r> postpone literal ; immediate

( functional )

: map           expand do ;


