CC = gcc
SRC = main.c
OUT = main
CPPCHECK = cppcheck

.PHONY: all clean check

all: $(OUT)

$(OUT): $(SRC)
	$(CC) $(CFLAGS) -o $(OUT) $(SRC)

clean:
	rm -f $(OUT)

check:
	@which $(CPPCHECK) > /dev/null && \
		$(CPPCHECK) $(SRC) || \
		(echo "cppcheck not found. You can obtain it at: https://cppcheck.sourceforge.io/#download" && \
		exit 1)
