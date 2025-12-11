
%%%%%%%%%%%%%%%%%
% Your code here:
%%%%%%%%%%%%%%%%%

parse(X) :- lines(X, []).

lines(In, Out) :-
    line(In, [';'|Rest]),    
    lines(Rest, Out).
lines(In, Out) :-
    line(In, Out). 

line(In, Out) :-
    num(In, [','|Rest]),     
    line(Rest, Out).         
line(In, Out) :-
    num(In, Out).            


num(In, Out) :-
    digit(In, Out).
num(In, Out) :-
    digit(In, Rest),
    num(Rest, Out).

digit([D|Rest], Rest) :-
    member(D, ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']).

% Example execution:
% ?- parse(['3', '2', ',', '0', ';', '1', ',', '5', '6', '7', ';', '2']).
% true.
% ?- parse(['3', '2', ',', '0', ';', '1', ',', '5', '6', '7', ';', '2', ',']).
% false.
% ?- parse(['3', '2', ',', ';', '0']).
% false.
