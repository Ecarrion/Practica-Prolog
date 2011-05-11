readProgram(X) :- X = './program.txt',
	see(X),
        repeat,
        get_char(T),
	print(T),
	T = end_of_file,
	!,
	seen.
