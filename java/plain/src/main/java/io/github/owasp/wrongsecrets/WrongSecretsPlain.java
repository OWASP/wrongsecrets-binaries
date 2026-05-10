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

/**
 * Plain Java CLI for the WrongSecrets challenge.
 * Hides a secret that can be spoiled or guessed.
 *
 * <p>Usage:
 * <ul>
 *   <li>{@code spoil} — prints the secret</li>
 *   <li>{@code <guess>} — C-style: single argument compared to the secret</li>
 *   <li>{@code guess <guess>} — Go-style: subcommand with argument</li>
 * </ul>
 */
public class WrongSecretsPlain {

    private static final String SECRET = "This is the secret in Java";

    private static String getSecret() {
        return SECRET;
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
