#include <stdio.h>
#include <string.h>

const char *secret()
{
    return "this is the secret in C : 2c6da22890671a59";
}

const char *secret2()
{
    static char harder[42] = {'t', 'h', 'i', 's', ' ', 'i', 's', ' ', 't', 'h', 'e', ' ', 's', 'e', 'c', 'r', 'e', 't', ' ', 'i', 'n', ' ', 'C', ' ', ':', ' ', '2', 'c', '6', 'd', 'a', '2', '2', '8', '9', '0', '6', '7', '1', 'a', '5', '9'};
    return harder;
}

int spoil()
{
    printf("%s\n", secret());
    return 0;
}

int compare(char *guess)
{
    int result = strcmp(secret(), guess);
    int result2 = strcmp(secret2(), guess);
    if (result == 0)
    {
        printf("This is correct! Congrats!\n");
    }
    else
    {
        printf("This is incorrect. Try again\n");
    }
    return result;
}

int execute(char *command)
{
    if (strcmp("spoil", command) == 0)
    {
        return spoil();
    }
    return compare(command);
}

int main(int argc, char *argv[])
{
    if (argc == 2)
    {
        execute(argv[1]);
    }

    else if (argc > 2)
    {
        printf("Too many arguments supplied.\n");
    }
    else
    {
        printf("Welcome to the wrongsecrets C binary which hides a secret.\n");
        printf("Use args spoil or a string to guess the password.\n");
    }
}