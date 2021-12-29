all: part2

part2: lex.yy.c part2.tab.c part2_helpers.c part2_helpers.h
	gcc part2.tab.c lex.yy.c part2_helpers.c -o part2

lex.yy.c: part2.lex part2_helpers.h part2_helpers.c
	flex part2.lex

part2.tab.c part2.tab.h: part2.y
	bison -d -v part2.y

# Utility targets
.PHONY: clean test
clean:
	rm -f part2 lex.yy.c part2.tab.c part2.tab.h

