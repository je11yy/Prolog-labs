# Отчет по лабораторной работе №1
## Работа со списками и реляционным представлением данных
## по курсу "Логическое программирование"

### студент: Власова Л.А.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |               |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*


## Введение

Списки в Прологе представлены структурой данных, состоящей из узлов. Узел хранит в себе указатель только на следующий элемент, следовательно, список в Прологе является односвязным списком. Принято разделять список на голову (текущий узел) и хвост (такой же список, содержащий оставшиеся узлы). В связи с таким подходом в Прологе списки обычно обрабатываются с помощью хвостовой рекурсии (вместо использования циклов), что отличает их от списков в остальных языках. К тому же, списки являются неизменяемыми. То есть при добавлении элемента в него возвращается не тот же список с добавленным элементом, а новосозданный, где содержатся элементы из прошлого списка и новый.

Списки в Прологе можно сравнить с массивами и односвязными списками в других языках, однако с некоторыми отличиями: нет индексированного уровня доступа, а также список в Прологе может хранить элементы не одного типа данных.

## Задание 1.1: Предикат обработки списка

Стандартные предикаты обработки списков:
```prolog
% Длина списка
my_len([], 0).
my_len([_|X], Length) :- my_len(X,Newlength), Length is Newlength + 1.

% Является ли элемент элементом списка
my_member(Element, [Element|_]).
my_member(Element, [_|X]) :- my_member(Element, X).

% Конкатенация списков
my_append([], List, List).
my_append([A|List], Newlist, [A|List1]) :- my_append(List, Newlist, List1).

% Удаление из списка
my_remove(Element, [Element|List], List).
my_remove(Element, [Y|List], [Y|Newlist]) :- my_remove(Element, List, Newlist).

% Перестановки списка
my_permute([], []).
my_permute(List, [Element|T]) :- my_remove(Element, List, Newlist), my_permute(Newlist, T).

% Проверка подсписка или поиск всех
my_sublist(Sublist, List) :- my_append(_, Newlist, List), my_append(Sublist, _, Newlist).
```
`get_n_element(1, [Element|_], Element)` - Получение N-го элемента списка, реализация без стандартных предикатов обработки списков.

`get_n(1, [Element|_], Element)` - Получение N-го элемента списка, реализация c0 стандартными предикатами обработки списков.

Примеры использования:
```prolog
?- get_n_element(5,[a,b,c,d,t,g],X).
X = t .
?- get_n_element(5,[a,b,c],X).
false.
?- get_n_element(3,[a,b,2,4,5],X).
X = 2 .

?- get_n(5,[a,b,c,d,t,g],X).
X = t .
?- get_n(5,[a,b,c],X).
false.
?- get_n(3,[a,b,2,4,5],X).
X = 2 .
```

Реализация:
```prolog
% Без стандартных предикатов
get_n_element(1, [Element|_], Element).
get_n_element(N, [_|X], Element) :- get_n_element(N1, X, Element), N is N1 + 1.

% Используя стандартные предикаты
get_n(N, List, Element) :- my_append(A, [Element|_], List), my_len(A, N1), N is N1 + 1.
```

Предикат `get_n_element(1, [Element|_], Element)` рекурсивно обходит с конца список, пока не найдет элемент. Предикат `get_n(1, [Element|_], Element)` c помощью предиката `append` разбивает искомый список на два списка так, чтобы второй список начинался с N-го элемента списка, т.е. элемента, который нужно получить.

## Задание 1.2: Предикат обработки числового списка

`geom([X, Y, Z|List])` - Проверка списка на геометрическую прогрессию без стандартных предикатов обработки списков.

`geom_new([X, Y, Z|List])` - Проверка списка на геометрическую прогрессию c стандартными предикатами обработки списков.

Примеры использования:
```prolog
?- geom([2,4,8,16,32]).
true.
?- geom([2,4,8,14,32]).
false.

?- geom_new([2,4,8,16,32]).
true .
?- geom_new([2,4,8,14,32]).
false.
```

Реализация:
```prolog
% Без стандартных предикатов
geom([X, Y, Z|List]) :-!, (Y / X) =:= (Z / Y), geom([Y, Z|List]).
geom(_).

% Используя стандартные предикаты
geom_new([X, Y, Z|List]) :-!, (Y / X) =:= (Z / Y), my_remove(X, [X,Y,Z|List], Newlist), geom_new(Newlist).
geom_new(_).
```

