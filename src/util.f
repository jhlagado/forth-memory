: nop ;

( adr len -- adr1 adr2 )
: range                                 \ convert adr len to address range
    cells over +
;
