% смена состояния
change_state(L, R) :-
	(L == left, R = right);
	(L == right, R = left).

% волк не может оставаться без человека с козой, коза не может оставаться без человека с капустой
rule([Human, Wolf, Goat, Cabbage]):- 
	not(((Wolf == Goat), Wolf \= Human)), 
	not(((Goat == Cabbage), Goat \= Human)).

% для каждого из случаев рассмотрим смену состояний

move([Human, Wolf, Goat, Cabbage], [Human_new, Wolf_new, Goat_new, Cabbage_new]):-
	change_state(Human, Human_new),
	rule([Human_new, Wolf, Goat, Cabbage]),
	Wolf_new = Wolf, 
	Goat_new = Goat, 
	Cabbage_new = Cabbage.

move([Human, Wolf, Goat, Cabbage], [Human_new, Wolf_new, Goat_new, Cabbage_new]):-
	change_state(Human, Human_new), 
	change_state(Wolf, Wolf_new),
	rule([Human_new, Wolf_new, Goat, Cabbage]),
	Goat_new = Goat, 
	Cabbage_new = Cabbage.

move([Human, Wolf, Goat, Cabbage], [Human_new, Wolf_new, Goat_new, Cabbage_new]):-
	change_state(Human, Human_new), 
	change_state(Goat, Goat_new),
	rule([Human_new, Wolf, Goat_new, Cabbage]),
	Wolf_new = Wolf, 
	Cabbage_new = Cabbage.

move([Human, Wolf, Goat, Cabbage], [Human_new, Wolf_new, Goat_new, Cabbage_new]):-
	change_state(Human, Human_new), 
	change_state(Cabbage, Cabbage_new),
	rule([Human_new, Wolf, Goat, Cabbage_new]),
	Wolf_new = Wolf, 
	Goat_new = Goat.

add_object([Head|Tail],[Y, Head|Tail]):-
	move(Head, Y), not(member(Y, [Head|Tail])).

inversion([]).
inversion([Head|Tail]):-
	inversion(Tail),
	print_state(Head), nl.

% вывод состояний каждого из объектов
print_state([Human, Wolf, Goat, Cabbage]):-
    write("Human: "), write(Human), 
    write(", Wolf: "), write(Wolf),
    write(", Goat: "), write(Goat),
    write(", Cabbage: "), write(Cabbage).

% поиск в ширину
search_in_width(Begin, Finish):-
	get_time(T),
	width([[Begin]], Finish, Ans), inversion(Ans),
	get_time(TT),
	Time is TT - T,
    write('Time: '), write(Time), nl, !.

width([[Finish|T]|_], Finish, [Finish|T]).
width([Next|B], Finish, Ans):-
	findall(X, add_object(Next, X), T), !,
	append(B, T, Bn),
	width(Bn, Finish, Ans).
width([_|T], Finish, Ans):- 
	width(T, Finish, Ans).

% поиск с итеративным погружением
search_iter(Begin, Finish):-
	get_time(T),
	count(Limit),
	deeper([Begin], Finish, Ans, Limit), inversion(Ans),
	get_time(TT),
	Time is TT - T,
    write("Time: "), write(Time), write(" seconds"), nl, !.

count(1).
count(X):-
	count(Y),
	X is Y + 1.

deeper([Finish|T], Finish, [Finish|T], 0).
deeper(List, Finish, ResList, N):-
	N @> 0, add_object(List, NewList), N1 is N - 1, deeper(NewList, Finish, ResList, N1).

% поиск в глубину
search_in_depth(Begin, Finish):-
	get_time(T),
	depth([Begin], Finish, Ans),
	inversion(Ans),
	get_time(TT),
	Time is TT - T,
	write('Time: '), write(Time), write(" seconds"), nl, !.


depth([Finish|T], Finish, [Finish|T]).
depth(List, Finish, Result):-
    add_object(List, LList),
    depth(LList, Finish, Result).

start :-
    write("Search in depth"),
    nl,
    search_in_depth([left,left,left,left],[right,right,right,right]),
    nl,
    write("Search in width"),
    nl,
    search_in_width([left,left,left,left],[right,right,right,right]),
    nl,
    write("Iterative search"),
    nl,
    search_iter([left,left,left,left],[right,right,right,right]).