# CTF Secret Generation

This repository now supports generating CTF (Capture The Flag) versions of all binaries with randomized secrets.

## How it works

The CTF generation system modifies the hardcoded secrets in the source code before compilation to create randomized versions suitable for CTF competitions. The format for CTF secrets is:

```
this is the secret in <language> : <random_hex_string>
```

For example:
- `this is the secret in C : d99bd60f17a05054`
- `this is the secret in Golang : 88b6c82d957d74c6`

## Usage

### Manual CTF Generation

Use the `generate_ctf_secrets.sh` script:

```bash
# Generate CTF secrets and modify source files
./generate_ctf_secrets.sh generate

# Restore original source files  
./generate_ctf_secrets.sh restore
```

### QuickBuild Script

The `quickbuild.sh` script automatically generates both regular and CTF versions:

```bash
# Build both regular and CTF versions (default)
./quickbuild.sh

# Build only regular versions
GENERATE_CTF=no ./quickbuild.sh
```

This creates binaries with the following naming convention:
- Regular: `wrongsecrets-<language>[-platform]`
- CTF: `wrongsecrets-<language>[-platform]-ctf`

### GitHub Actions

All GitHub Actions workflows automatically generate both regular and CTF versions of binaries. The CTF versions are included in the uploaded artifacts alongside the regular versions.

## Supported Languages

CTF generation works for all supported languages:
- C
- C++
- Go/Golang
- Rust  
- .NET/C#
- Swift

## Testing

Run the test suite to verify CTF generation is working:

```bash
./test_ctf_generation.sh
```

This tests:
- ✓ CTF secrets are properly generated with random values
- ✓ CTF binaries compile and run correctly
- ✓ Original files are properly restored
- ✓ Original binaries continue to work as expected

## Implementation Details

The CTF generation works by:

1. Creating backup copies of original source files (`.original` extension)
2. Replacing hardcoded secret strings with randomized CTF format strings
3. Updating character arrays and other representations of secrets
4. Compiling the modified sources
5. Restoring original files after compilation

The script handles various secret representations:
- Simple string literals
- Character arrays
- Multi-line definitions
- Language-specific patterns

## Binary Verification

You can verify CTF binaries work correctly:

```bash
# Generate CTF versions
./generate_ctf_secrets.sh generate

# Compile a CTF binary
gcc c/main.c -o wrongsecrets-c-ctf

# Test it outputs CTF secret
./wrongsecrets-c-ctf spoil
# Should output: this is the secret in C : <random_hex>

# Restore originals
./generate_ctf_secrets.sh restore
```