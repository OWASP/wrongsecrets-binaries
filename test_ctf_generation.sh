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

echo ""
echo "All tests passed! CTF generation is working correctly."
echo "✓ CTF secrets are properly generated with random values"
echo "✓ CTF binaries compile and run correctly"
echo "✓ Original files are properly restored"
echo "✓ Original binaries continue to work as expected"