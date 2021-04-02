: {{ :noname ; immediate
\ : }} [compile] ; ; immediate
\ : }} postpone ;  ; immediate
: }}  postpone exit ; immediate 


\ t{ 
    \ defer quot
    : x  10 20 30  ;
    x
    \ is quot
    \ quot
    .s
\ -> 
    \ 10 20 30
\ }t

\ : y {{ 2 3 4 }} 
\ ;
\ y

: x 1 2 ' execute 1 + ;
x + .
> 4

x - .
> 0

: y ' :noname execute ;


: x bl word find ;