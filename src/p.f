export const getInstance = (state: Tuple, sink: Tuple) => {
    const instance = [0, 0, 0, 0] as Tuple;
    tset(instance, ARGS, state[ARGS] as Tuple);
    tset(instance, VARS, state[VARS] as Tuple);
    tset(instance, SOURCE, state[SOURCE] as Tuple);
    tset(instance, SINK, sink);
    return instance;
};

: getInstance ;

export const getTB = (instance: Tuple, cproc: CProc) => {
    const tb = tupleClone(instance, false);
    tb.proc = cproc;
    tb.name = cproc.name;
    return tb;
};

export const closureFactory = (f: CFF) => (cproc: CProc): CProc =>  (state: Tuple) => (mode: Mode, sink: Tuple) => {
    if (mode !== Mode.start) return;
    const instance = getInstance(state, sink);
    const tb = getTB(instance, cproc);
    f(instance, tb, sink);
    return tb;
};

export const fSource = (instance: Tuple, tb: Tuple, sink: Tuple): void => {
    execClosure(sink, Mode.start, tb);
};

: fSource tb Mode.start sink ;

export const closureFactorySource = closureFactory(fSource);


export const argsFactory = (cproc) => (args) => createClosure(elemClone(getArgs(args), true), 0, 0, 0, cproc);


const fromOnceTB = (state: Tuple) => (mode: Mode, d: any) => {
    let taken = state[VARS] as number;
    if (mode === Mode.data && taken < 1) {
        tsetv(state, VARS, taken + 1);
        const constant = state[ARGS] as number;
        const sink = state[SINK] as Tuple;
        execClosure(sink, Mode.data, constant);
    }
    execClosure(sink, Mode.stop);
};

( d mode state -- )
: fromOnceTB0 
    >rot                                \ d mode (r@: state)
    swap drop                           \ mode
    mode case
        Mode.start of
            r@ VARS +                   \ state.vars
            0 swap !                    \ (state.vars = 0) 
        endof
        Mode.data of 
            r@ VARS +                   \ state.vars 
            dup @ =0 if
                1 +!                    \ (state.vars++)
                r@ ARGS + @ swap        \ [state.args] 
                Mode.data               \ [state.args] mode
                r@ SINK + @             \ [state.args] mode [state.sink]
                execute                 \ send
            then                        
        endof
    endcase 
    0                                   
    Mode.stop
    r> SINK + @                         \ 0 Mode.stop [state.sink]
    execute                             \ send
;

( f cproc -- tb )

export const closureFactory = (f: CFF) => (cproc: CProc): CProc =>  (state: Tuple) => (mode: Mode, sink: Tuple) => {
    if (mode !== Mode.start) return;
    const instance = getInstance(state, sink);
    const tb = getTB(instance, cproc);
    f(instance, tb, sink);
    return tb;
};

( sink mode state cproc f -- instance proc )
: closureFactory                        \ returns arsg for a new closure ( instance proc )
    >r >r                               \ sink mode state (r: f cproc)
    swap                                \ sink state mode
    Mode.start = if                     \ sink state
        swap >range                     \ state (r: f cproc sink)                       
        4 array>                        \ args0 vars0 source0 sink0 
        drop r@                         \ args vars source sink (r: f cproc sink)
        4 create-array                  \ instance
        >r >r swap >r                   \ instance cproc sink f
        2over                           \ instance cproc sink f instance cproc
    then                                \ sink state
    2drop
    2r> 2drop                           \ drop: cproc f  
;

( sink -- )
:noname Mode.start swap execute ; ['] closureFactory partial closureFactorySource

['] fromOnceTB ['] closureFactorySource partial sf

_[ 1000 0 0 0 ]_ ['] sf partial fromOnce0;







\ : {{ :noname ; immediate
\ \ : }} [compile] ; ; immediate
\ \ : }} postpone ;  ; immediate
\ : }}  postpone exit ; immediate 

: {{ :noname ; immediate  
: }} postpone ; ; immediate   

: [: postpone ahead align HERE dup cfa-addr ! BODY-OFFSET allot CFA-VALUE swap ! ; immediate
: ;] postpone local-exit postpone then cfa-addr @ postpone literal ; immediate


\ \ t{ 
\     \ defer quot
\     : x  10 20 30  ;
\     x
\     \ is quot
\     \ quot
\     .s
\ \ -> 
\     \ 10 20 30
\ \ }t

\ \ : y {{ 2 3 4 }} 
\ \ ;
\ \ y

\ : x 1 2 ' execute 1 + ;
\ x + .
\ > 4

\ x - .
\ > 0

\ : y ' :noname execute ;


\ : x bl word find ;