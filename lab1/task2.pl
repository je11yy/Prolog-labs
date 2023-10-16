% Task 2: Relational Data

% ������������� 1
% ������� 2

:- include('one.pl').

% ���������� ������� ���� ��� ������� ��������

summary([],0).
summary([Mark|Marks], Summary) :- summary(Marks, Prevsum), Summary is Mark + Prevsum.

get_average_mark(Subject, Result) :-
    findall(Mark, grade(_, Subject, Mark), Marks),
    summary(Marks, Summary),
    length(Marks, N),
    Result is Summary / N,
    write(Result).

% ��� ������ ������, ����� ���������� �� ������� ���������

find_quantity([], _, 0).
find_quantity([ElementX|ListX], ListY, Quantity) :-
    member(ElementX, ListY),
    find_quantity(ListX, ListY, Count),
    Quantity is Count + 1.
find_quantity([ElementX|ListX], ListY, Quantity) :-
    find_quantity(ListX, ListY, Quantity).


didnt_passed(Group, Result) :-
    findall(StudentFromGroup, student(Group, StudentFromGroup), StudentsFromGroup),
    findall(BadStudent, grade(BadStudent, _, 2), BadStudents),
    find_quantity(StudentsFromGroup, BadStudents, Result),
    write(Result).

% ����� ���������� �� ������� ��������� ��� ������� �� ���������

didnt_passed_subject(Subject, Result) :-
    findall(Student, grade(Student, Subject, 2), Students),
    length(Students, Result),
    write(Result).

