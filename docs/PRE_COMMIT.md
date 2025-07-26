# Pre-commit Setup

This repository uses [pre-commit](https://pre-commit.com/) to automatically check code quality before commits. The pre-commit hooks help maintain consistent code style and catch common issues across all supported languages (C, C++, Rust, and Go).

## Installation

### Prerequisites
- Python 3.6+ (for pre-commit)
- Rust toolchain with `rustfmt` and `clippy`
- Go toolchain with `gofmt` and `go vet`
- GCC/Clang for C/C++ (development tools)

### Installing pre-commit

1. Install pre-commit:
   ```bash
   pip install pre-commit
   ```

2. Install the git hook scripts:
   ```bash
   pre-commit install
   ```

## What the hooks check

### For all languages:
- No very large files (>5MB)
- No merge conflict markers
- Basic file integrity

### Rust (in `rust/` directory):
- **rustfmt**: Code formatting according to Rust standards
- **clippy**: Rust linting for code quality and common mistakes

### Go (in `golang/` directory):
- **gofmt**: Code formatting according to Go standards
- **go vet**: Static analysis for common Go programming errors
- **go mod tidy**: Ensures go.mod and go.sum are clean and up-to-date

### C/C++ (in `c/` and `cplus/` directories):
- Basic file checks (placeholder for future clang-format integration)

## Usage

### Automatic (recommended)
Once installed, pre-commit will run automatically on every `git commit`. If any checks fail, the commit will be blocked until the issues are fixed.

### Manual execution
Run all hooks on all files:
```bash
pre-commit run --all-files
```

Run specific hooks:
```bash
pre-commit run rust-fmt
pre-commit run go-fmt
```

Run hooks on specific files:
```bash
pre-commit run --files rust/src/main.rs
```

### Bypassing hooks (not recommended)
In rare cases where you need to commit despite hook failures:
```bash
git commit --no-verify
```

## Fixing common issues

### Rust formatting issues
```bash
cd rust && cargo fmt
```

### Rust clippy warnings
Most clippy warnings should be fixed in the code. For educational/demonstration code that intentionally shows bad practices, you can add:
```rust
#[allow(clippy::specific_warning)]
```

### Go formatting issues
```bash
cd golang && gofmt -w .
```

### Go module issues
```bash
cd golang && go mod tidy
```

## CI/CD Integration

The pre-commit configuration is designed to work seamlessly with the existing GitHub Actions workflows. The same tools used in pre-commit are also used in CI to ensure consistency.

## Configuration

The pre-commit configuration is defined in `.pre-commit-config.yaml`. The current setup uses local hooks to avoid external dependencies and ensure cross-platform compatibility.

## Troubleshooting

### Network issues during installation
The current configuration uses only local hooks to avoid network dependency issues. If you encounter problems, try:
```bash
pre-commit clean
pre-commit install
```

### Tool not found errors
Ensure you have the required toolchains installed:
- For Rust: `cargo --version`, `rustfmt --version`, `cargo clippy --version`
- For Go: `go version`, `gofmt -help`

### Platform-specific issues
The configuration is tested on Linux, macOS, and Windows (via WSL). On Windows, ensure you're using a POSIX-compatible shell (Git Bash, WSL, or similar).