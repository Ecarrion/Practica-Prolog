readfile(File,List) :-
          seeing(Old),      /* save for later */
          see(File),        /* open this file */
          process1([],List),
          seen,             /* close File */
          see(Old),         /*  previous read source */
          !.                /* stop now */

process1(In,Out):-
   read(Data),
   (Data == end_of_file ->Out = In; process1([split(Data, L)|In],Out) ).

splitSentence(In, Out) :-
	string_to_list(In, Out).



splitup(Sep,[token(B)|BL]) --> splitup(Sep,B,BL).
splitup(Sep,[A|AL],B)      --> [A], {\+ [A] = Sep }, splitup(Sep,AL,B).
splitup(Sep,[],[B|BL])     --> Sep, splitup(Sep,B,BL).
splitup(_Sep,[],[])        --> [].

split(In, Out) :-
    phrase(splitup(" ",Tokens),In),
    string_to_list(Out,In).




