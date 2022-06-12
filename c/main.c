#include <stdio.h>
#include <string.h>

const char* secret() {
    return "This is a hardcoded secret in C";
}

const char* secret2(){
    static char harder[31]={'T','h','i','s',' ','i','s',' ','a',' ','h','a','r','d','c','o','d','e','d',' ','s','e','c','r','e','t',' ','i','n',' ','C'};
    return harder;
}



int spoil(){
    printf("%s", secret());
    return 0;
}

int compare(char* guess){
    int result = strcmp(secret(), guess);
    int result2 = strcmp(secret2(), guess);
    if (result==0){
        printf("This is correct! Congrats!");
    }else{
        printf("This is incorrect. Try again");
    }
    return result;
}

int execute(char* command){
    if (strcmp("spoil", command)==0){
        return spoil();
    }
    return compare(command);

}

int main( int argc, char *argv[] )  {
    if( argc == 2 ) {
        execute(argv[1]);
    }

    else if( argc > 2 ) {
        printf("Too many arguments supplied.\n");
   }
   else {
        printf("Welcome to the wrongsecrets C binary which hides a secret.\n");
        printf("Use args spoil or a string to guess the password.\n");
   }
}