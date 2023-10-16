% ������ ����� ������� - ��������� ������ �� ��������

% ����� ������

my_len([], 0).
my_len([_|X], Length) :- my_len(X,Newlength), Length is Newlength + 1.

% �������� �� ������� ��������� ������

my_member(Element, [Element|_]).
my_member(Element, [_|X]) :- my_member(Element, X).

% ������������ �������

my_append([], List, List).
my_append([A|List], Newlist, [A|List1]) :- my_append(List, Newlist, List1).

% �������� �� ������

my_remove(Element, [Element|List], List).
my_remove(Element, [Y|List], [Y|Newlist]) :- my_remove(Element, List, Newlist).

% ������������ ������

my_permute([], []).
my_permute(List, [Element|T]) :- my_remove(Element, List, Newlist), my_permute(Newlist, T).

% �������� ��������� ��� ����� ����

my_sublist(Sublist, List) :- my_append(_, Newlist, List), my_append(Sublist, _, Newlist).

% �������� ��������� �������
% ������� 9. ��������� N-�� �������� ������

% ��� ����������� ����������

get_n_element(1, [Element|_], Element).
get_n_element(N, [_|X], Element) :- get_n_element(N1, X, Element), N is N1 + 1.

% ��������� ����������� ���������

get_n(N, List, Element) :- my_append(A, [Element|_], List), my_len(A, N1), N is N1 + 1.

% �������� ��������� �������� �������
% ������� 14. �������� ������ �� �������������� ����������

% ��� ����������� ����������

geom([X, Y, Z|List]) :-!, (Y / X) =:= (Z / Y), geom([Y, Z|List]).
geom(_).

% ��������� ����������� ���������

geom_new([X, Y, Z|List]) :-!, (Y / X) =:= (Z / Y), my_remove(X, [X,Y,Z|List], Newlist), geom_new(Newlist).
geom_new(_).

% ������ ������������� �������� �������� �� ������ �� ��� ������ � ������.
% �.�. ����������� �������� �������� �������� + ��������� N-��� �������� ������.

% N - ����� ��������, List - ������
remove_n_element(N, List) :- get_n_element(N, List, Element), my_remove(Element, List, Newlist), write(Newlist).