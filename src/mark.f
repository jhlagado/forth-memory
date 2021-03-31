: range ( adr len -- adr1 adr2 )       \ convert adr len to address range
    cells over +
;

: >array ( n1 n2 ... adr size -- )      \ stack items to array                  
  range
  cell - 
  do i ! cell negate +loop              \ count down
;  

depth value mark-depth

: _[  ( -- )                            \ mark where the stack 
  mark-depth                            \ push current mark-depth
  depth to mark-depth
;

: ]_                                    \ defines an array 
  depth mark-depth -                    \ len
  create
  dup ,                                 \ write len
  0 do , loop                           \ write len x args
  to mark-depth                         \ restore mark-depth

  does> ( idx addr -- adr )             \ adr
  2dup @                                \ idx adr idx len
  U< 0= ABORT" Range error "  
  swap over @                           \ adr idx len
  swap -                                \ adr len-idx
  cells + @                             \ value
;

.s cr
_[ 1 2 3 ]_ arr
t{ 0 arr -> 1 }t
2 arr .s cr
