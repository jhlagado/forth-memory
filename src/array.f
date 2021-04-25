\ "args len" is a group of items on the stack n1 n2 ... followed by len

depth value mark-depth

( args adr size -- )                    \ copies stack items to array                  
: >array            range cell - do i ! cell negate +loop ;  

( adr size -- n1 n2... )                \ copies array to stack                  
: array>            range swap do i @ cell +loop ;    

( idx adr -- val )                      \ returns nth item of array
: nth               2dup @ U< 0= ABORT" range error "  
                    cell+ swap cells + @ ;

( allot array  )

: write-len         dup , ;
: allot-cells       dup cells allot ;
: fill-cells        here swap >array ;
: allot-array       here >r write-len allot-cells fill-cells r> ;                                   
  
( create array ) 

: create-array      create allot-array drop does> dup dup @ array> ;


( args len -- adr)
: allot-array2                          \ allocates new array from args                   
  here dup >r                           \ args len adr
  cell+ swap                            \ args adr1 len
  dup ,                                 \ write len
  dup cells allot                       \ args adr1 len 
  >array                                \ write args
  r>                                    \ adr
;

( args len -- adr)
: alloc-array                             \ allocates new array from args                   
  dup dup 1 + cells                     \ args len len bytes
  allocate                              \ args len len adr err
  0<> ABORT" memory allocation error "  \ args len len adr
  swap over !                                     \ args len adr (store len) 
  dup >r cell+ swap                     \ args adr+1 len
  >array
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
  alloc-array                          \ mark adr
  swap to mark-depth                    \ restore mark-depth
;

_[ 1 2 3 ]_ constant arr

t{ 0 arr nth -> 1 }t
t{ 2 arr nth -> 3 }t
