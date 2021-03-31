\ block is a ptr follow by a length in bytes 
\ range is a start ptr and end ptr
\ args is a group of items on the stack n1 n2 ... len

: partial           ( n xt -- )
    create , , 
    does> 
    dup cell+ @     \ addr n
    swap @          \ n xt
    execute 
;

: partial1          ( n1 xt -- )
    create , ,
    does> 
    cell+           \ addr1 
    dup @ swap      \ n1 addr1
    cell - @        \ n1 xt
    execute 
;

: partial2          ( n1 n2 xt -- )
    create , , ,
    does> 
    2 cells +       \ addr2 
    dup @ swap      \ n1 addr2
    cell -          \ n1 addr1
    dup @ swap      \ n1 n2 addr1
    cell - @        \ n1 n2 xt
    execute 
;

\ : partialx          ( args xt -- )
\     create
\     ,                                   \ write xt 
\     dup ,                               \ write len
\     0 do , loop                         \ write each arg
\     does>                               \ addr
\     dup @ >r                            \ save xt   
\     cell+ dup @                         \ addr1 len
\     swap                                \ len addr1   
\     cell+ swap                          \ addr2 len
\     range                               \ addr1 addr2 
\     cell - do                           \ loop from addr2-1 to addr1
\         i @                             \ read 
\     cell negate +loop                   \ endloop step = -cell
\     r> execute                          \ restore and exec xt
\ ;

5 ' + partial1 add5
t{ 2 add5 -> 7 }t

4 ' add5 partial1 add5to4
t{ add5to4 -> 9 }t

1 2 ' rot partial2 swap-deep0 
t{ 3 swap-deep0 -> 1 2 3 }t

\ 10 1 ' + partialx add10 
\ t{ 1 add10 -> 11 }t

\ 1 2 2 ' rot partialx swap-deep 
\ t{ 3 swap-deep -> 1 2 3 }t
