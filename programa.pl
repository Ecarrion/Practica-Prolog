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

   firstElement([Data],Coma),
   Coma == [(:-)] ->

   splitHead([Data], H),
   splitBody([Data], T),
   List = [H|T],
   organize(List, Term),
   process1([Term|In],Out)

   ;

   Term =.. [regla, Data],
   process1([Term|In], Out)).



firstElement([H|_], List) :-
	H =.. Term,
	Term = [Coma|_],
	Coma =.. List.

splitHead([H|_], O) :-
	arg(1, H, O).

splitBody([H|_], T) :-
	arg(2, H, O),
	tupleToList(O, [], T).

organize([H|T], Term) :-
	reverse(T, T2),
	Term =.. [regla, H, T2].


tupleToList(In, Lista, ListaFin) :-
	In =.. List,
	List = [Coma|_],
	Coma == ',' ->

	List = [_|Tail],
	Tail = [H|_],
	Tail = [_|TupleList],
	TupleList = [T|_],
	tupleToList(T, [H|Lista], ListaFin)

	;

	append([In], Lista, ListaFin).

