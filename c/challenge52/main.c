#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define SECRET_SIZE 32

char secret[SECRET_SIZE];

void generate_secret() {
    //rand() for a random secret
    snprintf(secret, SECRET_SIZE, "K8S_DEBUG_SECRET");
}

int handle_request() {
    sleep(10);  // Simulating a network call
    return 0;
}

int spoil()
{
    printf("%s\n", secret);
    return 0;
}

int execute(char *command)
{
    if (strcmp("spoil", command) == 0)
    {
        return spoil();
    }
    return handle_request();
}


int main(int argc, char *argv[]) {
    generate_secret();
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
        printf("This app now will go into sleep pretending to be a server app\n");
        while (1) {
            handle_request();
        }
    }
    
    return 0;
}
