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
	@which $(CPPCHECK) > /dev/null && \
		$(CPPCHECK) -i lib $(SRC) || \
		(echo "cppcheck not found. You can obtain it at: https://cppcheck.sourceforge.io/#download" && \
		exit 1)
