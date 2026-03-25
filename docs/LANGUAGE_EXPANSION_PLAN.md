# Language Expansion Plan (Alpine-First)

## Objective

Expand this repository with three additional language binaries while preserving behavioral parity with existing binaries:

- `spoil`: reveal the language-specific secret
- guess flow: compare user input against the secret and return success/failure semantics aligned with existing binaries

Priority is based on Alpine Linux compatibility.

## Target Languages (Top 3)

1. Zig (highest Alpine compatibility, lowest delivery risk)
2. Nim (strong Alpine compatibility, moderate setup effort)
3. Java (most popular ecosystem, Alpine-first via native path)

## Non-Negotiable Parity Contract (All New Languages)

Each language implementation must match existing binaries for command behavior and user experience.

Current source of truth for behavior:

1. C baseline in `c/main.c`
   - `spoil` prints the secret.
   - Any non-`spoil` single argument is treated as the guess value.
2. Go baseline in `golang/cmd/*.go`
   - `spoil` subcommand prints the secret.
   - `guess <value>` subcommand performs comparison.

### Required methods and command compatibility

1. `spoil`
   - Prints the language-specific secret.
2. Guess capability
   - Must support at least one current style:
     - C style: `<binary> <guess>`
     - Go style: `<binary> guess <guess>`
   - Preferred for new languages: support both styles for cross-binary consistency.

### CLI behavior

1. `spoil` output must print only the secret value plus newline.
2. Guess success message must be: `This is correct! Congrats!`
3. Guess failure message must be: `This is incorrect. Try again`
4. Help/usage text should reflect accepted guess style(s).
5. Exit code behavior must remain consistent:
   - Success path returns `0`.
   - Mismatch and invalid usage follow current binary conventions per chosen style.

### Secret behavior

1. Normal mode:
   - Uses deterministic static secret per language.
2. CTF mode:
   - Uses randomized secret string generated in repository format.
3. Output phrasing:
   - Keep wording and tone aligned with existing binaries where practical.

## Cross-Cutting Implementation Requirements

Apply these to Zig, Nim, and Java.

1. Build and artifacts
   - Add build steps to local build scripts.
   - Add dedicated CI compile workflow(s).
   - Follow existing artifact naming conventions for normal and `-ctf` binaries.
2. CTF integration
   - Extend secret generation script to support each language in generate mode.
   - Extend restore flow to restore original source values for each language.
3. Tests
   - Add smoke tests for:
     - `spoil` output
       - guess success
       - guess failure
       - (if dual-style implemented) both C style and Go style guess invocation
   - Add CTF generate/restore verification for each new language.
4. Documentation
   - Update language matrix and workflow references in README once each language is shipped.

## Phase Plan

## Phase 1: Zig

### Why first

- Best fit for Alpine/musl-native targets.
- Typically easiest to produce small static binaries.

### Deliverables

1. New Zig source module with `spoil` and guess behavior.
2. Linux musl binaries for:
   - x64
   - arm64
3. CI workflow for Zig compile and artifact upload.
4. CTF support wired into generation and restore scripts.
5. Basic test coverage for parity contract.

### Suggested artifacts

- `wrongsecrets-zig-linux-musl`
- `wrongsecrets-zig-linux-musl-arm`
- `wrongsecrets-zig-linux-musl-ctf`
- `wrongsecrets-zig-linux-musl-arm-ctf`

### Exit criteria

1. CI publishes normal and CTF Zig artifacts.
2. Zig command behavior matches parity contract.
3. Alpine runtime validation succeeds for both targets.

## Phase 2: Nim

### Why second

- Good Alpine path via native compilation with musl-compatible toolchains.
- Moderate complexity and useful language diversity.

### Deliverables

1. New Nim source module with `spoil` and guess behavior.
2. Linux musl binaries for:
   - x64
   - arm64
3. CI workflow for Nim compile and artifact upload.
4. CTF support and restore integration.
5. Basic parity tests in normal and CTF modes.

### Suggested artifacts

- `wrongsecrets-nim-linux-musl`
- `wrongsecrets-nim-linux-musl-arm`
- `wrongsecrets-nim-linux-musl-ctf`
- `wrongsecrets-nim-linux-musl-arm-ctf`

### Exit criteria

1. CI publishes normal and CTF Nim artifacts.
2. Nim command behavior matches parity contract.
3. Alpine runtime validation succeeds for both targets.

## Phase 3: Java

### Why third

- Most popular ecosystem option.
- Alpine path can be more variable depending on native-image toolchain setup.

### Alpine strategy (required decision gate)

1. Preferred:
   - GraalVM native-image with musl target.
2. Fallback:
   - JVM artifact (JAR) validated on Alpine JRE if native-image stability is insufficient.

### Deliverables

1. Java module with `spoil` and guess behavior.
2. Alpine-compatible runtime artifact path:
   - Native binary (preferred), or
   - JAR fallback with Alpine execution validation.
3. CI workflow for build and artifact upload.
4. CTF support and restore integration.
5. Basic parity tests for normal and CTF modes.

### Suggested artifacts (native preferred)

- `wrongsecrets-java-linux-musl`
- `wrongsecrets-java-linux-musl-arm`
- `wrongsecrets-java-linux-musl-ctf`
- `wrongsecrets-java-linux-musl-arm-ctf`

### Fallback artifacts (if JVM path)

- `wrongsecrets-java.jar`
- `wrongsecrets-java-ctf.jar`

### Exit criteria

1. CI publishes Java artifacts with clear Alpine execution path.
2. Java command behavior matches parity contract.
3. CTF flow and restore flow pass.

## Validation Matrix

For each language and architecture target:

1. Build success in CI.
2. Artifact published with expected name.
3. `spoil` returns expected secret format.
4. guess returns expected success with valid secret.
5. guess returns expected failure with invalid secret.
6. If dual-style is supported, both invocation styles are validated.
7. CTF generate updates source/binary outputs.
8. CTF restore restores original source behavior.
9. Alpine execution verified.

## Milestones and Sequence

1. Milestone A: Zig complete (normal + CTF + Alpine validation).
2. Milestone B: Nim complete (normal + CTF + Alpine validation).
3. Milestone C: Java complete (native preferred; JVM fallback if needed).
4. Milestone D: README/workflow matrix updates and final consistency pass.

## Risks and Mitigations

1. Risk: Toolchain instability for cross-arch musl builds.
   - Mitigation: Start with x64 musl baseline, then arm64; pin toolchain versions in CI.
2. Risk: Behavior drift across language CLIs.
   - Mitigation: Reuse a shared parity test checklist and command contract.
3. Risk: Java native-image complexity on Alpine.
   - Mitigation: Timebox native-image setup and use documented JVM fallback.

## Definition of Done

All three languages are considered complete only when:

1. Normal and CTF artifacts exist.
2. `spoil` and guess behavior matches existing binaries.
3. Alpine-compatible execution path is validated and documented.
4. CI workflows are stable and reproducible.
5. Docs and language matrix are updated.
