\ a slab is a list of slab caches
\ a slab can only store itesm of a given size
\ variables:;
\   slab-item-size
\   slab-cache-size
\ when a cache is filled a new cache is created
\ each cache has a free-list and a free-lkist size variable.
\ a new allocation should prefer to use a nearly full cache

\ depends on tuple4
\ this slab is for dynamically allocating tuple4 objects

4 constant TUPLE4-SIZE
TUPLE4-SIZE cells constant TUPLE4-CELLS


0 constant NULL

0 value slab-start
0 value slab-end
0 value slab-ptr
0 value free-ptr

\ allot a new slab and_init ptrs        ( size -- ) 
: slab-init                             \ size is number of tuples
  TUPLE4-SIZE * new[]                   \ array capacity * tuple4 size
  dup to slab-start                     \ adr  
  to slab-ptr                           \ slab ptr to start
  here to slab-end
  NULL to free-ptr
;

\ checks if slab has free space         \ ( -- flag) 
: slab-isfull
  free-ptr if                       
    false                               \ free list is not empty
  else
    slab-end slab-ptr <=                \ check if room left on slab
  then
;

\ allocate a tuple4 from slab            ( n1 n2 n3 n4 -- adr )
: slab-new                          
  slab-isfull 
    abort" Out of slab space"
  free-ptr if                           \ if free list is not empty
    free-ptr dup                        \ free-ptr free-ptr
    [last] @ to free-ptr                \ free-ptr[last] -> free-ptr 
  else
    slab-ptr dup                       \ slab-ptr slab-ptr
    TUPLE4-CELLS +                      \ slab-ptr slab-ptr+tuple4
    to slab-ptr                        \ -> slab-ptr
  then
  tuple4
;

\ free tuple4, add to free list          ( adr -- )
: slab-free                          
  dup                                   \ adr adr
  free-ptr swap [last] !                \ adr  //  free-ptr -> adr[last]
  to free-ptr                           \  //  adr -> free-ptr
;

\ detect a heap ptr
: slab-is-ptr                          \ adr -- bool
    dup slab-start >=                  \ adr bool
    over slab-end <=                   \ adr bool bool
    and                                 \ adr bool
    swap 15 and                         \ bool bool                  // mask bottom 4 bits
    and                                 \ bool
;

0  value t1
0  value t2
0  value t3
0  value t4
: test-slab 
  cr cr ." test slab" cr
  2 slab-init 
  slab-end slab-start - 2 TUPLE4-CELLS * 100 assert

  slab-isfull false 100 assert

  0 0 0 0 slab-new to t1
  slab-ptr slab-start - TUPLE4-CELLS 100 assert

  slab-isfull false 100 assert

  0 0 0 0 slab-new to t2
  slab-isfull true 100 assert

  t1 slab-free
  slab-isfull false 100 assert

  0 0 0 0 slab-new to t3
  slab-isfull true 100 assert

  t1 t3 = true 100 assert

  t2 slab-free
  slab-isfull false 100 assert

  0 0 0 0 slab-new to t4
  slab-isfull true 100 assert

  t2 t4 = true 100 assert
  cr .s cr

;

