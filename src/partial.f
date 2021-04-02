: partial1          ( n1 xt "name" -- )
    create , ,
    does> 
    cell+           \ addr1 
    dup @ swap      \ n1 addr1
    cell - @        \ n1 xt
    execute 
;

: partial2          ( n1 n2 xt "name" -- )
    create , , ,
    does> 
    2 cells +       \ addr2 
    dup @ swap      \ n1 addr2
    cell -          \ n1 addr1
    dup @ swap      \ n1 n2 addr1
    cell - @        \ n1 n2 xt
    execute 
;

5 ' + partial1 add5
t{ 2 add5 -> 7 }t

4 ' add5 partial1 add5to4
t{ add5to4 -> 9 }t

1 2 ' rot partial2 swap-deep0 
t{ 3 swap-deep0 -> 1 2 3 }t
