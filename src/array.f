
: array> ( adr size -- n1 n2 ...)       \ array to stack items                  
  range
  swap do i @ cell +loop 
;    

: array                                 ( args -- )
    create
    dup ,                               \ write len
    0 do , loop                         \ write each arg
    does>                               \ addr
    cell+ dup @                         \ addr1 len
    swap                                \ len addr1   
    cell+ swap                          \ addr2 len
    range                               \ addr1 addr2 
    cell - do                           \ loop from addr2-1 to addr1
        i @                             \ read 
    cell negate +loop                   \ endloop step = -cell
;
