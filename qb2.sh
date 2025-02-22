#!/bin/bash

echo "Please run this on Mac OS-X with GCC support for 'arm64-apple-macos12' and 'x86_64-apple-macos12'"

# Function to compile using `make` in a specified directory
compile_with_make() {
  local dir=$1
  local cflags=$2
  local out=$3
  (cd "$dir" && make CFLAGS+="$cflags" OUT="$out")
}

# Function to compile using Docker
compile_with_docker() {
  local docker_image=$1
  local input_file=$2
  local output_file=$3
  ./$docker_image bash -c "\$CC $input_file -o $output_file"
}

echo "Compiling C for Intel MacOS-X"
compile_with_make "c" "-target x86_64-apple-macos12" "../wrongsecrets-c"
compile_with_make "c/advanced" "-target x86_64-apple-macos12" "../../wrongsecrets-advanced-c"
compile_with_make "c/challenge52" "-target x86_64-apple-macos12" "../../wrongsecrets-challenge52-c"

echo "Compiling C for ARM MacOS-X"
compile_with_make "c" "-target arm64-apple-macos12" "../wrongsecrets-c-arm"
compile_with_make "c/advanced" "-target arm64-apple-macos12" "../../wrongsecrets-advanced-c-arm"
compile_with_make "c/challenge52" "-target arm64-apple-macos12" "../../wrongsecrets-challenge52-c-arm"

echo "Compiling C for ARM-Linux, based on https://github.com/dockcross/dockcross"
echo "Ensure the required Dockcross setup steps are completed beforehand."
compile_with_docker "dockcross-linux-arm64-lts" "c/main.c" "wrongsecrets-c-linux-arm"
compile_with_docker "dockcross-linux-arm64-lts" "c/advanced/advanced.c" "wrongsecrets-advanced-c-linux-arm"
compile_with_docker "dockcross-linux-arm64-lts" "c/challenge52/main.c" "wrongsecrets-challenge52-c-linux-arm"

echo "Compiling C for x64-Linux"
compile_with_docker "dockcross-linux-x64" "c/main.c" "wrongsecrets-c-linux"
compile_with_docker "dockcross-linux-x64" "c/advanced/advanced.c" "wrongsecrets-advanced-c-linux"
compile_with_docker "dockcross-linux-x64" "c/challenge52/main.c" "wrongsecrets-challenge52-c-linux"

echo "Compiling C for Windows statically linked X64 (EXE)"
compile_with_docker "dockcross-windows-static-x64" "c/main.c" "wrongsecrets-c-windows"
compile_with_docker "dockcross-windows-static-x64" "c/advanced/advanced.c" "wrongsecrets-advanced-c-windows"
compile_with_docker "dockcross-windows-static-x64" "c/challenge52/main.c" "wrongsecrets-challenge52-c-windows"


echo "Compiling C for Musl on ARM"
compile_with_docker "dockcross-linux-arm64-musl" "c/main.c" "wrongsecrets-c-linux-musl-arm"
compile_with_docker "dockcross-linux-arm64-musl" "c/advanced/advanced.c" "wrongsecrets-advanced-c-linux-musl-arm"
compile_with_docker "dockcross-windows-static-x64" "c/challenge52/main.c" "wrongsecrets-challenge52-c-linux-musl-arm"

echo "Compiling C for Musl on X86"
echo "Ensure the required Musl setup steps are completed beforehand."
x86_64-linux-musl-gcc c/main.c -o wrongsecrets-c-linux-musl -Wno-attributes
x86_64-linux-musl-gcc c/advanced/advanced.c -o wrongsecrets-advanced-c-linux-musl
x86_64-linux-musl-gcc c/challenge52/main.c -o wrongsecrets-challenge52-c-linux-musl

echo "stripping"
cp wrongsecrets-advanced-c wrongsecrets-advanced-c-stripped
strip -S wrongsecrets-advanced-c-stripped
cp wrongsecrets-advanced-c-arm wrongsecrets-advanced-c-arm-stripped
strip -S wrongsecrets-advanced-c-arm-stripped
cp wrongsecrets-advanced-c-linux wrongsecrets-advanced-c-linux-stripped
strip -S wrongsecrets-advanced-c-linux-stripped
cp wrongsecrets-advanced-c-linux-arm wrongsecrets-advanced-c-linux-arm-stripped
strip -S wrongsecrets-advanced-c-linux-arm-stripped
cp wrongsecrets-advanced-c-windows.exe wrongsecrets-advanced-c-windows-stripped.exe
strip -S wrongsecrets-advanced-c-windows-stripped.exe
cp wrongsecrets-advanced-c-linux-musl wrongsecrets-advanced-c-linux-musl-stripped
strip -S wrongsecrets-advanced-c-linux-musl-stripped
cp wrongsecrets-advanced-c-linux-musl-arm wrongsecrets-advanced-c-linux-musl-arm-stripped
strip -S wrongsecrets-advanced-c-linux-musl-arm-stripped

