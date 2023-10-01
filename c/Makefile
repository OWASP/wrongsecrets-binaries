CC = gcc
CFLAGS = -Wall -Wextra
SRC = main.c
TARGET = main
CPPCHECK = cppcheck

.PHONY: all clean check

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -o $(TARGET) $(SRC)

clean:
	rm -f $(TARGET)

check:
	$(CPPCHECK) $(SRC)