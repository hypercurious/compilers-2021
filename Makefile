comp: comp.y comp.l
	bison -d -t comp.y
	flex -o comp.lex.c comp.l
	gcc -Wall -o comp main.c comp.lex.c comp.tab.c -lfl -lm
clean:
	rm -rf comp.lex.c comp.tab.c comp.tab.h comp
