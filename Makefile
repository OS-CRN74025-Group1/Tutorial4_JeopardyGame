CC = gcc
CFLAGS = -Wall -Wextra -I./src/include
LDFLAGS =

# Directories
SRC_DIR = src
APP_DIR = $(SRC_DIR)/app
LIB_DIR = $(SRC_DIR)/lib
BUILD_DIR = build

# Source files
APP_SRC = $(wildcard $(APP_DIR)/*.c)
LIB_SRC = $(wildcard $(LIB_DIR)/*.c)
ALL_SRC = $(APP_SRC) $(LIB_SRC)

# Object files
OBJECTS = $(ALL_SRC:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)

# Main target
TARGET = $(BUILD_DIR)/jeopardy

.PHONY: all clean

all: $(BUILD_DIR) $(TARGET)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)/app $(BUILD_DIR)/lib

$(TARGET): $(OBJECTS)
	$(CC) $(OBJECTS) -o $@ $(LDFLAGS)

# Compile source files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(BUILD_DIR)/*

# Development targets
.PHONY: run debug

run: all
	./$(TARGET)

debug: CFLAGS += -g
debug: clean all
