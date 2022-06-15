#include <iostream>

using namespace std;

string secret()
{
    return "Another secret in C++";
}

char *secret2()
{
    static char harder[22] = {'A', 'n', 'o', 't', 'h', 'e', 'r', ' ', 's', 'e', 'c', 'r', 'e', 't', ' ', 'i', 'n', ' ', 'C', ' ', '+', '+'};
    return harder;
}

void spoil()
{
    cout << secret();
}

int execute(string command)
{
    string spoil("spoil");
    if (spoil.compare(command) == 0)
    {
        cout << secret() + '\n';
        return 0;
    }
    else if (secret().compare(command) == 0)
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
        cout <<"Too many arguments supplied.\n";
    }
    else
    {
        cout << "Welcome to the wrongsecrets C++ binary which hides a secret.\n";
        cout << "Use args spoil or a string to guess the password.\n";
    }
}
