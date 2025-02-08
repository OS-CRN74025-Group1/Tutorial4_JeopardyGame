CC = gcc
CFLAGS = -Wall -Wextra -std=c99 -I.
DEPS = jeopardy.h questions.h players.h
OBJ = jeopardy.o questions.o players.o
EXEC = jeopardy

.PHONY: all clean

%.o: %.c $(DEPS)
	$(CC) $(CFLAGS) -c -o $@ $<

all: $(EXEC)

$(EXEC): $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o $@

clean:
	rm -f $(OBJ) $(EXEC) *~
