%
% http://www.amzi.com/manuals/samples/prolog/duckworld/
%
%
:- dynamic(loc/2).

% http://www.amzi.com/manuals/samples/prolog/duckworld/dw_data.pro
nextto(pen, yard).
nextto(yard, gardem).
nextto(gardem, house).

loc(egg,pen).
loc(ducks,pen).
loc(you,pen).
loc(bird, gardem).
loc(cat, yard).

move(Item, Place) :-
	retract( loc(Item, _) ),
	assert( loc(Item,Place) ).


% http://www.amzi.com/manuals/samples/prolog/duckworld/dw_rules.pro
connect(X,Y) :-
        nextto(X,Y).
connect(X,Y) :-
        nextto(Y,X).

done :- 
    loc(you, house),
    loc(egg, you),
    loc(cat, yard),
    write("Thanks for getting the egg and saving the bird"), nl. 
done :-
	loc(you, house),
	loc(egg, you),
	write("Thanks for getting the egg."), nl.
done :- 
    loc(you, house),
    loc(cat,yard),
    write("Thanks for saving the bird."), nl.

demons :-
	ducks,
    cat,
	fox.

ducks :-
	loc(ducks, pen),
	loc(you, pen),
	move(ducks, yard),
	write("The ducks have run into the yard."), nl.
ducks.

cat :-
    loc(cat, yard),
	loc(you, yard),
    move(cat, gardem),
    write("The cat have run into the gardem."), nl.
cat.
    
fox :-
	loc(ducks, yard),
	loc(you, house),
	write("The fox has taken a duck."), nl.
fox.

goto(X) :-
	loc(you, L),
	connect(L, X),
	move(you, X),
	write("You are in the "), write(X), nl.
goto(_) :-
	write("You can't get there from here."), nl.

chase(ducks) :-
	loc(ducks, L),
	loc(you, L),
	move(ducks, pen),
	write("The ducks are back in their pen."), nl.
chase(_):-
	write("No ducks here."), nl.

scare(cat) :-
	loc(cat, L),
	loc(you, L),
    move(cat, yard),
	write("You scare the cat and his back to the yard ."), nl.
scare(_):-
	write("No cat here."), nl.

take(X) :-
	loc(you, L),
	loc(X, L),
	move(X, you),
	write("You now have the "), write(X), nl.
take(X) :-
	write("There is no "), write(X), write(" here."), nl.

look :-
	write("You are in the "),
	loc(you, L), write(L), nl,
	look_connect(L),
	look_here(L),
	look_have(you).

look_connect(L) :-
	write("You can go to: "), nl,
	connect(L, CONNECT),
	write(" "), write(CONNECT), nl,
	fail.
look_connect(_).

look_have(X) :-
	write("You have: "), nl,
	loc(THING, X),
	write(" "), write(THING), nl,
	fail.
look_have(_).

look_here(L) :-
	write("You can see: "), nl,
	loc(THING, L),
	THING \= you,
	write(" "), write(THING), nl,
	fail.
look_here(_).

report :-
        findall(X:Y, loc(X,Y), L),
        write(L), nl.

do(goto(X)) :- !, goto(X).
do(chase(X)) :- !, chase(X).
do(scare(X)) :- !, scare(X).
do(take(X)) :- !, take(X).
do(look) :- !, look.
do(help) :- !, instructions.
do(quit) :- !.
do(listing) :- !, listing.
do(report) :- !, report.
do(X) :- write("unknown command"), write(X), nl, instructions.

go :- done.
go :-
	write(">> "),
	read(X),
	X \= quit,
	do(X),
	demons,
	!, go.
go :- write(" Quitter "), nl.

instructions :-
	nl,
	write("You start in the house, the ducks and an egg"), nl,
	write("are in the pen.  You have to get the egg"), nl,
	write("without losing any ducks."), nl,
	nl,
	write("Enter commands at the prompt as Prolog terms"), nl,
	write("ending in period:"), nl,
	write("  goto(X). - where X is a place to go to."), nl,
	write("  take(X). - where X is a thing to take."), nl,
	write("  chase(X). - chasing ducks sends them to the pen."), nl,
    write("  scare(X). - scare cat and send them to the yard."), nl,
	write("  look. - the state of the game."), nl,
	write("  help. - this information."), nl,
	write("  quit. - exit the game."), nl,
	nl.

game :-
	write(" Welcome to Duck World "),nl,
	instructions,
	write(" Go get an egg "),nl,
	go.
