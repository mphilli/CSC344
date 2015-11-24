% Prolog - Assignment 4 - CSC 344
% Michael G. Phillips

main :- 
	write('Gladiator Program'), nl, 
    write('What is the number of gladiators? '), 
    read(X),
    % X < 12 ? 
    XIN is 2**X / 2,
    gen_init(XIN, [], 0).

% Initial List Generation
gen_init(X, List, I) :- X = 1, 
    get_doves(['L', 'D']).

gen_init(X, List, I) :- X2 is 2*X, I = X2, T is X / 2,
    append(List, ['D'], NewList),
    length(NewList, R),
    genL(R, NewList, T, 0, []).

gen_init(X, List, I) :- X = I, I2 is I + 1,
    gen_init(X, List, I2).

gen_init(X, List, I) :- X * 2 > I,  I > X,  I2 is I + 1,
    append(List, ['D'], NewList),
    gen_init(X, NewList, I2).

gen_init(X, List, I) :- X > I, I2 is I + 1,
    append(List, ['L'], NewList),
    gen_init(X, NewList, I2).

genL(FLen, [A|B], T, I, GenList) :-
    T > I, I2 is I + 1, 
    atom_concat(A, 'L', C),
    append(GenList, [C], GenList2),
    genL(FLen, B, T, I2, GenList2).

% pass it on
genL(FLen, [A|B], T, I, GenList) :-
    length(GenList, GLen), FLen > GLen, 
    T = I, I2 is 0,
    genD(FLen, [A|B], T, I2, GenList).

genD(FLen, [A|B], T, I, GenList) :-
    T > I, I2 is I + 1, 
    atom_concat(A, 'D', C),
    append(GenList, [C], GenList2),
    genD(FLen, B, T, I2, GenList2).

% pass it on
genD(FLen, [A|B], T, I, GenList) :-
    length(GenList, GLen), FLen > GLen, 
    T = I, I2 is 0,
    genL(FLen, [A|B], T, I2, GenList).

genD(FLen, [A|B], T, I, GenList) :-
    T = 1,
    atom_concat(A, 'D', C),
    append(GenList, [C], GenList2),
    get_doves(GenList2).

genD(FLen, [A|B], T, I, GenList) :-
    atom_concat(A, 'D', C),
    append(GenList, [C], GenList2),
    T \= 1, T2 is T / 2,
    genL(FLen, GenList2, T2, 0, []).

get_doves(List) :- 
    write('What is the number of doves?'), 
    read(Doves), U is Doves,
    make_door_list(Doves, 0, 7, Doors, List, U).

make_door_list(Doves, I, DN, Doors, L, U) :- I < DN, Doves \= 0,
    append(Doors, ['D'], Doors2),
    I2 is I + 1, Doves2 is Doves - 1,
    make_door_list(Doves2, I2, DN, Doors2, L, U). 

make_door_list(Doves, I, DN, Doors, L, U) :- I < DN, Doves = 0,
    append(['T'], Doors, Doors2),
    I2 is I + 1, 
    make_door_list(Doves, I2, DN, Doors2, L, U). 

make_door_list(Doves, I, DN, Doors, L, U) :- 
    I = DN, process(L, Doors, [], [], U).

process([A|B], Doors, ProbList, LCList, U) :-
    A \= [],
    atom_length(A, ELen), LC is 0,
    epro(A, Doors, 0, ELen, 1, Prob, LC, RLC, U),
    append(ProbList, [Prob], NP), 
    append(LCList, [RLC], NLC),
    process(B, Doors, NP, NLC, U).

process(B, Doors, ProbList, NLC, U) :- 
    A = [],  start_out(ProbList, NLC).

epro(Element, [D|R], I, E, Prob, Res, LC, RLC, U) :- 
    E = I, Res is Prob, RLC is LC.

epro(Element, [D|R], I, E, Prob, Res, LC, RLC, U) :- 
    E > I, I2 is I + 1, sub_string(Element, I, 1, _, Char),
    Char = "L", length([D|R], Choosable), LC2 is LC + 1,
    Prob2 is Prob * (U / Choosable), D = 'T',
    epro(Element, R, I2, E, Prob2, Res, LC2, RLC, U).

epro(Element, [D|R], I, E, Prob, Res,LC, RLC, U) :- 
    E > I, I2 is I + 1, sub_string(Element, I, 1, _, Char),
    Char = "L", length([D|R], Choosable), LC2 is LC + 1,
    Prob2 is Prob * (U / Choosable), D = 'D',
    epro(Element, [D|R], I2, E, Prob2, Res, LC2, RLC, U).

epro(Element, [D|R], I, E, Prob, Res,LC, RLC, U) :- 
    E > I, I2 is I + 1, sub_string(Element, I, 1, _, Char),
    Char = "D", length([D|R], Choosable), Choosable = U, 
    Prob2 is 0,
    epro(Element, [D|R], I2, E, Prob2, Res, LC, RLC, U).

epro(Element, [D|R], I, E, Prob, Res, LC, RLC, U) :- 
    E > I, I2 is I + 1, sub_string(Element, I, 1, _, Char),
    Char = "D", length([D|R], Choosable), 
    Prob2 is Prob * ((Choosable - U) / Choosable),
    epro(Element, [D|R], I2, E, Prob2, Res, LC, RLC, U).

start_out([P|RP], [L|RL]) :- 
    final_out(0, L, [P|RP], [L|RL], 0, [P|RP], [L|RL], []).

final_out(I, END, [P|RP], [L|RL], C, PLF, LCLF, F) :-
    RL = [], I2 is I + 1, L = I, C2 is C + P, 
    append(F, [C2], NF),
    final_out(I2, END, PLF, LCLF, 0, PLF, LCLF, NF). 

final_out(I, END, [P|RP], [L|RL], C, PLF, LCLF, F) :-
    RL = [], I2 is I + 1,
    append(F, [C], NF),
    final_out(I2, END, PLF, LCLF, 0, PLF, LCLF, NF). 

final_out(I, END, [P|RP], [L|RL], C, PLF, LCLF, F) :- 
    RL \= [], L = I, END >= I, C2 is P + C, 
    final_out(I, END, RP, RL, C2, PLF, LCLF, F).

final_out(I, END, [P|RP], [L|RL], C, PLF, LCLF, F) :- 
    RL \= [], L \= I, END >= I, 
    final_out(I, END, RP, RL, C, PLF, LCLF, F).

final_out(I, END, [P|RP], [L|RL], C, PLF, LCLF, F) :- 
    length(F, FL), printFinal(F, 0, FL).

printFinal([FH|FT], I, FL) :-
    I < FL + 1,  I2 is I + 1,
    write('The probability that '), write(I), write(' gladiators remain alive: '),
    format('~7f', [FH]), X is rationalize(FH), rational(X, N, D),
	format('  (~d/~d)', [N, D]), nl,
    printFinal(FT, I2, FL).

printFinal([FH|FT], I, FL) :- !, write('------------').