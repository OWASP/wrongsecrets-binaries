CC = gcc
CFLAGS = -Wall -Wextra -Ilib
LDFLAGS =
SRC = advanced.c
OBJ = advanced.o
TARGET = advanced
CPPCHECK = cppcheck

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(TARGET) $(OBJ)

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f $(TARGET) $(OBJ)

check:
	$(CPPCHECK) -i lib $(SRC)