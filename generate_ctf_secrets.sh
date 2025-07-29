#!/bin/bash

# Script to generate CTF versions of the binaries with randomized secrets
# Format: "this is the secret in <language> : <random string>"

set -e

# Function to generate a random string of specified length
generate_random_string() {
    local length=${1:-16}
    # Try multiple methods for cross-platform compatibility
    if command -v openssl >/dev/null 2>&1; then
        openssl rand -hex $((length/2)) 2>/dev/null
    elif [ -f /dev/urandom ]; then
        head /dev/urandom | tr -dc A-Za-z0-9 | head -c $length
    elif command -v python3 >/dev/null 2>&1; then
        python3 -c "import secrets; print(''.join(secrets.choice('0123456789abcdef') for _ in range($length)))"
    elif command -v python >/dev/null 2>&1; then
        python -c "import random; import string; print(''.join(random.choice(string.ascii_lowercase + string.digits) for _ in range($length)))"
    else
        # Fallback: use current timestamp and process ID
        echo "$RANDOM$RANDOM$RANDOM$RANDOM" | head -c $length
    fi
}

# Function to perform cross-platform sed replacement
sed_replace() {
    local file="$1"
    local pattern="$2"
    local replacement="$3"
    
    # Escape special characters for sed
    local escaped_replacement=$(printf '%s\n' "$replacement" | sed 's/[[\.*^$()+?{|]/\\&/g')
    
    # Use different sed syntax for macOS vs Linux
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS requires backup extension
        sed -i '.bak' "s/$pattern/$escaped_replacement/g" "$file"
        rm -f "${file}.bak"
    else
        # Linux/GNU sed
        sed -i "s/$pattern/$escaped_replacement/g" "$file"
    fi
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
    if [ -f "c/main.c" ]; then
        backup_original "c/main.c"
        sed_replace "c/main.c" "This is a hardcoded secret in C" "$C_SECRET"
        
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
        
        # Update the character array size and content with more robust pattern matching
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS sed
            sed -i '.bak' "s/static char harder\[[0-9]*\] = {[^}]*};/static char harder[${#C_SECRET}] = {$char_array};/" "c/main.c"
            rm -f "c/main.c.bak"
        else
            # Linux sed
            sed -i "s/static char harder\[[0-9]*\] = {[^}]*};/static char harder[${#C_SECRET}] = {$char_array};/" "c/main.c"
        fi
    else
        echo "Warning: c/main.c not found, skipping"
    fi
    
    # Update advanced/advanced.c if it exists
    if [ -f "c/advanced/advanced.c" ]; then
        backup_original "c/advanced/advanced.c"
        sed_replace "c/advanced/advanced.c" "This is a hardcoded secret in C" "$C_SECRET"
    fi
    
    # Update challenge52/main.c if it exists  
    if [ -f "c/challenge52/main.c" ]; then
        backup_original "c/challenge52/main.c"
        sed_replace "c/challenge52/main.c" "This is a hardcoded secret in C" "$C_SECRET"
    fi
}

# Function to update C++ source files
update_cplus_secrets() {
    echo "Updating C++ secrets..."
    
    if [ -f "cplus/main.cpp" ]; then
        backup_original "cplus/main.cpp"
        sed_replace "cplus/main.cpp" "Another secret in C++" "$CPLUS_SECRET"
        
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
        
        # Update the character array size and content with more robust pattern matching
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS sed
            sed -i '.bak' "s/static char harder\[[0-9]*\] = {[^}]*};/static char harder[${#CPLUS_SECRET}] = {$char_array};/" "cplus/main.cpp"
            rm -f "cplus/main.cpp.bak"
        else
            # Linux sed
            sed -i "s/static char harder\[[0-9]*\] = {[^}]*};/static char harder[${#CPLUS_SECRET}] = {$char_array};/" "cplus/main.cpp"
        fi
    else
        echo "Warning: cplus/main.cpp not found, skipping"
    fi
}

# Function to update Go source files
update_go_secrets() {
    echo "Updating Go secrets..."
    
    if [ -f "golang/cmd/root.go" ]; then
        backup_original "golang/cmd/root.go"
        sed_replace "golang/cmd/root.go" "This is the secret in Golang today" "$GO_SECRET"
    else
        echo "Warning: golang/cmd/root.go not found, skipping"
    fi
}

# Function to update Rust source files
update_rust_secrets() {
    echo "Updating Rust secrets..."
    
    if [ -f "rust/src/main.rs" ]; then
        backup_original "rust/src/main.rs"
        sed_replace "rust/src/main.rs" "This is a not very random string posing as a secret in Rust" "$RUST_SECRET"
        
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
        
        # Update the vec! content with more robust pattern matching
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS sed
            sed -i '.bak' "s/vec!\[[^]]*\]/vec![$char_array]/" "rust/src/main.rs"
            rm -f "rust/src/main.rs.bak"
        else
            # Linux sed
            sed -i "s/vec!\[[^]]*\]/vec![$char_array]/" "rust/src/main.rs"
        fi
    else
        echo "Warning: rust/src/main.rs not found, skipping"
    fi
}

# Function to update .NET source files
update_dotnet_secrets() {
    echo "Updating .NET secrets..."
    
    if [ -f "dotnet/dotnetproject/Program.cs" ]; then
        backup_original "dotnet/dotnetproject/Program.cs"
        sed_replace "dotnet/dotnetproject/Program.cs" "This is a dotnet secret, huray\\." "$DOTNET_SECRET"
    else
        echo "Warning: dotnet/dotnetproject/Program.cs not found, skipping"
    fi
}

# Function to update Swift source files
update_swift_secrets() {
    echo "Updating Swift secrets..."
    
    if [ -f "swift/Sources/main.swift" ]; then
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
        
        # Update the character array in Swift with more robust pattern matching
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS sed
            sed -i '.bak' "s/let CharArr: \[Character\] = \[[^]]*\]/let CharArr: [Character] = [$char_array]/" "swift/Sources/main.swift"
            rm -f "swift/Sources/main.swift.bak"
        else
            # Linux sed
            sed -i "s/let CharArr: \[Character\] = \[[^]]*\]/let CharArr: [Character] = [$char_array]/" "swift/Sources/main.swift"
        fi
    else
        echo "Warning: swift/Sources/main.swift not found, skipping"
    fi
}

# Function to restore all original files
restore_all() {
    echo "Restoring original files..."
    [ -f "c/main.c.original" ] && restore_original "c/main.c"
    [ -f "c/advanced/advanced.c.original" ] && restore_original "c/advanced/advanced.c"
    [ -f "c/challenge52/main.c.original" ] && restore_original "c/challenge52/main.c"
    [ -f "cplus/main.cpp.original" ] && restore_original "cplus/main.cpp"
    [ -f "golang/cmd/root.go.original" ] && restore_original "golang/cmd/root.go"
    [ -f "rust/src/main.rs.original" ] && restore_original "rust/src/main.rs"
    [ -f "dotnet/dotnetproject/Program.cs.original" ] && restore_original "dotnet/dotnetproject/Program.cs"
    [ -f "swift/Sources/main.swift.original" ] && restore_original "swift/Sources/main.swift"
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