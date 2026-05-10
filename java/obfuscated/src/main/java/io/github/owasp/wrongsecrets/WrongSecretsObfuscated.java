/*
MIT License

Copyright (c) 2020-2022 Jeroen Willemsen and WrongSecret contributors.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
package io.github.owasp.wrongsecrets;

import java.lang.reflect.Method;
import java.nio.charset.StandardCharsets;

/**
 * Obfuscated Java CLI for the WrongSecrets challenge.
 *
 * <p>The secret is stored XOR-encoded with a repeating key and is retrieved at runtime via
 * reflection, making static analysis and string-extraction harder.
 *
 * <p>Usage:
 * <ul>
 *   <li>{@code spoil} — prints the secret</li>
 *   <li>{@code <guess>} — C-style: single argument compared to the secret</li>
 *   <li>{@code guess <guess>} — Go-style: subcommand with argument</li>
 * </ul>
 */
public class WrongSecretsObfuscated {

    // XOR key stored as a char array to avoid direct string extraction from the binary
    private static final char[] XOR_KEY_CHARS = {
        'W', 'r', 'o', 'n', 'g', 'S', 'e', 'c', 'r', 'e', 't', 's', '!', '@', '#', '$'
    };

    // Secret "This is a harder secret in Java" XOR-encoded with XOR_KEY_CHARS (repeating).
    // Update this array via generate_ctf_secrets.sh when generating CTF variants.
    private static final byte[] ENCODED_SECRET = {
        (byte)0x03, (byte)0x1a, (byte)0x06, (byte)0x1d, (byte)0x47, (byte)0x3a, (byte)0x16, (byte)0x43,
        (byte)0x13, (byte)0x45, (byte)0x1c, (byte)0x12, (byte)0x53, (byte)0x24, (byte)0x46, (byte)0x56,
        (byte)0x77, (byte)0x01, (byte)0x0a, (byte)0x0d, (byte)0x15, (byte)0x36, (byte)0x11, (byte)0x43,
        (byte)0x1b, (byte)0x0b, (byte)0x54, (byte)0x39, (byte)0x40, (byte)0x36, (byte)0x42
    };

    /**
     * Decodes the XOR-encoded secret using the repeating key.
     * This method is intentionally named to look like an internal helper;
     * it is only invoked via reflection from {@link #getSecret()}.
     */
    @SuppressWarnings("unused")
    private static String decodeSecret() {
        byte[] key = new byte[XOR_KEY_CHARS.length];
        for (int i = 0; i < XOR_KEY_CHARS.length; i++) {
            key[i] = (byte) XOR_KEY_CHARS[i];
        }
        byte[] decoded = new byte[ENCODED_SECRET.length];
        for (int i = 0; i < ENCODED_SECRET.length; i++) {
            decoded[i] = (byte) (ENCODED_SECRET[i] ^ key[i % key.length]);
        }
        return new String(decoded, StandardCharsets.UTF_8);
    }

    /**
     * Retrieves the secret via reflection to add an additional layer of obfuscation.
     */
    private static String getSecret() {
        try {
            Method method = WrongSecretsObfuscated.class.getDeclaredMethod("decodeSecret");
            method.setAccessible(true);
            return (String) method.invoke(null);
        } catch (Exception e) {
            return "";
        }
    }

    public static void main(String[] args) {
        if (args.length == 0) {
            System.out.println("Welcome to the wrongsecrets Java binary which hides a secret.");
            System.out.println("Use args spoil or a string to guess the password.");
        } else if (args.length == 1) {
            if ("spoil".equals(args[0])) {
                System.out.println(getSecret());
            } else {
                // C-style: single argument treated as the guess
                if (getSecret().equals(args[0])) {
                    System.out.println("This is correct! Congrats!");
                } else {
                    System.out.println("This is incorrect. Try again");
                }
            }
        } else if (args.length == 2 && "guess".equals(args[0])) {
            // Go-style: guess <value>
            if (getSecret().equals(args[1])) {
                System.out.println("This is correct! Congrats!");
            } else {
                System.out.println("This is incorrect. Try again");
            }
        } else {
            System.out.println("Too many arguments supplied.");
        }
    }
}
