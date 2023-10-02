CC = gcc
CFLAGS = -Wall -Wextra -Ilib
LDFLAGS =
SRC = advanced.c
OUT = advanced
CPPCHECK = cppcheck

.PHONY: all clean check

all: $(OUT)

$(OUT): $(SRC)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(OUT) $(SRC)

clean:
	rm -f $(OUT)

check:
	@which $(CPPCHECK) > /dev/null && \
		$(CPPCHECK) -i lib $(SRC) || \
		(echo "cppcheck not found. You can obtain it at: https://cppcheck.sourceforge.io/#download" && \
		exit 1)
