\ coroutines - adapted from amforth 6.1 examples/co.frt
\ https://home.hccnet.nl/a.w.m.van.der.horst/forthlecture6.html

: yield r> r> swap >r >r ;

: iter-next r> r> swap >r >r ;

: iter-done r> drop r> drop ;

variable producer-var
variable producer-var2

: producer-yield                \           r2 r1  
r> dup . cr dup producer-var !  \ r1        r2
r>                              \ r1 r2
swap                            \ r2 r1
>r                              \ r2        r1
>r                              \           r1 r2 
;

: producer begin 100 + dup producer-yield again ;

: producer-next r> producer-var @ swap >r >r ;

: consumer 
  0 producer

  r> producer-var !
  producer-var ? cr cr

  begin dup . 1000 < while 
  
  producer-next 
  r> dup . cr drop

  repeat drop
  ." done! "
  iter-done 
;

: run cr consumer ." done co! " ;

run
cr .s
