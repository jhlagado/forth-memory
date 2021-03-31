: partial           ( n xt -- )
    create , , 
    does> 
    dup cell+ @ swap @ 
    execute 
;

5 ' + partial add5
t{ 2 add5 -> 7 }t

4 ' add5 partial add5to4
t{ add5to4 -> 9 }t

: partialx          ( n1... len xt -- )
    create
    ,                                   \ 
    dup ,  
    0 do , loop
    does> 
    dup @ >r cell+ 
    dup cell+ swap    
    @ range cell - 
    do i @ cell negate +loop
    r> execute
;

10 1 ' + partialx add10 
t{ 1 add10 -> 11 }t
