CC = gcc
CFLAGS = -Wall -Wextra -Ilib
LDFLAGS =
SRC = advanced.c
TARGET = advanced
CPPCHECK = cppcheck

.PHONY: all clean check

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(TARGET) $(SRC)

clean:
	rm -f $(TARGET)

check:
	$(CPPCHECK) -i lib $(SRC)