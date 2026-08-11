#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>
#include "lib/aes.c"

#define SIZE 16

bool hex_compare(uint8_t *, uint8_t *)__attribute__((visibility("hidden")));
char* hexa_to_str(uint8_t *);
char *get_key(void)__attribute__((visibility("hidden")));
const char *secret(void)__attribute__((visibility("hidden")));
int spoil(void)__attribute__((visibility("hidden")));
int execute(char *command)__attribute__((visibility("hidden")));
int compare(char *guess)__attribute__((visibility("hidden")));
uint8_t *get_secret_message(void)__attribute__((visibility("hidden")));
uint8_t* str_to_hex(char *);
void usage(char *)__attribute__((visibility("hidden")));
void print_hex(uint8_t* )__attribute__((visibility("hidden")));
void usage(char *)__attribute__((visibility("hidden")));

char *hint = "Some AES int(math.log(8)) bit encrypted";

int main(int argc, char **argv)
{
	if(argc < 2)
	{
		usage(argv[0]);
	}
	execute(argv[1]);
	return EXIT_SUCCESS;
}
char* hexa_to_str(uint8_t *array)
{
	char *string = (char *)calloc(SIZE + 1, sizeof(char));
	if (string == NULL)
	{
		return NULL;
	}
	for(int a = 0; a < SIZE; a++){
		string[a] = (unsigned char)array[a];
	}
	string[SIZE] = '\0';
	return string;
}
uint8_t *get_plain_text_message(void)
{
	struct AES_ctx ctx;
	uint8_t *digest = calloc(SIZE,sizeof(uint8_t ));
	if (digest == NULL)
	{
		return NULL;
	}
	uint8_t data[SIZE] = {0xe4,0x9f,0x2f,0x33,0x1a,0x9a,0x25,0x19,0x74,0xe1,0xba,0x7f,0x72,0x4c,0x3b,0x7f}; // doubled encrypted secret message
	char *raw_key = get_key();
	if (raw_key == NULL)
	{
		free(digest);
		return NULL;
	}
	uint8_t *key = str_to_hex(raw_key);
	free(raw_key);
	if (key == NULL)
	{
		free(digest);
		return NULL;
	}

	AES_init_ctx(&ctx, key);
	free(key);

	for(int i = 0; i < SIZE;i++)
	{
		digest[i] = data[i];
	}
	AES_ECB_decrypt(&ctx,digest);
	AES_ECB_decrypt(&ctx,digest);
		
    return digest;
}
uint8_t *get_secret_message(void)
{
	uint8_t *digest = calloc(SIZE,sizeof(uint8_t ));
	if (digest == NULL)
	{
		return NULL;
	}
	uint8_t data[SIZE] = {0xe4,0x9f,0x2f,0x33,0x1a,0x9a,0x25,0x19,0x74,0xe1,0xba,0x7f,0x72,0x4c,0x3b,0x7f}; // doubled encrypted secret message
	
	for(int i = 0; i < SIZE;i++)
	{
		digest[i] = data[i];
	}
    return digest;
}

char *get_key(void)
{	
	char * key = (char *)calloc(SIZE,sizeof(char ));
	if (key == NULL)
	{
		return NULL;
	}
	char data[SIZE] = {'i','g','o','t','a','l','l','t','h','e','k','e','y','s','s','s'};
	
	for(int i = 0; i < SIZE;i++)
	{
		key[i] = data[i];
	}
    
    return key;
}
bool hex_compare(uint8_t *a, uint8_t *b)
{
	return 0 == memcmp((char*) a, (char*) b, SIZE);
}
void usage(char *string)
{
	printf("Usage: %s [PASSWORD]\n",string);
	printf("Usage: %s spoil \n",string);
	exit(EXIT_FAILURE);
}
int compare(char *guess)
{	
	if(strlen(guess) == SIZE)
	{
		char *raw_key = get_key();
		if (raw_key == NULL)
		{
			return 0;
		}
		uint8_t *key = str_to_hex(raw_key);
		free(raw_key);
		uint8_t *secret_message_digest = get_secret_message();
		uint8_t *guess_digest = str_to_hex(guess);
		struct AES_ctx ctx;

		if (key == NULL || secret_message_digest == NULL || guess_digest == NULL)
		{
			free(key);
			free(secret_message_digest);
			free(guess_digest);
			return 0;
		}

		AES_init_ctx(&ctx, key);
		free(key);
		AES_ECB_encrypt(&ctx,guess_digest);
		AES_ECB_encrypt(&ctx,guess_digest);
	
		bool result = hex_compare(guess_digest,secret_message_digest);
		free(guess_digest);
		free(secret_message_digest);

		if (result)
		{
			printf("This is correct! Congrats!\n");
			return 1;
		}
	}
	printf("This is incorrect. Try again\n");
    return 0;
}
int execute(char *command)
{
    if (strcmp("spoil", command) == 0)
    {
        return spoil();
    }
    return compare(command);
}
const char *secret(void)
{
    uint8_t *plain = get_plain_text_message();
    if (plain == NULL)
    {
        return NULL;
    }
    char *str = hexa_to_str(plain);
    free(plain);
    return str;
}
int spoil(void)
{
    const char *s = secret();
    if (s != NULL)
    {
        printf("%s\n", s);
        free((void *)s);
    }
    return 0;
}
uint8_t* str_to_hex(char *str)
{
	uint8_t *ret = calloc(SIZE,sizeof(uint8_t));
	if (ret == NULL)
	{
		return NULL;
	}
	for(int i = 0; i < SIZE;i++)
	{
		ret[i] = (uint8_t) str[i];
	}
	return ret;
}
void print_hex(uint8_t* str)
{
	uint8_t len = 16;
    unsigned char i;
    for (i = 0; i < len; ++i)
        printf("%.2x", str[i]);
    printf("\n");
}
