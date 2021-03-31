: range ( adr len -- adr1 adr2 )       \ convert adr len to address range
    cells over +
;

: >array ( n1 n2 ... adr size -- )      \ stack items to array                  
  range
  cell - 
  do i ! cell negate +loop              \ count down
;  

: array> ( adr size -- n1 n2 ...)       \ array to stack items                  
  range
  swap do i @ cell +loop 
;    

