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
	@which $(CPPCHECK) > /dev/null && \
		$(CPPCHECK) $(SRC) || \
		(echo "cppcheck not found. You can obtain it at: https://cppcheck.sourceforge.io/#download" && \
		exit 1)
