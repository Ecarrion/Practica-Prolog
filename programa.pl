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
   process1([List|In],Out)).


splitHead([H|_], O) :-
	arg(1, H, O).

splitBody([H|_], O) :-
	arg(2, H, O).
%	Term =.. [p, O],
%	Term =.. List,
%	List = [_|T].
