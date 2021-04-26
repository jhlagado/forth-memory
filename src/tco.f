\ coroutines - adapted from amforth 6.1 examples/co.frt
\ https://home.hccnet.nl/a.w.m.van.der.horst/forthlecture6.html

: yield r> r> swap >r >r ;

: iter-next r> r> swap >r >r ;

: iter-done r> drop r> drop ;

variable producer-var
variable producer-var2

: producer-yield r> dup producer-var2 @ ! r> swap >r >r ;

: producer begin 100 + dup producer-yield again ;

: producer-next r> producer-var2 @ @ swap >r >r ;

: consumer 
  producer-var producer-var2 ! 

  0 producer

  r> producer-var2 @ !
  
  begin dup . cr 1000 < while producer-next r> drop repeat drop

  ." done! "
  iter-done 
;

: run cr consumer ." done co! " ;

run
cr .s
