better(X,Y,[X|Z]):-
    member(Y,Z).
better(X,Y,[_|Z]):-
    better(X,Y,Z).

begin(A,[A,_,_,_]).
medium(B,[_,B,_,_]).
medium(C,[_,_,C,_]).
end(D,[_,_,_,D]).

answer() :-
    Engineers = [man(A, WhoA), man(B, WhoB), man(C, WhoC),  man(D, WhoD)],

    permutation(['Auto Mechanic','Radio Technician','Chemic','Builder'],[WhoA, WhoB, WhoC, WhoD]),

    ['Borisov','Kirillov','Danin','Savin'] = [A, B, C, D],
    
    #age
    permutation(Engineers, Age),
    member(Engineer1, Engineers),
    better(man('Borisov', _), Engineer1, Age),
    medium(man(_,'Chemic'),Age),
    end(Young, Age),
    begin(Elderly,Age),

    #chess
    permutation(Engineers, Chess),
    begin(Elderly, Chess),
    better( man('Borisov', _), man('Danin', _), Chess),
    better(man('Savin', _), man('Borisov', _),  Chess),
    better(man(_, 'Auto Mechanic'), man(_, 'Builder'),  Chess),

    #ski
    permutation(Engineers, Ski),
    begin(Young, Ski),
    better(man(_, 'Radio Technician'), man(_, 'Builder'), Ski),
    better(man('Borisov', _), _, Ski),

    #theatre
    permutation(Engineers, Theatre),
    begin(Elderly, Theatre),
    member(Engineer2, Engineers),
    better(man('Borisov', _), Engineer2, Theatre),
    better(Engineer2, man('Kirillov', _), Age),
    better(man(_, 'Chemic'), man(_, 'Auto Mechanic'), Theatre),
    better(man(_, 'Builder'),  man(_, 'Chemic'), Theatre),

    write(A), write(' is '), write(WhoA), write('\n'),
    write(B), write(' is '), write(WhoB), write('\n'),
    write(C), write(' is '), write(WhoC), write('\n'),
    write(D), write(' is '), write(WhoD), write('\n').
