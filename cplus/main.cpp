#include <iostream>

using namespace std;

class Secretcontainer
{                  // The class
private:           // Access specifier
    string secret; // Attribute (string variable)
public:
    void setSecret(string secretarg)
    {
        secret = secretarg;
    }
    string getSecret()
    {
        return secret;
    }
};

Secretcontainer secret()
{
    Secretcontainer container;
    container.setSecret("this is the secret in C++ : f07fd2bbb73526bd");
    return container;
}

char *secret2()
{
    static char harder[44] = {'t', 'h', 'i', 's', ' ', 'i', 's', ' ', 't', 'h', 'e', ' ', 's', 'e', 'c', 'r', 'e', 't', ' ', 'i', 'n', ' ', 'C', '+', '+', ' ', ':', ' ', 'f', '0', '7', 'f', 'd', '2', 'b', 'b', 'b', '7', '3', '5', '2', '6', 'b', 'd'};
    return harder;
}

void spoil()
{
    cout << secret().getSecret();
}

int execute(string command)
{
    string spoil("spoil");
    if (spoil.compare(command) == 0)
    {
        cout << secret().getSecret() + '\n';
        return 0;
    }
    else if (secret().getSecret().compare(command) == 0)
    {
        cout << "This is correct! Congrats!\n";
        return 0;
    }
    else
    {
        cout << "This is incorrect. Try again\n";
        return 1;
    }
}

int main(int argc, char *argv[])
{
    if (argc == 2)
    {
        execute(argv[1]);
    }
    else if (argc > 2)
    {
        cout << "Too many arguments supplied.\n";
    }
    else
    {
        cout << "Welcome to the wrongsecrets C++ binary which hides a secret.\n";
        cout << "Use args spoil or a string to guess the password.\n";
    }
}
