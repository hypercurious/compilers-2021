#include <stdlib.h>
#include <string.h>

typedef struct symrec symrec;

extern int size;
extern symrec* symbol_table;

struct symrec{
    char name[32]; //symbol name
};

void putsym();
int getsym();

void putsym(char* sym_name){
    size++;
    symbol_table = realloc(symbol_table, size * sizeof(symrec));
    strcpy(symbol_table[size-1].name, sym_name);
    printf("===== Added Symbol with name: -%s-\n", symbol_table[size-1].name);
}

int getsym(char* sym_name){
    for (int i = 0; i < size; i++) {
        printf("===== Searching Symbol with name: -%s-\n", symbol_table[i].name);
        if(!strcmp(symbol_table[i].name, sym_name)) {
            printf("===== Found Symbol with name: -%s-\n", symbol_table[i].name);
            return 1;
        }
    }
    return 0;
}
