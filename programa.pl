main(FileR, FileW,List) :-
          seeing(OldS),      /* save for later */
      telling(OldT),
          see(FileR),        /* open this file */
      tell(FileW),
      process2([], List),
          seen,             /* close File */
      told,
          see(OldS),         /*  previous read source */
      tell(OldT),
          !.                /* stop now */


readfile(File, List) :-
          seeing(Old),      /* save for later */
          see(File),        /* open this file */
          %process1([],List),
	  process2([], List),
          seen,             /* close File */
          see(Old),         /*  previous read source */
          !.                /* stop now */

writefile(File) :-
	telling(Old),
	tell(File),
	repeat,
	read(Data),
	process(Data),
	told,
	tell(Old),
	!.

process2(In, Out) :-
	read(Data),
	(Data == end_of_file -> Out = In
	;
	  Data =.. X,
	  X=[H1|T1],
	  (H1 ==(:-) ->      %Si es una clausula
	    T1=[Head|T2],
	    T2=[H3|_],
	    %conjunct_to_list(H3,BodyTerms),
	    tupleToList(H3, [], Body ),
	    organize([Head|Body],Term),
	    write(Term),write(.),nl,

	    lhsVariables(Term, Variables),       %Primera propiedad
	    writeln(Variables),

	    extraVariables(Term, Vars),		 %Segunda propiedad
	    writeln(Vars), nl,

	    process2([Term|In],Out)
	  ;
	   %Si es un hecho
	   organize([Data|[]],Term),
	   write(Term),write(.),nl,
	   process2([Term|In],Out)
	  )
	)
        .


conjunct_to_list((A,B), L) :-
  !,
  conjunct_to_list(A, L0),
  conjunct_to_list(B, L1),
  append(L0, L1, L).
conjunct_to_list(A, [A]).


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


lhsVariables(Rule, Variables) :-
	Rule =.. [_, Head, _],
	Head =.. List,
	containsVariables(List, [], Variables),
	(Variables == [] -> writeln('No tiene variables en el LHS')
	;
	writeln('Tiene variables en el LHS')).

extraVariables(Rule, Variables) :-
	Rule =.. [_, Head, Condition],
	Head =.. ListH,
	containsVariables(ListH, [], HeadVars),
	bodyVariables(Condition, [], BodyVars),
	mutuals(HeadVars, BodyVars, [], Variables),
	(Variables == [] -> writeln('No hay variables extra')
	;
	writeln('Si Hay variables Extra')).



%Devuelve las variables de un predicado en forma de lista
containsVariables([], V, O) :- O = V, !.
containsVariables(List, Variables, Out) :-
       List = [Var|T],
       (var(Var) ->
       containsVariables(T,[Var|Variables], Out)
       ;
       containsVariables(T, Variables, Out)).


%Devuelve las variables de una serie de predicados en forma de lista
bodyVariables(Body, V, Variables) :-
	Body == [] -> Variables = V, !;
	Body = [Predicate|T],
	Predicate =.. List,
	containsVariables(List, [], Vars),
	append(Vars, V, M),
	bodyVariables(T, M, Variables).


	%Entrega los elementos de una lista que se encuentran en otra
mutuals(List, AnotherList, L, Common) :-
	List ==  [] -> Common = L, !;
	List = [H|T],
	(members(H, AnotherList) ->
	mutuals(T, AnotherList, [H|L], Common);
	mutuals(T, AnotherList, L, Common)).


%Verifica si una variable pertenese a una lista
members(Var, List) :-
	List = [V|T],
	(Var == V -> !;
	members(Var, T)).
