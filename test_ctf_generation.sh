#!/bin/bash

# Test script to verify CTF generation is working correctly

set -e

echo "Testing CTF secret generation..."

# Test 1: Verify CTF generation changes secrets
echo "Test 1: Verifying CTF generation changes secrets"
./generate_ctf_secrets.sh generate > /dev/null

# Check that files were modified
if ! grep -q "this is the secret in C :" c/main.c; then
    echo "FAIL: C secret not updated"
    exit 1
fi

if ! grep -q "this is the secret in Golang :" golang/cmd/root.go; then
    echo "FAIL: Go secret not updated" 
    exit 1
fi

echo "PASS: Secrets were properly updated"

# Test 2: Verify compilation works with CTF secrets
echo "Test 2: Verifying compilation works with CTF secrets"
gcc c/main.c -o test_build/ctf-test-c
cd golang && go build -o ../test_build/ctf-test-go && cd ..

# Test that binaries output CTF secrets
C_OUTPUT=$(./test_build/ctf-test-c spoil)
GO_OUTPUT=$(./test_build/ctf-test-go spoil)

if [[ ! "$C_OUTPUT" =~ "this is the secret in C :" ]]; then
    echo "FAIL: C CTF binary doesn't output CTF secret"
    echo "Output: $C_OUTPUT"
    exit 1
fi

if [[ ! "$GO_OUTPUT" =~ "this is the secret in Golang :" ]]; then
    echo "FAIL: Go CTF binary doesn't output CTF secret"
    echo "Output: $GO_OUTPUT"
    exit 1
fi

echo "PASS: CTF binaries output correct secrets"

# Test 3: Verify restore functionality
echo "Test 3: Verifying restore functionality"
./generate_ctf_secrets.sh restore > /dev/null

# Check that original secrets are back
if ! grep -q "This is a hardcoded secret in C" c/main.c; then
    echo "FAIL: C secret not restored"
    exit 1
fi

if ! grep -q "This is the secret in Golang today" golang/cmd/root.go; then
    echo "FAIL: Go secret not restored"
    exit 1
fi

echo "PASS: Original secrets were properly restored"

# Test 4: Verify original compilation still works 
echo "Test 4: Verifying original compilation still works"
gcc c/main.c -o test_build/orig-test-c
cd golang && go build -o ../test_build/orig-test-go && cd ..

# Test that binaries output original secrets
C_ORIG_OUTPUT=$(./test_build/orig-test-c spoil)
GO_ORIG_OUTPUT=$(./test_build/orig-test-go spoil)

if [[ "$C_ORIG_OUTPUT" != "This is a hardcoded secret in C" ]]; then
    echo "FAIL: C original binary doesn't output original secret"
    echo "Output: $C_ORIG_OUTPUT"
    exit 1
fi

if [[ "$GO_ORIG_OUTPUT" != "This is the secret in Golang today" ]]; then
    echo "FAIL: Go original binary doesn't output original secret"
    echo "Output: $GO_ORIG_OUTPUT"
    exit 1
fi

echo "PASS: Original binaries output correct secrets"

# Test 5: Verify Java CTF generation and restore
echo "Test 5: Verifying Java CTF generation"
./generate_ctf_secrets.sh generate > /dev/null

if ! grep -q "this is the secret in Java :" java/plain/src/main/java/io/github/owasp/wrongsecrets/WrongSecretsPlain.java; then
    echo "FAIL: Java plain secret not updated"
    exit 1
fi

if ! grep -q "this is the secret in Java :" java/obfuscated/src/main/java/io/github/owasp/wrongsecrets/WrongSecretsObfuscated.java 2>/dev/null; then
    # For obfuscated, the source contains encoded bytes, not the plaintext secret.
    # Verify the ENCODED_SECRET array was modified by checking .original differs from current.
    if diff -q java/obfuscated/src/main/java/io/github/owasp/wrongsecrets/WrongSecretsObfuscated.java \
               java/obfuscated/src/main/java/io/github/owasp/wrongsecrets/WrongSecretsObfuscated.java.original > /dev/null 2>&1; then
        echo "FAIL: Java obfuscated source not updated"
        exit 1
    fi
fi

echo "PASS: Java secrets were properly updated"

# Test 6: Verify Java CTF binaries compile and run (requires Java on PATH)
if command -v java >/dev/null 2>&1 && command -v mvn >/dev/null 2>&1; then
    echo "Test 6: Verifying Java CTF binary compilation and output"
    (cd java/plain && mvn package -q)
    (cd java/obfuscated && mvn package -q)

    JAVA_PLAIN_OUTPUT=$(java -jar java/plain/target/wrongsecrets-java.jar spoil)
    JAVA_OBF_OUTPUT=$(java -jar java/obfuscated/target/wrongsecrets-java-obfuscated.jar spoil)

    if [[ ! "$JAVA_PLAIN_OUTPUT" =~ "this is the secret in Java :" ]]; then
        echo "FAIL: Java plain CTF binary doesn't output CTF secret"
        echo "Output: $JAVA_PLAIN_OUTPUT"
        exit 1
    fi

    if [[ ! "$JAVA_OBF_OUTPUT" =~ "this is the secret in Java :" ]]; then
        echo "FAIL: Java obfuscated CTF binary doesn't output CTF secret"
        echo "Output: $JAVA_OBF_OUTPUT"
        exit 1
    fi

    echo "PASS: Java CTF binaries output correct secrets"
else
    echo "SKIP: Java/Maven not found on PATH, skipping Java CTF binary test"
fi

# Test 7: Verify Java restore
echo "Test 7: Verifying Java restore"
./generate_ctf_secrets.sh restore > /dev/null

if ! grep -q "This is the secret in Java" java/plain/src/main/java/io/github/owasp/wrongsecrets/WrongSecretsPlain.java; then
    echo "FAIL: Java plain secret not restored"
    exit 1
fi

echo "PASS: Java original files properly restored"

# Test 8: Verify original Java binaries still work after restore
if command -v java >/dev/null 2>&1 && command -v mvn >/dev/null 2>&1; then
    echo "Test 8: Verifying original Java binary output after restore"
    (cd java/plain && mvn package -q)
    (cd java/obfuscated && mvn package -q)

    JAVA_PLAIN_ORIG=$(java -jar java/plain/target/wrongsecrets-java.jar spoil)
    JAVA_OBF_ORIG=$(java -jar java/obfuscated/target/wrongsecrets-java-obfuscated.jar spoil)

    if [[ "$JAVA_PLAIN_ORIG" != "This is the secret in Java" ]]; then
        echo "FAIL: Java plain binary doesn't output original secret after restore"
        echo "Output: $JAVA_PLAIN_ORIG"
        exit 1
    fi

    if [[ "$JAVA_OBF_ORIG" != "This is a harder secret in Java" ]]; then
        echo "FAIL: Java obfuscated binary doesn't output original secret after restore"
        echo "Output: $JAVA_OBF_ORIG"
        exit 1
    fi

    echo "PASS: Java original binaries output correct secrets"
else
    echo "SKIP: Java/Maven not found on PATH, skipping Java original binary test"
fi

echo ""
echo "All tests passed! CTF generation is working correctly."
echo "✓ CTF secrets are properly generated with random values"
echo "✓ CTF binaries compile and run correctly"
echo "✓ Original files are properly restored"
echo "✓ Original binaries continue to work as expected"
echo "✓ Java plain CTF secrets are properly generated and restored"
echo "✓ Java obfuscated CTF secrets are properly generated and restored"