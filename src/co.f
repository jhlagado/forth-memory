\ coroutines - adapted from amforth 6.1 examples/co.frt
\ https://home.hccnet.nl/a.w.m.van.der.horst/forthlecture6.html

: co 2r> swap 2>r ;

: end-co 
  r> drop
  r> drop 
;

: tokyo
    cr ." Here Tokyo over" 100 co 
    cr ." What gives? over" co
    cr ." Yes, more? over" co
    cr ." over and out" 
;

: amsterdam
    tokyo
    cr ." here Amsterdam over" . co 
    cr ." has it arrived over" co
    cr ." no. over" 
;

: producer ( n -- n' n' ) begin 100 + dup co again ;

: consumer 
  0 producer 
  begin dup . 1000 < while co repeat drop
  ." done! "
  end-co 
;

: run consumer ." done co! " ;

run
cr .s
