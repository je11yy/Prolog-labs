#№ Отчет по лабораторной работе №3
## по курсу "Логическое программирование"

## Решение задач методом поиска в пространстве состояний

### студент: Власова Л.А.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |               |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*


## Введение
Метод поиска в пространстве состояний удобно применять для решения задач, таких как планирование, диагностика, игры, анализ данных, логический вывод и другие. Этот метод позволяет систематически исследовать возможные состояния системы и выбирать оптимальное решение на основе заданных правил и ограничений.

Prolog является удобным языком для решения таких задач по нескольким причинам. Во-первых, он основан на логике предикатов, что делает его удобным для формулирования ограничений и логических отношений. Во-вторых, Prolog имеет встроенный механизм унификации, который позволяет эффективно сопоставлять и объединять данные. Кроме того, Prolog поддерживает рекурсию, что делает его мощным инструментом для обработки древовидных структур данных, таких как деревья поиска или другие составные структуры.

## Задание

Крестьянину нужно переправить волка, козу и капусту с левого берега реки на правый. Как это сделать за минимальное число шагов, если в распоряжении крестьянина имеется двухместная лодка, и нельзя оставлять волка и козу или козу и капусту вместе без присмотра человека.

## Принцип решения

Опишем правило из условия: "волк не может оставаться без человека с козой, коза не может оставаться без человека с капустой".
```prolog
rule([Human, Wolf, Goat, Cabbage]):- 
	not(((Wolf == Goat), Wolf \= Human)), 
	not(((Goat == Cabbage), Goat \= Human)).
```

Для решения задачи я использовала такую логику: у каждого из объектов есть свое состояние left или right. Если состояние - left, то объект на левом берегу, right - на правом.
Опишем предикат, меняющий состояние объекта на противоположный.
```prolog
change_state(L, R) :-
	(L == left, R = right);
	(L == right, R = left).
```

Теперь реализуем предикаты, меняющие состояния объектов, то есть, если говорить понятным языком, предикаты, которые реализуют переправку объектов на другой берег: перевозка человека в одиночку, человека с волком, человека с капустой и человека с козой. Также проверяем, удовлетворяет ли перестановка предикату rule.
```prolog
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
```

Поиск в глубину.
```prolog
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
```

Поиск в ширину.
```prolog
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
```

Поиск с итеративным погружением.
Алгоритм поиска с итеративным погружением - это поиск в ширину, но при этом углубление происходит на количество элементов, равное числу итераций, а не на один элемент.
```prolog
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
``` 

Вывод результатов.
Я решила совместить все функции в один предикат, чтобы удобно сравнивать получившиеся результаты.
```prolog
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
```

## Результаты

```prolog
?- start.
Search in depth
Human: left, Wolf: left, Goat: left, Cabbage: left
Human: right, Wolf: left, Goat: right, Cabbage: left
Human: left, Wolf: left, Goat: right, Cabbage: left
Human: right, Wolf: right, Goat: right, Cabbage: left
Human: left, Wolf: right, Goat: left, Cabbage: left
Human: right, Wolf: right, Goat: left, Cabbage: right
Human: left, Wolf: right, Goat: left, Cabbage: right
Human: right, Wolf: right, Goat: right, Cabbage: right
Time: 0.00016808509826660156 seconds

Search in width
Human: left, Wolf: left, Goat: left, Cabbage: left
Human: right, Wolf: left, Goat: right, Cabbage: left
Human: left, Wolf: left, Goat: right, Cabbage: left
Human: right, Wolf: right, Goat: right, Cabbage: left
Human: left, Wolf: right, Goat: left, Cabbage: left
Human: right, Wolf: right, Goat: left, Cabbage: right
Human: left, Wolf: right, Goat: left, Cabbage: right
Human: right, Wolf: right, Goat: right, Cabbage: right
Time: 0.000331878662109375

Iterative search
Human: left, Wolf: left, Goat: left, Cabbage: left
Human: right, Wolf: left, Goat: right, Cabbage: left
Human: left, Wolf: left, Goat: right, Cabbage: left
Human: right, Wolf: right, Goat: right, Cabbage: left
Human: left, Wolf: right, Goat: left, Cabbage: left
Human: right, Wolf: right, Goat: left, Cabbage: right
Human: left, Wolf: right, Goat: left, Cabbage: right
Human: right, Wolf: right, Goat: right, Cabbage: right
Time: 0.0004534721374511719 seconds
true.
```

Можем заметить, что алгоритм поиска в глубину является самым эффективным по времени, а длина найденного пути у всех алгоритмов одинакова.

## Выводы

В данной лабораторной работе я изучила алгоритмы поиска, использующиеся для решения задач на языке Prolog. Для решения моей задачи каждый из алгоритмов работал корректно и был эффективен, однако по времени быстрее всего оказался поиск в глубину.

Язык Prolog оказался эффективен для решения подобных задач, так как позволяет легко составлять условия (ограничения), а также имеет возможность использовать рекурсивные методы поиска, что сильно облегчает задачу программиста.