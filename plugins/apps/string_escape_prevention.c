#include <string.h>
#include <stdio.h>
#include <stdlib.h>

char key0[]= {'\\', '\'', '\"', '=', '^', '$', '(', ')', '[', ']'};
char *key1="=^";

int main(int argc, char *argv[])
{
    unsigned int key_len, str_len;

    if (argc < 3) {
        printf("usage: xxx 'key' 'str'\n");
        return -1;
    }

    key_len = strlen(argv[1]);
    char *key = argv[1];

    if (key_len == 1) {
        switch (*key) {
            case '0':
                key = key0;
                key_len = strlen(key);
                break;
            case '1':
                key = key1;
                key_len = strlen(key);
                break;
            default:
                printf("unsupport!\n");
                return -1;
        }
    }

    for (int i = 2; i < argc; ++i) {
        str_len = strlen(argv[i]);
        char *p_o = argv[i];

        char *str = malloc(str_len*2+1);
        char *p = str;

        for (int j = 0; j < str_len; ++j) {
            for (int k = 0; k < key_len; ++k) {

                /* printf("key[%d] = %c\n", k, key[k]); */
                /* printf("\033[33mp_o = %c\033[0m\n", p_o[j]); */
                if (key[k] == p_o[j]) {
                    *p++ = '\\';
                    break;
                }
            }
            *p++ = p_o[j];
        }
        /* *p++ = '\n'; */

        if (i+1 < argc)
            *p++ = ' ';

        printf("%s", str);

        free(str);
    }

    return 0;
}
