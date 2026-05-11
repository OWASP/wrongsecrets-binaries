package io.github.owasp.wrongsecrets;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

/** Parity-contract smoke tests for the plain Java CLI. */
class WrongSecretsPlainTest {

  private static final String SECRET = "This is the secret in Java";

  private final ByteArrayOutputStream out = new ByteArrayOutputStream();
  private PrintStream original;

  @BeforeEach
  void redirectStdout() {
    original = System.out;
    System.setOut(new PrintStream(out));
  }

  @AfterEach
  void restoreStdout() {
    System.setOut(original);
  }

  private String run(String... args) {
    out.reset();
    WrongSecretsPlain.main(args);
    return out.toString().trim();
  }

  @Test
  void noArgsShowsWelcome() {
    String output = run();
    assertEquals(
        "Welcome to the wrongsecrets Java binary which hides a secret.\n"
            + "Use args spoil or a string to guess the password.",
        output);
  }

  @Test
  void spoilPrintsSecret() {
    assertEquals(SECRET, run("spoil"));
  }

  @Test
  void correctGuessCStyle() {
    assertEquals("This is correct! Congrats!", run(SECRET));
  }

  @Test
  void incorrectGuessCStyle() {
    assertEquals("This is incorrect. Try again", run("wrongguess"));
  }

  @Test
  void correctGuessGoStyle() {
    assertEquals("This is correct! Congrats!", run("guess", SECRET));
  }

  @Test
  void incorrectGuessGoStyle() {
    assertEquals("This is incorrect. Try again", run("guess", "wrongguess"));
  }

  @Test
  void tooManyArgsShowsError() {
    assertEquals("Too many arguments supplied.", run("a", "b", "c"));
  }
}