Оба предиката работают рекурсивно, проверяя первые три элемента последовательности, а именно - равно ли отношение второго элементу к первому и третьего ко второму. Но предикат `geom([X, Y, Z|List])` каждый раз сдвигается на один элемент вправо, а предикат `geom_new([X, Y, Z|List])` удаляет из списка первый элемент, продолжая работу со оставшимся списком.

## Задание 2: Реляционное представление данных

Реляционное представление часто называют табличным, так как оно основано на отношении между объектами.
Преимущество реляционного представления состоит в удобном хранении информации, а также отображении в понятной форме.
Главный же недостаток состоит в скорости работе с таким представлением. Оно требует больше времени для обработки, особенно для большого объема данных.

В моем представлении данных о студентах `one.pl` я заметила следующий недостаток: в предикате для нахождения количества несдавших студентов в группе мне пришлось создавать два списка: со студентами из группы и со студентами, несдавшими конкретный предмет, а после находить количество элементов из первого списка, которые есть во втором. Если бы и группа, и оценка были написаны сразу, создать пришлось бы лишь один список.

Представление 1, вариант 2.

1. Напечатать средний балл для каждого предмета

`summary([Mark|Marks], Summary)` - суммирует все элементы списка.
`get_average_mark(Subject, Result))` - находит среднее арифметическое оценок за данный предмет.
`print_all_averages(X)` - печатает все найденные значения для каждого предмета.

Реализация:
```prolog
summary([],0).
summary([Mark|Marks], Summary) :- summary(Marks, Prevsum), Summary is Mark + Prevsum.

get_average_mark(Subject, Result) :-
    findall(Mark, grade(_, Subject, Mark), Marks),
    summary(Marks, Summary),
    length(Marks, N),
    Result is Summary / N.

print_all_averages(X) :-
    subject(Subject, Name),
    get_average_mark(Subject, Result),
    write('Средний балл для '), write(Name), write(': '), write(Result), write('\n'), fail.
```

Пример использования:
```prolog
?- print_all_averages(X).
Средний балл для Логическое программирование: 3.9642857142857144
Средний балл для Математический анализ: 3.6785714285714284
Средний балл для Функциональное программирование: 3.892857142857143
Средний балл для Информатика: 3.5714285714285716
Средний балл для Английский язык: 4.178571428571429
Средний балл для Психология: 3.607142857142857
false.
```

2. Для каждой группы, найти количество не сдавших студентов

`failed_student(Name, Group)` - есть ли у студента двойки.
`failed_in_group(Group, Result)` - подсчет числа несдавших.
`print_didnt_passed()` - печатает количество несдавших для каждой группы.

Реализация:
```prolog
failed_student(Name, Group) :-
    student(Group, Name),
    grade(Name,_,2).

failed_in_group(Group, Result) :-
    setof(Name, failed_student(Name,Group), List),
    length(List, Result).

print_didnt_passed():-
    findall(Group, student(Group, _), Glist),
    sort(Glist, List),
    member(Group, List),
    failed_in_group(Group, Result),
    write('Группа: №'), write(Group), write(' не сдали: '), write(Result), write('\n'), fail.
```

Пример использования:
```prolog
?- print_didnt_passed().
Группа: №101 не сдали: 2
Группа: №102 не сдали: 4
Группа: №103 не сдали: 3
Группа: №104 не сдали: 4
false.
```
3. Найти количество не сдавших студентов для каждого из предметов

`didnt_passed_subject(Subject, Result)` - количество студентов с двойками.
`print_all_subjects()` - печать количества несдавших студентов для каждого предмета.

Реализация:
```prolog
didnt_passed_subject(Subject, Result) :-
    findall(Student, grade(Student, Subject, 2), Students),
    length(Students, Result).

print_all_subjects() :-
    subject(Subject, Name),
    didnt_passed_subject(Subject, Result),
    write('Количество несдавших '), write(Name), write(': '), write(Result), write('\n'), fail.
```

Пример использования:
```prolog
?- print_all_subjects().
Количество несдавших Логическое программирование: 3
Количество несдавших Математический анализ: 6
Количество несдавших Функциональное программирование: 1
Количество несдавших Информатика: 3
Количество несдавших Английский язык: 1
Количество несдавших Психология: 5
false.
```

## Выводы

Данная лабораторная работа позволила мне научиться понять основы языка Пролог, углубиться в понятие терминов, а также использовать новые знания на практике. Я разобралась с работой с реляционными данными, а также научилась "упрощать" анализ данных и работу над ними.




