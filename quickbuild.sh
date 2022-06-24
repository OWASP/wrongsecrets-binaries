#!/bin/bash

echo "Compiling C-x86"
gcc c/main.c -o wrongsecrets-c
echo "Compiling C for ARM, based on https://github.com/dockcross/dockcross"
echo "prerequired: git clone https://github.com/dockcross/dockcross.git"
echo "prerequired: cd dockcross"
echo "prerequired: docker run --rm dockcross/linux-arm64-lts > ./dockcross-linux-arm64-lts"
echo "prerequired: chmod +x ./dockcross-linux-arm64-lts && mv ./dockcross-linux-arm64-lts .. && cd .."
./dockcross-linux-arm64-lts bash -c '$CC c/main.c -o wrongsecrets-c-arm'
echo "Compiling C for linux"
echo "prerequired: cd dockcross"
echo "prerequired: docker run --rm dockcross/linux-x64 > ./dockcross-linux-x64"
echo "prerequired: chmod +x ./dockcross-linux-x64 && mv ./dockcross-linux-x64 .. && cd .."
./dockcross-linux-x64 bash -c '$CC c/main.c -o wrongsecrets-c-linux'

echo "Compiling C++-X86"
gcc cplus/main.cpp -lstdc++ -o wrongsecrets-cplus
echo "Compiling C++ for ARM, based on https://github.com/dockcross/dockcross"
./dockcross-linux-arm64-lts bash -c '$CC cplus/main.cpp -lstdc++ -o wrongsecrets-cplus-arm'
echo "Compiling C++ for linux"
./dockcross-linux-x64 bash -c '$CC cplus/main.cpp -lstdc++ -o wrongsecrets-cplus-linux'

echo "compiling golang"
cd golang
env GOOS=linux GOARCH=amd64 go build -o ../wrongsecrets-golang-linux
env GOOS=linux GOARCH=arm64 go build -o ../wrongsecrets-golang-arm
env GOOS=darwin GOARCH=amd64 go build -o ../wrongsecrets-golang