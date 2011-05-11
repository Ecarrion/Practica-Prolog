readfile(File,List) :-
          seeing(Old),      /* save for later */
          see(File),        /* open this file */
          process1([],List),
          seen,             /* close File */
          see(Old),         /*  previous read source */
          !.                /* stop now */

process1(In,Out):-
   read(Data),
   (Data == end_of_file ->Out = In;
   splitHead([Data], H),
   splitBody([Data], T),
   List = [H|T],
   organize(List, Term),
   process1([Term|In],Out)).


splitHead([H|_], O) :-
	arg(1, H, O).

splitBody([H|_], T) :-
	arg(2, H, O),
	O =.. List,
	List = [_|T].


organize([H|T], Term) :-
	Term =.. [regla, H, T].


tupleToList(In, [H|T]) :-
	In =.. List,
	List = [_|Tail],
	Tail = [H|_],
	Tail = [_|TupleList],
	TupleList = [T|_].
	%tupleToList(Tuple, [H|T]).

