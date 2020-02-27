teacher(appleton).
teacher(gross).
teacher(knight).
teacher(mcevoy).
teacher(parnell).

subject(english).
subject(gym).
subject(history).
subject(math).
subject(science).

state(california).
state(florida).
state(maine).
state(oregon).
state(virginia).

activity(antiquing).
activity(camping).
activity(sightseeing).
activity(spelunking).
activity(water-skiing).

solve :-
    subject(AppletonSubject), subject(GrossSubject), subject(KnightSubject),
    subject(McevoySubject), subject(ParnellSubject),
    all_different([AppletonSubject, GrossSubject, KnightSubject, McevoySubject,
                   ParnellSubject]),

    state(AppletonState), state(GrossState), state(KnightState),
    state(McevoyState), state(ParnellState),
    all_different([AppletonState, GrossState, KnightState, McevoyState,
                   ParnellState]),

    activity(AppletonActivity), activity(GrossActivity), activity(KnightActivity),
    activity(McevoyActivity), activity(ParnellActivity),
    all_different([AppletonActivity, GrossActivity, KnightActivity,
                   McevoyActivity, ParnellActivity]),

    Quadruples = [[appleton, AppletonSubject, AppletonState, AppletonActivity],
                  [gross, GrossSubject, GrossState, GrossActivity],
                  [knight, KnightSubject, KnightState, KnightActivity],
                  [mcevoy, McevoySubject, McevoyState, McevoyActivity],
                  [parnell, ParnellSubject, ParnellState, ParnellActivity]],

    (member([gross, math, _, _], Quadruples) ;
     member([gross, science, _, _], Quadruples)),

    ((member([gross, _, _, antiquing], Quadruples) ->
     member([gross, _, florida, antiquing], Quadruples)) ;
     member([gross, _, california, _], Quadruples)),


    (member([_, science, california, water-skiing], Quadruples) ;
     member([_, science, florida, water-skiing], Quadruples)),

    (member([mcevoy, history, maine, _], Quadruples) ;
     member([mcevoy, history, oregon, _], Quadruples)),


     member([parnell, _, _, spelunking], Quadruples),

    ((member([_, english, virginia, _], Quadruples) ->
      member([appleton, english, virginia, _], Quadruples)) ;
      member([parnell, _, virginia, spelunking], Quadruples)),


    \+ member([_, gym, maine, _], Quadruples),
    \+ member([_, _, maine, sightseeing], Quadruples),


    \+ member([knigh, _, _, camping], Quadruples),
    \+ member([mcevoy, _, _, camping], Quadruples),
    \+ member([gross, _, _, camping], Quadruples),

    (member([gross, _, _, antiquing], Quadruples) ;
     member([appleton, _, _, antiquing], Quadruples) ;
     member([parnell, _, _, antiquing], Quadruples)),

    tell(appleton, AppletonSubject, AppletonState, AppletonActivity),
    tell(gross, GrossSubject, GrossState, GrossActivity),
    tell(knight, KnightSubject, KnightState, KnightActivity),
    tell(mcevoy, McevoySubject, McevoyState, McevoyActivity),
    tell(parnell, ParnellSubject, ParnellState, ParnellActivity).


all_different([H | T]) :- member(H, T), !, fail.
all_different([_ | T]) :- all_different(T).
all_different([_]).

tell(W, X, Y, Z) :-
    write(W), write(' who teaches '), write(X), write(' went to '), write(Y),
    write(' to do the activity '), write(Z), write('.'), nl.

