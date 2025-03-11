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


echo "Compiling C++"
echo "Compiling C++ for Intel Macos-X"
(cd cplus && make CXXFLAGS+='-target x86_64-apple-macos12' OUT='../wrongsecrets-cplus')
echo "Compiling C++ for ARM Macos-X"
(cd cplus && make CXXFLAGS+='-target arm64-apple-macos12' OUT='../wrongsecrets-cplus-arm')
echo "Compiling C++ for ARM, based on https://github.com/dockcross/dockcross"
./dockcross-linux-arm64-lts bash -c '$CC cplus/main.cpp -lstdc++ -o wrongsecrets-cplus-linux-arm'
echo "Compiling C++ for linux"
./dockcross-linux-x64 bash -c '$CC cplus/main.cpp -lstdc++ -o wrongsecrets-cplus-linux'
echo "Compiling C++ for Windows statically linked X64 (EXE)"
./dockcross-windows-static-x64 bash -c '$CC cplus/main.cpp -lstdc++ -o wrongsecrets-cplus-windows'
echo "Compiling C++ for musl based linux ARM"
./dockcross-linux-arm64-musl bash -c '$CC cplus/main.cpp -lstdc++  -o wrongsecrets-cplus-linux-musl-arm'
echo "Compiling C++ for musl based linux X86"
x86_64-linux-musl-gcc cplus/main.cpp -lstdc++ -o wrongsecrets-cplus-linux-musl

echo "compiling golang"
cd golang
echo "compiling golang for amd64 linux"
env GOOS=linux GOARCH=amd64 go build -o ../wrongsecrets-golang-linux
echo "compiling golang for arm linux"
env GOOS=linux GOARCH=arm64 go build -o ../wrongsecrets-golang-linux-arm
echo "compiling golang for mac os x (intel)"
env GOOS=darwin GOARCH=amd64 go build -o ../wrongsecrets-golang
echo "compiling golang for mac os x (ARM)"
env GOOS=darwin GOARCH=arm64 go build -o ../wrongsecrets-golang-arm
echo "compiling golang for Windows"
env GOOS=windows GOARCH=amd64 go build -o ../wrongsecrets-golang-windows.exe
cd ..

echo "compiling rust, requires 'cargo install -f cross'"
cd rust
rm ~/.cargo/config.toml
cargo install -f cross
rustup target add x86_64-apple-darwin
rustup target add aarch64-apple-darwin
rustup target add x86_64-pc-windows-gnu
rustup target add x86_64-unknown-linux-musl
rustup target add aarch64-unknown-linux-musl
rustup component add rust-std
rustup update
echo "compiling rust for amd64 linux"
cross build --target x86_64-unknown-linux-gnu --release
cp target/x86_64-unknown-linux-gnu/release/rust ../wrongsecrets-rust-linux
echo "compiling rust for aarch64 linux"
cross build --target aarch64-unknown-linux-gnu --release
cp target/aarch64-unknown-linux-gnu/release/rust ../wrongsecrets-rust-linux-arm
echo "compiling rust for x86-64 intel darwin (macOS) - requires 'rustup target add x86_64-apple-darwin'"
rustup target add x86_64-apple-darwin
cargo build --target x86_64-apple-darwin --release
cp target/x86_64-apple-darwin/release/rust ../wrongsecrets-rust
echo "compiling rust for ARM darwin (macOS) - requires 'rustup target add aarch64-apple-darwin'"
rustup target add aarch64-apple-darwin
cargo build --target aarch64-apple-darwin --release
cp target/aarch64-apple-darwin/release/rust ../wrongsecrets-rust-arm
echo "Compiling rust for Windows, here you need even more shizzle to work"
echo "pre-requirement: brew install mingw-w64"
rustup target add x86_64-pc-windows-gnu
cargo build --target=x86_64-pc-windows-gnu --release
cp target/x86_64-pc-windows-gnu/release/rust.exe ../wrongsecrets-rust-windows.exe
echo "compiling for musl linux (X86)"
cp ../config.toml ~/.cargo/config.toml
echo "for this you do need to follow https://stackoverflow.com/questions/72081987/cant-build-for-target-x86-64-unknown-linux-musl"
rustup target add x86_64-unknown-linux-musl
cargo build --target x86_64-unknown-linux-musl --release
cp target/x86_64-unknown-linux-musl/release/rust  ../wrongsecrets-rust-linux-musl
echo "compiling for musl linux (ARM)"
rustup target add aarch64-unknown-linux-musl
cargo build --target aarch64-unknown-linux-musl --release
cp target/aarch64-unknown-linux-musl/release/rust  ../wrongsecrets-rust-linux-musl-arm
cd ..

echo "compiling for .net: requires 'brew install dotnet' on MacOS"
cd dotnet/dotnetproject
dotnet build dotnetproject.csproj --runtime osx-x64 --self-contained true
dotnet publish dotnetproject.csproj --runtime osx-x64 /p:PublishSingleFile=true
cp ./bin/Release/net8.0/osx-x64/publish/dotnetproject ../../wrongsecrets-dotnet
dotnet build dotnetproject.csproj --runtime osx-arm64 --self-contained true
dotnet publish dotnetproject.csproj --runtime osx-arm64 /p:PublishSingleFile=true
cp ./bin/Release/net8.0/osx-arm64/publish/dotnetproject ../../wrongsecrets-dotnet-arm
dotnet build dotnetproject.csproj --runtime win-x64 --self-contained true
dotnet publish dotnetproject.csproj --runtime win-x64 /p:PublishSingleFile=true
cp ./bin/Release/net8.0/win-x64/publish/dotnetproject ../../wrongsecrets-dotnet-windows.exe
dotnet build dotnetproject.csproj --runtime win-arm64 --self-contained true
dotnet publish dotnetproject.csproj --runtime win-arm64 /p:PublishSingleFile=true
cp ./bin/Release/net8.0/win-arm64/publish/dotnetproject ../../wrongsecrets-dotnet-windows-arm
dotnet build dotnetproject.csproj --runtime linux-x64 --self-contained true
dotnet publish dotnetproject.csproj --runtime linux-x64 /p:PublishSingleFile=true
cp ./bin/Release/net8.0/linux-x64/publish/dotnetproject ../../wrongsecrets-dotnet-linux
dotnet build dotnetproject.csproj --runtime linux-arm64 --self-contained true
dotnet publish dotnetproject.csproj --runtime linux-arm64 /p:PublishSingleFile=true
cp ./bin/Release/net8.0/linux-arm64/publish/dotnetproject ../../wrongsecrets-dotnet-linux-arm
dotnet build dotnetproject.csproj --runtime linux-musl-x64 --self-contained true
dotnet publish dotnetproject.csproj --runtime linux-musl-x64 /p:PublishSingleFile=true
cp ./bin/Release/net8.0/linux-musl-x64/publish/dotnetproject ../../wrongsecrets-dotnet-linux-musl
dotnet build dotnetproject.csproj --runtime linux-musl-arm64 --self-contained true
dotnet publish dotnetproject.csproj --runtime linux-musl-arm64 /p:PublishSingleFile=true
cp ./bin/Release/net8.0/linux-musl-arm64/publish/dotnetproject ../../wrongsecrets-dotnet-linux-musl-arm
