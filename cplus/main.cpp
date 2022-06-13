#include <stdio.h>
#include <iostream>

using namespace std;

string secret() {
    return "This is a hardcoded secret in C";
}

char* secret2(){
    static char harder[31]={'T','h','i','s',' ','i','s',' ','a',' ','h','a','r','d','c','o','d','e','d',' ','s','e','c','r','e','t',' ','i','n',' ','C'};
    return harder;
}

void spoil(){
cout << secret();
}


int main(int argc, char *argv[]){

}

