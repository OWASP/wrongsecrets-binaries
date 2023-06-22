#include <stdio.h>
#include <stdlib.h>

#define SIZE 21

char *decode(const char ** )__attribute__((visibility("hidden")));
int compare(const char *, const char * )__attribute__((visibility("hidden")));
void usage(char *);

int main(int argc, char **argv)
{	
	const char *secret[] = {"69","67","6f","74","68","61","63","6b","65","64","62","79","73","65","63","72","65","74","70","77","64"};
	char *encoded = decode(secret);
	
	if(argc < 2)
	{
		usage(argv[0]);
	}
	
	puts(compare(encoded, argv[1]) ? "root:~# You're root :-D" : "Try again");
	
	return EXIT_SUCCESS;
}
void usage(char *string)
{
	printf("Usage: %s [PASSWORD]\n",string);
	exit(EXIT_FAILURE);
}
int compare(const char *encoded,const char *passwd)
{
	for(int a = 0; passwd[a];a++)
		if(encoded[a] != passwd[a])
			return 0;
	return 1;
}
char *decode(const char **string)
{	
	char *str = (char *)calloc(SIZE,sizeof(char ));
	int count = 0;
	
	for(int i = 0; i < SIZE;i++)
		str[count++] = (char)strtol(string[i],NULL,16);
		
	return str;
}
