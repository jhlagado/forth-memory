\ coroutines - adapted from amforth 6.1 examples/co.frt
\ https://home.hccnet.nl/a.w.m.van.der.horst/forthlecture6.html

: yield r> r> swap >r >r ;

: iter-next r> r> swap >r >r ;

: iter-done 
  r> drop
  r> drop 
;

: producer ( n -- n' n' ) begin 100 + dup yield again ;

: consumer 
  0 producer 
  begin dup . 1000 < while iter-next repeat drop
  ." done! "
  iter-done 
;

: run cr consumer ." done co! " ;

run
cr .s
