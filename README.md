# wrongsecrets-binaries

[![Compile C](https://github.com/OWASP/wrongsecrets-binaries/actions/workflows/compile_c.yml/badge.svg)](https://github.com/OWASP/wrongsecrets-binaries/actions/workflows/compile_c.yml)
[![ Compile CPlus](https://github.com/OWASP/wrongsecrets-binaries/actions/workflows/compile_cplus.yml/badge.svg)](https://github.com/OWASP/wrongsecrets-binaries/actions/workflows/compile_cplus.yml) 
[![Compile GoLang](https://github.com/OWASP/wrongsecrets-binaries/actions/workflows/compile_golang.yml/badge.svg)](https://github.com/OWASP/wrongsecrets-binaries/actions/workflows/compile_golang.yml)
[![Compile Rust](https://github.com/OWASP/wrongsecrets-binaries/actions/workflows/compile_rust.yml/badge.svg)](https://github.com/OWASP/wrongsecrets-binaries/actions/workflows/compile_rust.yml)
[![dotnet package](https://github.com/OWASP/wrongsecrets-binaries/actions/workflows/compile_dotnet.yml/badge.svg)](https://github.com/OWASP/wrongsecrets-binaries/actions/workflows/compile_dotnet.yml)
[![Compile Swift](https://github.com/OWASP/wrongsecrets-binaries/actions/workflows/compile_swift.yml/badge.svg)](https://github.com/OWASP/wrongsecrets-binaries/actions/workflows/compile_swift.yml)
[![Security Scanning](https://github.com/OWASP/wrongsecrets-binaries/actions/workflows/security-scanning.yml/badge.svg)](https://github.com/OWASP/wrongsecrets-binaries/actions/workflows/security-scanning.yml)

This is a supportive repository for [OWASP WrongSecrets](https://github.com/OWASP/wrongsecrets).
Here we create our binaries which are included in the official project.
Want to add a challenge related to secrets hiding in binary? Open a ticket at [WrongSecrets issues](https://github.com/OWASP/wrongsecrets/issues). 
Want to fix something you found in one of the binaries: open a ticket or a PR here.

## CTF Support

This repository now supports generating **CTF (Capture The Flag) versions** of all binaries with randomized secrets. CTF versions use the format `this is the secret in <language> : <random_hex>` instead of static secrets, making them suitable for CTF competitions.

- **Automatic Generation**: Both `quickbuild.sh` and GitHub Actions generate CTF versions alongside regular binaries
- **All Languages**: Supports C, C++, Go, Rust, .NET, and Swift
- **Easy Testing**: Use `./test_ctf_generation.sh` to verify functionality

See [docs/CTF_GENERATION.md](docs/CTF_GENERATION.md) for detailed usage instructions.

## Development

This repository uses [pre-commit lite](https://pre-commit.com/) with **automated code formatting** to maintain code quality with minimal friction. The lightweight configuration automatically fixes formatting issues for Rust and Go code. See [docs/PRE_COMMIT.md](docs/PRE_COMMIT.md) for setup instructions.

## Security Scanning

This repository includes comprehensive security scanning using GitHub's free tools:

### CodeQL Analysis
- **Languages Covered**: C, C++, Go, C#/.NET, Swift
- **Triggers**: Push to main/master, pull requests, manual dispatch, weekly schedule
- **Integration**: Results automatically uploaded to GitHub Security tab

### Semgrep Analysis
- **Languages Covered**: All languages (C, C++, Go, Rust, C#/.NET, Swift)
- **Rulesets**: 
  - OWASP Top 10 security issues
  - CWE Top 25 vulnerabilities
  - Secrets detection
  - General security audit rules
- **Integration**: SARIF results uploaded to GitHub Security tab

### Viewing Security Results
Security scan results are available in the repository's **Security** tab under **Code scanning alerts**. The scans run automatically on code changes and weekly on Sundays at 3 AM UTC.

## Special thanks

### Contributors:

Leaders:

-   [Ben de Haan @bendehaan](https://github.com/bendehaan)
-   [Jeroen Willemsen @commjoen](https://github.com/commjoen)

Top contributors:

-   [Puneeth Y @puneeth072003](https://github.com/puneeth072003)
-   [Rodolfo Cabral Neves @roddas](https://github.com/roddas)
-   [Diamond Rivero @diamant3](https://github.com/diamant3)
-   [Joss Sparkes @remakingeden](https://github.com/remakingeden)


### Sponsorships:

We would like to thank the following parties for helping us out:

[![gitguardian_logo.png](images/gitguardian_logo.jpeg)](https://blog.gitguardian.com/gitguardian-is-proud-sponsor-of-owasp/)

[GitGuardian](https://blog.gitguardian.com/gitguardian-is-proud-sponsor-of-owasp/) for their sponsorship which allows us to pay the bills for our cloud-accounts.

[![jetbrains_logo.png](images/jetbrains_logo.png)](https://www.jetbrains.com/)

[Jetbrains](https://www.jetbrains.com/) for licensing an instance of Intellij IDEA Ultimate edition to the project leads. We could not have been this fast with the development without it!

[![docker_logo.png](images/docker_logo.png)](https://www.docker.com)

[Docker](https://www.docker.com) for granting us their Docker Open Source Sponsored program.

[![1password_logo.png](images/1password_logo.png)](https://github.com/1Password/1password-teams-open-source/pull/552)

[1Password](https://github.com/1Password/1password-teams-open-source/pull/552) for granting us an open source license to 1Password for the secret detection testbed.

## Copyrights

Copyright (c) 2020-2025 Jeroen Willemsen and WrongSecret contributors.