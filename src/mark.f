sp@ value mark-sp

: _[  ( -- )                            \ mark where the stack 
  sp@ to mark-sp
;

: ]_  ( -- len )                        \ return number of items pushed since mark 
  sp@ mark-sp - abs cell /
;

t{ _[ ]_ -> 0 }t
t{ _[ 1 2 3 ]_ -> 1 2 3 3 }t
