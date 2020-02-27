customer(hugh).
customer(ida).
customer(jeremy).
customer(leroy).
customer(stella).

rose(cottage_beauty).
rose(golden_sunset).
rose(mountain_bloom).
rose(pink_paradise).
rose(sweet_dream).

event(anniversary).
event(charity_auction).
event(retirement).
event(senior_prom).
event(wedding).

item(balloons).
item(candles).
item(chocolates).
item(place_cards).
item(streamers).

solve :-
    rose(HughRose), rose(IdaRose), rose(JeremyRose), rose(LeroyRose),
    rose(StellaRose),
    all_different([HughRose, IdaRose, JeremyRose, LeroyRose, StellaRose]),

    event(HughEvent), event(IdaEvent), event(JeremyEvent), event(LeroyEvent),
    event(StellaEvent),
    all_different([HughEvent, IdaEvent, JeremyEvent, LeroyEvent, StellaEvent]),

    item(HughItem), item(IdaItem), item(JeremyItem), item(LeroyItem),
    item(StellaItem),
    all_different([HughItem, IdaItem, JeremyItem, LeroyItem, StellaItem]),

    Quadruples = [[hugh, HughRose, HughEvent, HughItem],
                  [ida, IdaRose, IdaEvent, IdaItem],
                  [jeremy, JeremyRose, JeremyEvent, JeremyItem],
                  [leroy, LeroyRose, LeroyEvent, LeroyItem],
                  [stella, StellaRose, StellaEvent, StellaItem]],

    member([jeremy, _, senior_prom, _], Quadruples),
    \+ member([stella, _, wedding, _], Quadruples),
    member([stella, cottage_beauty, _, _], Quadruples),

    member([hugh, pink_paradise, _, _], Quadruples),
    \+ member([hugh, _, charity_auction, _], Quadruples),
    \+ member([hugh, _,  wedding, _], Quadruples),

    member([_, _, anniversary, streamers], Quadruples),
    member([_, _, wedding, balloons], Quadruples),

    member([_, sweet_dream, _, chocolates], Quadruples),
    \+ member([jeremy, mountain_bloom, _, _], Quadruples),

    member([leroy, _, retirement, _], Quadruples),
    member([_, _, senior_prom, candles], Quadruples),

    tell(hugh, HughRose, HughEvent, HughItem),
    tell(ida, IdaRose, IdaEvent, IdaItem),
    tell(jeremy, JeremyRose, JeremyEvent, JeremyItem),
    tell(leroy, LeroyRose, LeroyEvent, LeroyItem),
    tell(stella, StellaRose, StellaEvent, StellaItem).


all_different([H | T]) :- member(H, T), !, fail.
all_different([_ | T]) :- all_different(T).
all_different([_]).

tell(W, X, Y, Z) :-
    write(W), write(' got the '), write(X), write(' roses for the '), write(Y), write(' and got the item '), write(Z), write('.'), nl.

