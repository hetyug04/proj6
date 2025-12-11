%%%%%%%%%%%%%%%%%%%%%%
% Your code goes here:
%%%%%%%%%%%%%%%%%%%%%%

search(Actions) :-
    initial(StartRoom),
    get_keys(StartRoom, [], InitialKeys),
    
    bfs([state(StartRoom, InitialKeys, [StartRoom])], [], Actions).

bfs([state(Room, _Keys, Path)|_], _, Actions) :-
    treasure(Room),
    reverse(Path, Actions).

bfs([state(Room, Keys, _)|RestQueue], Visited, Actions) :-
    State = st(Room, Keys),
    member(State, Visited), !, % Cut to prevent backtracking into this branch
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
    (door(Here, There); door(There, Here)).

can_pass(Here, There, Keys) :-
    (locked_door(Here, There, Color); locked_door(There, Here, Color)),
    member(Color, Keys).

get_keys(Room, CurrentKeys, NewKeys) :-
    (key(Room, Color) ->
        sort([Color|CurrentKeys], NewKeys)
    ;
        NewKeys = CurrentKeys
    ).