( adr len -- adr1 adr2 )
: range                                 \ convert adr len to address range
    cells over +
;

0 cells constant ARGS
1 cells constant VARS
2 cells constant SOURCE
3 cells constant SINK
