\ ************************************************************
\ Implementation of quotations for gforth 0.7.3

0 >body constant BODY-OFFSET
:noname ; @ constant CFA-VALUE
variable cfa-addr

\ LOCAL-EXIT is EXIT that keeps locals
: local-exit postpone ;s ; immediate

: [: ( -- )
  \ C: build a block prefix: keep HERE in cfa-addr, compile
  \ in CFA-VALUE
  postpone ahead align HERE dup cfa-addr ! BODY-OFFSET allot
  CFA-VALUE swap ! ; immediate

: ;] ( E: -- xt)
    postpone local-exit postpone then cfa-addr @
    postpone literal ; immediate

\ ************************************************************

\ This is an implementation of quotations and some combinators
\ for use with Forth by Charles Childers. 

\ ************************************************************

\ dip
\ Stack:   value  quote  --  value
\ Executes a quotation with a value being temporarily removed
\ from the stack. The value is restored after the quotation
\ is executed.
\
\ This is similar to a form like:
\
\     >r ... r>
\
\ Where the ... is the code in the quotation.

: dip  swap >r execute r> ;

\ ************************************************************

\ sip
\ Stack:   value  quote  --  value
\ Executes a quotation. A copy of the value is placed back on
\ the stack after the quotation is executed.
\ This is similar to a form like:
\
\     dup >r ... r>
\
\ Where the ... is the code in the quotation.

: sip    over >r execute r> ;

\ bi
\ Stack:   value  quote1  quote2  --  ?
\ Make a copy of the value, and apply quote1. After execution
\ completes, put the value on the stack and execute the second
\ quote.
\
\ E.g.,:
\
\    12  [: 3 * ;]  [: 4 * ;]  bi
\
\ Equates to:
\
\    12 3 * 12 4 *

: bi  ['] sip dip execute ;

\ bi*
\ Stack:   value1  value2  quote1  quote2  --  ?
\ Move value2 and quote2 off the stack, and execute quote1.
\ After this completes, restore value2 and quote2 to the stack
\ and execute quote2.
\
\ E.g.,:
\
\    2  4  [: 3 * ;]  [: 5 * ;]  bi*
\
\ Equates to:
\
\    2 3 * 4 5 *

: bi*  ['] dip dip execute ;

\ bi@
\ Stack:   value1  value2  quote  --  ?
\ Move value2 off the stack and execute quote. Then return
\ value2 to the stack, and execute the quote again.
\
\ E.g.,:
\
\    2  4  [: 3 * ;]  bi@
\
\ Equates to:
\
\    2 3 * 4 3 *

: bi@  dup bi* ;

\ tri
\ Stack:   value  quote1  quote2  quote3  --  ?
\ Execute each quote against a copy of the value.
\
\ E.g.,
\
\    1  [: 2 * ;]  [: 3 * ;]  [: 4 * ;] tri
\
\ Equates to:
\
\    1 2 *  1 3 *  1 4 *

: tri  swap >r ['] sip dip sip r> execute ;

\ ************************************************************

\ tri*
\ Stack:   value1 value2 value3  quote1 quote2 quote3  --  ?
\ Execute quote1 against value1, quote2 against value2, and
\ quote3 against value3.
\
\ E.g.,
\
\    1  2  3  [: 5 * ;]  [: 6 * ;]  [: 7 * ;]  tri*
\
\ Equates to:
\
\    1 5 *  2 6 *  3 7 *
\
\ Thanks to i440r in #forth for helping implement the helper
\ function (tri*) which reshuffles the initial stack of:
\ abcxyz to axbycz.

: (tri*)  swap 2>r -rot r> swap r> ;
: tri*  (tri*) 2>r 2>r execute 2r> execute 2r> execute ;

\ tri@
\ Stack:  value1  value2  value3  quote -- ?
\ Move value2 and value3 off the stack, and execute quote.
\ Then restore value2 and execute the quote again. Finally
\ this restores value3 and executes the quote a final time.
\
\ E.g.,
\
\    1 2 3  [: 6 + ;] tri@
\
\ Equates to:
\
\    1 6 +  2 6 +  3 6 +

: tri@  dup dup tri* ;

\ When these combinators are loaded, the Forth system will
\ behave differently: they replace standard conditionals and
\ add new loop combinations.

\ A helper function

: 0; dup 0= if drop rdrop then ;

\ ifte
\ Stack:   flag  true-quote  false-quote  --
\ Execute true-quote if flag is true, or false-quote if not.
\
\ E.g.,
\
\    true  [: 1 ;]  [: 2 ;]  ifte
\
\ Equates to this in standard Forth:
\
\    true if 1 else 2 then

: ifte  rot if drop execute else nip execute then ;

\ if-true
\ Stack:   flag  quote  --
\ Execute quote if flag is true

: if-true  [: ;] ifte ;

\ if-false
\ Stack:   flag  quote  --
\ Execute quote if flag is false

: if-false  [: ;] swap ifte ;

\ repeat
\ Stack:   count  quote  --
\ Execute quote the specified number of times.

: repeat  swap 0 ?do [: execute ;] sip loop drop ;

\ while-true
\ Stack:   quote  --
\ Execute quote repeatedly until quote returns a flase flag.

: while-true
  [: begin dup dip swap 0; drop again ;] execute drop ;

\ while-false
\ Stack:   quote  --
\ Execute quote repeatedly until quote returns a true flag.

: while-false
  [: begin dup dip swap -1 xor 0; drop again ;] execute drop ;
