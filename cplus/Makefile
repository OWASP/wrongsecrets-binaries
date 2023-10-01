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
	$(CPPCHECK) $(SRC)