# Pre-commit Lite - Automated Code Formatting

This repository uses [pre-commit](https://pre-commit.com/) with a **lightweight configuration** that automatically fixes code formatting issues. The pre-commit hooks focus on auto-formatting rather than strict checking, making development smoother while maintaining code consistency.

## Installation

### Prerequisites
- Python 3.6+ (for pre-commit)
- Rust toolchain with `rustfmt` (for Rust auto-formatting)
- Go toolchain with `gofmt` (for Go auto-formatting)

### Installing pre-commit

1. Install pre-commit:
   ```bash
   pip install pre-commit
   ```

2. Install the git hook scripts:
   ```bash
   pre-commit install
   ```

## What the hooks do

**Auto-fixes applied:**
- **Rust**: Automatically formats code using `rustfmt`
- **Go**: Automatically formats code using `gofmt` and tidies modules with `go mod tidy`

**Safety checks (non-intrusive):**
- Detects merge conflict markers in source files

## Key Benefits

✅ **Automatic fixes** - No need to manually run formatting commands  
✅ **Lightweight** - Only essential formatting and basic safety checks  
✅ **Non-blocking** - Focuses on fixes rather than strict linting  
✅ **Cross-platform** - Works on Linux, macOS, and Windows

## Usage

### Automatic (recommended)
Once installed, pre-commit will run automatically on every `git commit` and **automatically fix** formatting issues. The fixed files will be staged automatically, so you just need to commit again.

### Manual execution
Auto-fix all files:
```bash
pre-commit run --all-files
```

Run specific auto-fixes:
```bash
pre-commit run rust-fmt-fix    # Auto-format Rust code
pre-commit run go-fmt-fix      # Auto-format Go code
pre-commit run go-mod-tidy     # Clean Go modules
```

### Bypassing hooks (not recommended)
In rare cases where you need to commit despite hook failures:
```bash
git commit --no-verify
```

## No Manual Fixes Needed!

With pre-commit lite, formatting issues are **automatically fixed** for you:

- **Rust**: Code is auto-formatted with `rustfmt`
- **Go**: Code is auto-formatted with `gofmt` and modules are tidied

If the pre-commit hooks make changes, just run `git add .` and `git commit` again.

## CI/CD Integration

The pre-commit configuration is designed to work seamlessly with the existing GitHub Actions workflows. The same tools used in pre-commit are also used in CI to ensure consistency.

## Configuration

The pre-commit configuration is defined in `.pre-commit-config.yaml`. This "lite" setup focuses on:

- **Auto-formatting** rather than strict checking
- **Minimal dependencies** for easy setup
- **Cross-platform compatibility** using local hooks
- **Essential checks only** (merge conflict detection)

## Troubleshooting

### Network issues during installation
The current configuration uses only local hooks to avoid network dependency issues. If you encounter problems, try:
```bash
pre-commit clean
pre-commit install
```

### Tool not found errors
Ensure you have the required toolchains installed:
- For Rust: `cargo --version`, `rustfmt --version`
- For Go: `go version`, `gofmt -help`

### Platform-specific issues
The configuration is tested on Linux, macOS, and Windows (via WSL). On Windows, ensure you're using a POSIX-compatible shell (Git Bash, WSL, or similar).