# macOS Code Signing and Notarization

This document describes the macOS code signing and notarization process implemented for the wrongsecrets-binaries repository.

## Overview

All macOS binaries built in this repository are automatically signed and notarized for distribution. This process ensures that macOS users can run the binaries without security warnings.

## Required Secrets

To enable code signing and notarization, the following repository secrets must be configured:

### Code Signing
- `APPLE_CERTIFICATE`: Base64 encoded Apple Developer certificate (.p12 file)
- `APPLE_CERTIFICATE_PASSWORD`: Password for the certificate

### Notarization  
- `APPLE_DEVELOPER_ID`: Apple ID (email) registered as a developer
- `APPLE_APP_PASSWORD`: App-specific password for the Apple ID
- `APPLE_TEAM_ID`: Apple Developer Team ID

## How It Works

1. **Conditional Execution**: The signing/notarization process only runs when the required secrets are available
2. **Code Signing**: Binaries are signed with the "Developer ID Application" certificate
3. **Notarization**: Signed binaries are submitted to Apple for automated security checks
4. **Stapling**: The notarization ticket is attached to the binary for offline verification

## Supported Languages

The following language workflows include macOS signing and notarization:

- Swift (universal binaries)
- Golang (Intel and ARM binaries)
- Rust (Intel binaries)
- C (Intel and ARM binaries)
- C++ (Intel and ARM binaries)
- .NET (osx-x64 and osx-arm64 binaries)

## Troubleshooting

If signing or notarization fails:

1. Check that all required secrets are properly configured
2. Verify that the Apple Developer certificate is valid and not expired
3. Ensure that the Apple ID has the necessary permissions for notarization
4. Check the workflow logs for specific error messages

## Manual Testing

To test the signing process locally:

1. Import your Developer ID certificate into Keychain
2. Sign a binary: `codesign --force --sign "Developer ID Application" --options runtime --timestamp your_binary`
3. Verify: `codesign --verify --verbose your_binary`
4. Notarize: `xcrun notarytool submit your_binary.zip --apple-id your@email.com --password your_app_password --team-id TEAM_ID --wait`
5. Staple: `xcrun stapler staple your_binary`