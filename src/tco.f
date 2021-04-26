\ coroutines - adapted from amforth 6.1 examples/co.frt
\ https://home.hccnet.nl/a.w.m.van.der.horst/forthlecture6.html

: yield r> r> swap >r >r ;

: iter-next r> r> swap >r >r ;

: iter-done r> drop r> drop ;

variable producer-var
variable producer-var2

: producer-yield ." pyield " .s cr r> dup producer-var ! r> swap >r >r ;

: producer begin ." ploop " .s cr  100 + dup producer-yield again ;

: producer-next ." pnext " .s cr  r> producer-var @ swap >r >r ;

: consumer 
  producer-var  

  0 producer

  r> producer-var !
  
  begin ." cloop " .s cr dup . 1000 < while producer-next r> drop repeat drop

  drop
  ." done! "
  iter-done 
;

: run cr consumer ." done co! " ;

run
cr .s
