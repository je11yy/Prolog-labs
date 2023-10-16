% Первая часть задания - предикаты работы со списками

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

% Предикат обработки списков
% ВАРИАНТ 9. Получение N-го элемента списка

% Без стандартных предикатов

get_n_element(1, [Element|_], Element).
get_n_element(N, [_|X], Element) :- get_n_element(N1, X, Element), N is N1 + 1.

% Используя стандартные предикаты

get_n(N, List, Element) :- my_append(A, [Element|_], List), my_len(A, N1), N is N1 + 1.

% Предикат обработки числовых списков
% ВАРИАНТ 14. Проверка списка на геометрическую прогрессию

% Без стандартных предикатов

geom([X, Y, Z|List]) :-!, (Y / X) =:= (Z / Y), geom([Y, Z|List]).
geom(_).

% Используя стандартные предикаты

geom_new([X, Y, Z|List]) :-!, (Y / X) =:= (Z / Y), my_remove(X, [X,Y,Z|List], Newlist), geom_new(Newlist).
geom_new(_).

% Пример использования удаление элемента из списка по его номеру в списке.
% Т.е. стандартный предикат удаления элемента + получение N-ого элемента списка.

% N - номер элемента, List - список
remove_n_element(N, List) :- get_n_element(N, List, Element), my_remove(Element, List, Newlist), write(Newlist).