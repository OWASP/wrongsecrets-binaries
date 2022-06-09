#!/bin/bash

echo "Compiling C-x86"
gcc c/main.c -o wrongsecrets-c
echo "Compiling C-ARM, based on https://github.com/dockcross/dockcross"
echo "prerequired: git clone https://github.com/dockcross/dockcross.git"
echo "prerequired: cd dockcross"
echo "prerequired: docker run --rm dockcross/linux-arm64 > ./dockcross-linux-arm64"
echo "prerequired: chmod +x ./dockcross-linux-arm64 && mv ./dockcross-linux-arm64 .. && cd .."
./dockcross-linux-arm64 bash -c '$CC c/main.c -o wrongsecrets-c-arm'
