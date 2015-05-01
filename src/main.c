#define _GNU_SOURCE
#include "altaLista.h"
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>


void test_string_longitud() {
    assert(string_longitud("Hola") == 4);
    assert(string_longitud("Hola K ase") == 10);
    assert(string_longitud("Pirulo pirulo pirulo") == 20);
}

void test_string_copiar() {
    char *str = string_copiar("Holitas");
    assert(string_iguales(str, "Holitas"));
    free(str);

    char *str2 = string_copiar("Hola Jijijiji");
    assert(string_iguales(str2, "Hola Jijijiji"));
    free(str2);
}

void test_string_menor() {
    printf("%s < %s? -> %d\n", "merced", "mercurio", string_menor("merced", "mercurio"));
    printf("%s < %s? -> %d\n", "mercurio", "merced", string_menor("mercurio", "merced"));

    printf("%s < %s? -> %d\n", "perro", "zorro", string_menor("perro", "zorro"));
    printf("%s < %s? -> %d\n", "zorro", "perro", string_menor("zorro", "perro"));

    printf("%s < %s? -> %d\n", "senior", "seniora", string_menor("senior", "seniora"));
    printf("%s < %s? -> %d\n", "seniora", "senior", string_menor("seniora", "senior"));

    printf("%s < %s? -> %d\n", "caZa", "casa", string_menor("caZa", "casa"));
    printf("%s < %s? -> %d\n", "casa", "caZa", string_menor("casa", "caZa"));

    printf("%s < %s? -> %d\n", "hola", "hola", string_menor("hola", "hola"));
}

void test_estudianteCrear() {
    estudiante *t = estudianteCrear("TTT", "Lol", 1);
    assert(string_iguales(t->nombre, "TTT"));
    assert(string_iguales(t->grupo, "Lol"));
    assert(t->edad == 1);
    estudianteBorrar(t);
}

void test_menorEstudiante() {
    estudiante *e1 = estudianteCrear("Joriji", "Jirulo", 13);
    estudiante *e2 = estudianteCrear("Mirh", "Kle", 43);
    estudiante *e3 = estudianteCrear("Lmg", "Sladsm23", 76);

    if (menorEstudiante(e1, e1)) { printf("True\n");
    } else { printf("False\n"); }

    if (menorEstudiante(e2, e2)) { printf("True\n");
    } else { printf("False\n"); }

    if (menorEstudiante(e3, e3)) { printf("True\n");
    } else { printf("False\n"); }

    if (menorEstudiante(e1, e2)) { printf("True\n");
    } else { printf("False\n"); }

    if (menorEstudiante(e1, e3)) { printf("True\n");
    } else { printf("False\n"); }

    if (menorEstudiante(e2, e3)) { printf("True\n");
    } else { printf("False\n"); }

    estudianteBorrar(e1);
    estudianteBorrar(e2);
    estudianteBorrar(e3);
    return;
}

void test_estudianteConFormato() {
    estudiante *t = estudianteCrear("Arara", "htht", 1);
    estudianteImprimir(t, stdout);
    estudianteConFormato(t, strfry);
    estudianteImprimir(t, stdout);
    assert(t->edad == 1);
    estudianteBorrar(t);
}

void test_nodoCrear() {
	estudiante *t = estudianteCrear("Test", "OOO", 3);
	nodo *n = nodoCrear(t);
	nodoBorrar(n, estudianteBorrar);
}

bool mismoGrupo( estudiante *e1, estudiante *e2 ){
    if( string_iguales( e1->grupo, e2->grupo) )
        return true;
    return false;
}

void test_altaListaCrear() {
	estudiante *e1 = estudianteCrear("Joriji", "Jirulo", 13);
	estudiante *e2 = estudianteCrear("Mirh", "Kle", 43);
	estudiante *e3 = estudianteCrear("Lmg", "Sladsm23", 76);
    estudiante *e4 = estudianteCrear("Lmg", "Sladsm23", 76);
	altaLista *l = altaListaCrear();
    insertarOrdenado(l, e1, menorEstudiante);
    insertarOrdenado(l, e2, menorEstudiante);
    insertarOrdenado(l, e3, menorEstudiante);
    altaListaImprimir(l, "test.txt", estudianteImprimir);
	printf("%f\n", edadMedia(l));
    filtrarAltaLista(l, mismoGrupo, e4);
    altaListaImprimir(l, "test.txt", estudianteImprimir);
    printf("%f\n", edadMedia(l));
	altaListaBorrar(l, estudianteBorrar);
    estudianteBorrar(e4);
}

int main (void){
	test_string_longitud();
    test_string_copiar();
    test_string_menor();

    test_estudianteCrear();
    test_menorEstudiante();
    test_estudianteConFormato();
    test_altaListaCrear();
    test_nodoCrear();
	return 0;
}
