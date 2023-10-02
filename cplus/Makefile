CXX = g++
CXXFLAGS = -Wall -Wextra
SRC = main.cpp
TARGET = main
CPPCHECK = cppcheck

.PHONY: all clean check

all: $(TARGET)

$(TARGET): $(SRC)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(SRC)

clean:
	rm -f $(TARGET)

check:
	@which $(CPPCHECK) > /dev/null && \
		$(CPPCHECK) $(SRC) || \
		(echo "cppcheck not found. You can obtain it at: https://cppcheck.sourceforge.io/#download" && \
		exit 1)
