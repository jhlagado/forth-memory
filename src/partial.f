: partial          ( n1 xt "name" -- )
    create , ,
    does> 
    cell+           \ addr1 
    dup @ swap      \ n1 addr1
    cell - @        \ n1 xt
    execute 
;

5 ' + partial add5
t{ 2 add5 -> 7 }t
t{ ' add5 >body @ -> ' + }t
t{ ' add5 >body cell+ @ -> 5 }t

4 ' add5 partial add5to4
t{ add5to4 -> 9 }t
t{ ' add5to4 >body @ -> ' add5 }t
t{ ' add5to4 >body cell+ @ -> 4 }t

3 ' noop partial p1 
2 ' p1 partial p2
1 ' p2 partial p3

t{ 2 p1 -> 2 3 }t
t{ 1 p2 -> 1 2 3 }t
t{ 0 p3 -> 0 1 2 3 }t

3 ' rot partial p10 
2 ' p10 partial p11
t{ 1 p11 -> 2 3 1 }t

0 value -pt-before
0 value -pt-after

align
here to -pt-before 
100 ' noop partial -pt
here to -pt-after 
-pt-after -pt-before - constant -pt-size
' -pt -pt-before - constant -pt-offset

( -- xt )
: -pt-clone
    align here >r                       \ save start of allocation
    -pt-size allot
    -pt-before r@ -pt-size cmove
    r> -pt-offset +
;

( val xt -- xt1 )
: partial>
    -pt-clone dup >r                         \ val xt xt1
    >body swap over                         \ val body xt body
    ! cell+                                 \ val body+1
    ! r>                                    \ xt1
;

( args... len xt )
: curry 0 do partial> loop ; 

defer add3
3 ' + partial> is add3                 
t{ 2 add3 -> 5 }t
t{ ' add3 defer@ >body cell+ @ -> 3 }t

1 2 3 ' noop partial> partial> partial> constant pp  
t{ pp execute -> 1 2 3 }t

: c3 ['] noop 3 curry ;
t{ 1 2 3  c3 execute .s -> 1 2 3 }t
