CC = gcc
CFLAGS = -Wall -Wextra -std=c99
LFLAGS = 
LIBS = 
SOURCES = jeopardy.c questions.c players.c
OBJECTS = $(SOURCES:.c=.o)
TARGET = jeopardy
PREFIX = .

.PHONY: clean help all

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CC) $(CFLAGS) -I$(PREFIX) $(OBJECTS) $(LFLAGS) $(LIBS) -o "$(PREFIX)/$(TARGET)"

%.o: %.c
	$(CC) $(CFLAGS) -I$(PREFIX) -c "$<" -o "$(PREFIX)/$@"

clean:
	rm -f $(addprefix $(PREFIX)/,$(OBJECTS)) "$(PREFIX)/$(TARGET)" *~

cleanup:
	rm -f $(addprefix $(PREFIX)/,$(OBJECTS)) *~

help:
	@echo "Valid targets:"
	@echo "  all:    generates all binary files"
	@echo "  clean:  removes .o and executable files"
