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
    container.setSecret("Another secret in C++");
    return container;
}

char *secret2()
{
    static char harder[22] = {'A', 'n', 'o', 't', 'h', 'e', 'r', ' ', 's', 'e', 'c', 'r', 'e', 't', ' ', 'i', 'n', ' ', 'C', ' ', '+', '+'};
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
