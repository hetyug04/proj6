%%%%%%%%%%%%%%%%%%%%%%
% Your code goes here:
%%%%%%%%%%%%%%%%%%%%%%

search(Actions) :-
    initial(StartRoom),
    get_keys(StartRoom, [], InitialKeys),
    bfs([state(StartRoom, InitialKeys, [StartRoom])], [], Actions).

bfs([state(Room, _Keys, Path)|_], _, Actions) :-
    treasure(Room),
    reverse(Path, Rooms),
    rooms_to_moves(Rooms, Actions).

bfs([state(Room, Keys, _)|RestQueue], Visited, Actions) :-
    member(st(Room, Keys), Visited), !,
    bfs(RestQueue, Visited, Actions).

bfs([state(Room, Keys, Path)|RestQueue], Visited, Actions) :-
    findall(
        state(NextRoom, NextKeys, [NextRoom|Path]),
        (
            can_pass(Room, NextRoom, Keys),
            get_keys(NextRoom, Keys, NextKeys)
        ),
        NextStates
    ),
    append(RestQueue, NextStates, NewQueue),
    bfs(NewQueue, [st(Room, Keys)|Visited], Actions).

can_pass(Here, There, _) :-
    (door(Here, There); door(There, Here)),
    \+ locked_door(Here, There, _),
    \+ locked_door(There, Here, _).

can_pass(Here, There, Keys) :-
    (locked_door(Here, There, Color); locked_door(There, Here, Color)),
    member(Color, Keys).

get_keys(Room, Keys0, Keys) :-
    findall(Color, key(Room, Color), Colors),
    append(Colors, Keys0, Keys1),
    sort(Keys1, Keys).

rooms_to_moves([_], []).
rooms_to_moves([A,B|Rest], [move(A,B)|Moves]) :-
    rooms_to_moves([B|Rest], Moves).
