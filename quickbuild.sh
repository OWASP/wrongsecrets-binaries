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

echo "compiling Swfit, requires macos on x86 or arm" #https://www.swift.org/documentation/server/guides/building.html
cd swift
echo "compiling for MacOS arm and intel (fat binary)"
swift build -c release --product swift --triple arm64-apple-macosx
swift build -c release --product swift --triple x86_64-apple-macosx
lipo .build/arm64-apple-macosx/debug/swift .build/x86_64-apple-macosx/debug/swift -create -output swift.universal
cp swift.universal ../wrongsecrets-swift
cp swift.universal ../wrongsecrets-swift-arm

echo "Compiling for Linux (glibc)"
docker run -v "$PWD:." -w /sources --platform linux/arm64 swift:latest swift run -c release --static-swift-stdlib
cp .build/aarch64-unknown-linux-gnu/release/swift ../wrongsecrets-swift-linux-arm
docker run -v "$PWD:/sources" -w /sources --platform linux/amd64 swift:latest swift run -c release 
cp .build/x86_64-unknown-linux-gnu/release/swift ../wrongsecrets-swift-linux 
echo "Windows is receivable via the windows runner"
echo "Compiling swift for linux"
swift sdk install https://download.swift.org/swift-6.0.3-release/static-sdk/swift-6.0.3-RELEASE/swift-6.0.3-RELEASE_static-linux-0.0.1.artifactbundle.tar.gz --checksum 67f765e0030e661a7450f7e4877cfe008db4f57f177d5a08a6e26fd661cdd0bd
echo "below works only when you install the developer toolchain"
export PATH=/Library/Developer/Toolchains/swift-6.0.3-RELEASE.xctoolchain/usr/bin:$PATH
swift build --swift-sdk aarch64-swift-linux-musl
swift build --swift-sdk x86_64-swift-linux-musl
cp .build/aarch64-unknown-linux-gnu/release/swift ../wrongsecrets-swift-linux-musl-arm
cp .build/x86_64-unknown-linux-gnu/release/swift ../wrongsecrets-swift-linux-musl
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
