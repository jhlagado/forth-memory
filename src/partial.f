: partial          ( n1 xt "name" -- )
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

5 ' + partial add5
t{ 2 add5 -> 7 }t

4 ' add5 partial add5to4
t{ add5to4 -> 9 }t

3 ' nop partial p1 
2 ' p1 partial p2
1 ' p2 partial p3

t{ 2 p1 -> 2 3 }t
t{ 1 p2 -> 1 2 3 }t
t{ 0 p3 -> 0 1 2 3 }t

1 2 ' rot partial2 p20 
t{ 3 p20 -> 1 2 3 }t

