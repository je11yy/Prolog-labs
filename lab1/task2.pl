% Task 2: Relational Data

% ПРЕДСТАВЛЕНИЕ 1
% ВАРИАНТ 2

:- include('one.pl').

% Напечатать средний балл для каждого предмета

summary([],0).
summary([Mark|Marks], Summary) :- summary(Marks, Prevsum), Summary is Mark + Prevsum.

get_average_mark(Subject, Result) :-
    findall(Mark, grade(_, Subject, Mark), Marks),
    summary(Marks, Summary),
    length(Marks, N),
    Result is Summary / N,
    write(Result).

% Для каждой группы, найти количество не сдавших студентов

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

% Найти количество не сдавших студентов для каждого из предметов

didnt_passed_subject(Subject, Result) :-
    findall(Student, grade(Student, Subject, 2), Students),
    length(Students, Result),
    write(Result).

