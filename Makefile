proj: 
	bison -d -t -v proj.y
	flex -o proj.lex.c proj.l
	gcc -Wall -o proj proj.lex.c proj.tab.c -lfl -lm
clean:
	rm -rf proj.lex.c proj.tab.c proj.tab.h proj.output proj
run:
	./proj input2.txt

