#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SIZE 21

char *decode(const char ** )__attribute__((visibility("hidden")));
void usage(char *)__attribute__((visibility("hidden")));
void execute(char *)__attribute__((visibility("hidden")));
void spoil(void)__attribute__((visibility("hidden")));
char *xor(char *, int )__attribute__((visibility("hidden")));

const char *secret[] = {"69","67","6f","74","68","61","63","6b","65","64","62","79","73","65","63","72","65","74","70","77","64"};

int main(int argc, char **argv)
{	
	if(argc < 2)
	{
		usage(argv[0]);
	}
	
	execute(argv[1]);
	
	return EXIT_SUCCESS;
}
char *xor(char *string, int key)
{
	int size = strlen(string);
	char *ret = (char *)calloc(strlen(string),sizeof(int));
	
	for(int a = 0; a < size;a++)
		ret[a] = string[a] ^ key;
	
	return ret;
}
void spoil(void)
{
	printf("This is a hardcoded secret game in C\n");
	exit(EXIT_SUCCESS);
}
void usage(char *string)
{
	printf("Usage: %s [PASSWORD]\n",string);
	printf("Usage: %s spoil \n",string);
	exit(EXIT_FAILURE);
}
void execute(char *command)
{
	if(strcmp(command,"spoil") == 0)
	{
		spoil();
		return;
	}
	if(strcmp(command,xor(decode(secret),2)) == 0 )
	{
		printf("root:~# You're root :-D\n");
	}
	else if(strcmp(command,decode(secret)) == 0)
	{
		puts("You're almost there champion! Here's two hints: ");
		puts("#1: How many different elements there exists in a binary set ?");
		puts("#2: You can have a computer or bike, but cannot have both.");
	}
	else
	{
		puts("Try again");
	}
}
char *decode(const char **string)
{	
	char *str = (char *)calloc(SIZE,sizeof(char ));
	int count = 0;
	
	for(int i = 0; i < SIZE;i++)
		str[count++] = (char)strtol(string[i],NULL,16);
		
	return str;
}
