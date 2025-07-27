#!/bin/bash

# Script to generate CTF versions of the binaries with randomized secrets
# Format: "this is the secret in <language> : <random string>"

set -e

# Function to generate a random string of specified length
generate_random_string() {
    local length=${1:-16}
    openssl rand -hex $((length/2)) 2>/dev/null || head /dev/urandom | tr -dc A-Za-z0-9 | head -c $length
}

# Function to backup original files
backup_original() {
    local file=$1
    if [ ! -f "${file}.original" ]; then
        cp "$file" "${file}.original"
    fi
}

# Function to restore original files
restore_original() {
    local file=$1
    if [ -f "${file}.original" ]; then
        cp "${file}.original" "$file"
    fi
}

# Generate random secret for each language with the specified format
C_SECRET="this is the secret in C : $(generate_random_string 16)"
CPLUS_SECRET="this is the secret in C++ : $(generate_random_string 16)"
GO_SECRET="this is the secret in Golang : $(generate_random_string 16)"
RUST_SECRET="this is the secret in Rust : $(generate_random_string 16)"
DOTNET_SECRET="this is the secret in dotnet : $(generate_random_string 16)"
SWIFT_SECRET="this is the secret in Swift : $(generate_random_string 16)"

echo "Generated CTF secrets:"
echo "C: $C_SECRET"
echo "C++: $CPLUS_SECRET"
echo "Go: $GO_SECRET"
echo "Rust: $RUST_SECRET"
echo ".NET: $DOTNET_SECRET"
echo "Swift: $SWIFT_SECRET"

# Function to update C source files
update_c_secrets() {
    echo "Updating C secrets..."
    
    # Update main.c
    backup_original "c/main.c"
    sed -i 's/This is a hardcoded secret in C/'"$C_SECRET"'/g' "c/main.c"
    
    # Update the character array in main.c
    # Convert the secret to character array format
    local char_array=""
    for (( i=0; i<${#C_SECRET}; i++ )); do
        char="$(printf '%s' "${C_SECRET:$i:1}")"
        if [ "$i" -eq 0 ]; then
            char_array="'$char'"
        else
            char_array="$char_array, '$char'"
        fi
    done
    
    # Update the character array size and content
    sed -i "s/static char harder\[31\] = {.*};/static char harder[${#C_SECRET}] = {$char_array};/" "c/main.c"
    
    # Update advanced/advanced.c if it exists
    if [ -f "c/advanced/advanced.c" ]; then
        backup_original "c/advanced/advanced.c"
        sed -i 's/This is a hardcoded secret in C/'"$C_SECRET"'/g' "c/advanced/advanced.c"
    fi
    
    # Update challenge52/main.c if it exists  
    if [ -f "c/challenge52/main.c" ]; then
        backup_original "c/challenge52/main.c"
        sed -i 's/This is a hardcoded secret in C/'"$C_SECRET"'/g' "c/challenge52/main.c"
    fi
}

# Function to update C++ source files
update_cplus_secrets() {
    echo "Updating C++ secrets..."
    
    backup_original "cplus/main.cpp"
    sed -i 's/Another secret in C++/'"$CPLUS_SECRET"'/g' "cplus/main.cpp"
    
    # Update the character array in C++
    local char_array=""
    for (( i=0; i<${#CPLUS_SECRET}; i++ )); do
        char="$(printf '%s' "${CPLUS_SECRET:$i:1}")"
        if [ "$i" -eq 0 ]; then
            char_array="'$char'"
        else
            char_array="$char_array, '$char'"
        fi
    done
    
    # Update the character array size and content
    sed -i "s/static char harder\[22\] = {.*};/static char harder[${#CPLUS_SECRET}] = {$char_array};/" "cplus/main.cpp"
}

# Function to update Go source files
update_go_secrets() {
    echo "Updating Go secrets..."
    
    backup_original "golang/cmd/root.go"
    sed -i 's/This is the secret in Golang today/'"$GO_SECRET"'/g' "golang/cmd/root.go"
}

# Function to update Rust source files
update_rust_secrets() {
    echo "Updating Rust secrets..."
    
    backup_original "rust/src/main.rs"
    sed -i 's/This is a not very random string posing as a secret in Rust/'"$RUST_SECRET"'/g' "rust/src/main.rs"
    
    # Update the character array in Rust
    local char_array=""
    for (( i=0; i<${#RUST_SECRET}; i++ )); do
        char="$(printf '%s' "${RUST_SECRET:$i:1}")"
        if [ "$i" -eq 0 ]; then
            char_array="'$char'"
        else
            char_array="$char_array, '$char'"
        fi
    done
    
    # Update the vec! content
    sed -i "s/vec!\[.*\]/vec![$char_array]/" "rust/src/main.rs"
}

# Function to update .NET source files
update_dotnet_secrets() {
    echo "Updating .NET secrets..."
    
    backup_original "dotnet/dotnetproject/Program.cs"
    sed -i 's/This is a dotnet secret, huray\./'"$DOTNET_SECRET"'/g' "dotnet/dotnetproject/Program.cs"
}

# Function to update Swift source files
update_swift_secrets() {
    echo "Updating Swift secrets..."
    
    backup_original "swift/Sources/main.swift"
    
    # Create character array format for Swift
    local char_array=""
    for (( i=0; i<${#SWIFT_SECRET}; i++ )); do
        char="$(printf '%s' "${SWIFT_SECRET:$i:1}")"
        if [ "$i" -eq 0 ]; then
            char_array="\"$char\""
        else
            char_array="$char_array, \"$char\""
        fi
    done
    
    # Update the character array in Swift
    sed -i "s/let CharArr: \[Character\] = \[.*\]/let CharArr: [Character] = [$char_array]/" "swift/Sources/main.swift"
}

# Function to restore all original files
restore_all() {
    echo "Restoring original files..."
    restore_original "c/main.c"
    restore_original "c/advanced/advanced.c"
    restore_original "c/challenge52/main.c"
    restore_original "cplus/main.cpp"
    restore_original "golang/cmd/root.go"
    restore_original "rust/src/main.rs"
    restore_original "dotnet/dotnetproject/Program.cs"
    restore_original "swift/Sources/main.swift"
}

# Main script logic
case "${1:-generate}" in
    "generate")
        echo "Generating CTF versions with randomized secrets..."
        update_c_secrets
        update_cplus_secrets
        update_go_secrets
        update_rust_secrets
        update_dotnet_secrets
        update_swift_secrets
        echo "CTF secrets generated successfully!"
        ;;
    "restore")
        restore_all
        echo "Original files restored!"
        ;;
    *)
        echo "Usage: $0 [generate|restore]"
        echo "  generate - Generate CTF versions with random secrets (default)"
        echo "  restore  - Restore original source files"
        exit 1
        ;;
esac