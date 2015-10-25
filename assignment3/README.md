CSC344 Assignment 3 (Scala)

Write a Scala program that performs pattern matching on strings, 
where patterns are expressed using only the concatenation, alternation ("|") and
optional ("?") operators of regular expressions (no loops/"*", no escape characters). 
Each run of the program should accept a pattern, and then any number of strings, 
reporting only whether they match. Your program should represent expressions (as trees) and evaluate on the inputs, 
without using the Scala regular expression library. 

    For example:
    pattern? ((h|j)ello worl?d)|(42)
    string? hello world
    match
    string? jello word
    match
    string? 42
    match
    string? 24
    no match
    string? hello world42
    no match
    Bootstrap

A flat grammar for patterns is:

    E -> c | EE | E'|'E | E'?' | '(' E ')'
  
Where c is any character other than "()|?", and where option('?') has highest precedence, then concatentation, then alternation('|').
This can be transformed into an ugly but deterministically parseable form:

    S  -> E$
    E  -> T E2
    E2 -> '|' E3 
    E2 -> NIL
    E3 -> T E2
    T  -> F T2
    T2 -> F T2
    T2 -> NIL
    F  -> A F2
    F2 -> '?' F2
    F2 -> NIL
    A  -> c
    A  -> '(' A2
    A2 -> E ')'   
    
where '$' is eof/end-of-string, and NIL means empty 
(which in these productions means take the rhs only if others do not apply).
