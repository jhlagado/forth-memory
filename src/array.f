\ "args len" is a group of items on the stack n1 n2 ... followed by len

depth value mark-depth

: range ( adr len -- adr1 adr2 )        \ convert adr len to address range
    cells over +
;

: >array ( args len adr size -- )       \ copies stack items to array                  
  range
  cell - 
  do i ! cell negate +loop              \ count down
;  

( adr size -- n1 n2... )
: array>                                \ copies array to stack                  
  range
  swap do i @ cell +loop 
;    

( idx adr -- val ) 
: nth                                   \ returns nth item of array
  2dup @                                \ idx adr idx len
  U< 0= ABORT" Range error "  
  cell+ swap cells                      \ adr1 offset
  + @                                   \ value
;

( args len -- adr)
: new-array                             \ allocates new array from args                   
  here dup >r                           \ args len adr
  cell+ swap                            \ args adr1 len
  dup ,                                 \ write len
  dup cells allot                       \ args adr1 len 
  >array                                \ write args
  r>                                    \ adr
;

( -- )
: _[                                    \ starts literal array definition 
  mark-depth                            \ push current mark-depth
  depth to mark-depth
;

( -- adr )
: ]_                                    \ completes literal array definition 
  depth mark-depth -                    \ mark args len
  new-array                             \ mark adr
  swap                                  \ adr mark
  to mark-depth                         \ restore mark-depth
                                        \ adr
;

_[ 1 2 3 ]_ constant arr

t{ 0 arr nth -> 1 }t
t{ 2 arr nth -> 3 }t
