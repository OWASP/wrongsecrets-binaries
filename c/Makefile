CC = gcc
CFLAGS = -Wall -Wextra
SRC = main.c
TARGET = main
CPPCHECK = cppcheck

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -o $(TARGET) $(SRC)

.PHONY: clean

clean:
	rm -f $(TARGET)

check:
	$(CPPCHECK) $(SRC)