CC = gcc
CFLAGS = -Wall -Wextra -std=c99
SRCDIR = jeopardy-source
OBJDIR = $(SRCDIR)/obj
BINDIR = $(SRCDIR)/bin

# Include path for header files
INCLUDES = -I$(SRCDIR)

# Source files
SOURCES = $(wildcard $(SRCDIR)/*.c)
HEADERS = $(wildcard $(SRCDIR)/*.h)
OBJECTS = $(SOURCES:$(SRCDIR)/%.c=$(OBJDIR)/%.o)

# Main executable
EXEC = $(BINDIR)/jeopardy

.PHONY: all clean directories

all: directories $(EXEC)

directories:
	@mkdir -p $(OBJDIR)
	@mkdir -p $(BINDIR)

$(EXEC): $(OBJECTS)
	$(CC) $(CFLAGS) $(INCLUDES) $^ -o $@

$(OBJDIR)/%.o: $(SRCDIR)/%.c $(HEADERS)
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

clean:
	rm -rf $(OBJDIR) $(BINDIR)
	rm -f *~
