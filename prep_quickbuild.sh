#!/bin/bash

ehco "this script is to prepare your mac to be able to run quickbuild.sh"

echo "preparing dockcross"
git clone https://github.com/dockcross/dockcross.git
cd dockcross
docker run --rm dockcross/linux-arm64-lts > ./dockcross-linux-arm64-lts
chmod +x ./dockcross-linux-arm64-lts && mv ./dockcross-linux-arm64-lts ..
docker run --rm dockcross/linux-x64 > ./dockcross-linux-x64
chmod +x ./dockcross-linux-x64 && mv ./dockcross-linux-x64 ..
docker run --rm dockcross/windows-static-x64 > ./dockcross-windows-static-x64
chmod +x ./dockcross-windows-static-x64 && mv ./dockcross-windows-static-x64 ..
docker run --rm dockcross/linux-arm64-musl > ./dockcross-linux-arm64-musl
chmod +x ./dockcross-linux-arm64-musl && mv ./dockcross-linux-arm64-musl ..

echo "preparing musl cross, which requires brew to be installed"
brew install FiloSottile/musl-cross/musl-cross
ln -s /usr/local/opt/musl-cross/bin/x86_64-linux-musl-gcc /usr/local/bin/musl-gcc


echo "preparing golang"
brew install go

echo "preparing rust"
brew install rust
cargo install -f cross
rustup target add x86_64-apple-darwin
rustup target add aarch64-apple-darwin
rustup target add x86_64-pc-windows-gnu
rustup target add x86_64-unknown-linux-musl
rustup target add aarch64-unknown-linux-musl
rustup component add rust-std
rustup update


echo "preparing dotnet"
brew install dotnet

echo "preparing swift"
brew install swift
swift sdk install \
  https://download.swift.org/swift-6.3.3-release/static-sdk/swift-6.3.3-RELEASE/swift-6.3.3-RELEASE_static-linux-0.1.0.artifactbundle.tar.gz \
  --checksum 87c3eaf908e67c0e13a84367119e12273cec1d2cd3d81f7d74bb36722d6b607b
curl -O https://download.swift.org/swiftly/darwin/swiftly.pkg
installer -pkg swiftly.pkg -target CurrentUserHomeDirectory

~/.swiftly/bin/swiftly init --quiet-shell-followup
source ~/.swiftly/env.sh
hash -r
swiftly install 6.3.3
swiftly use 6.3.3
PROFILE="$HOME/.zshrc"
LINE='export PATH="$HOME/Library/Developer/Toolchains/swift-6.3.3-RELEASE.xctoolchain/usr/bin:$PATH"'

grep -qxF "$LINE" "$PROFILE" 2>/dev/null || echo "$LINE" >> "$PROFILE"

echo "preparing java"
brew install openjdk maven
