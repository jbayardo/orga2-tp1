#include "altaLista.h"






/** Funciones Auxiliares ya implementadas en C **/

bool string_iguales( char *s1, char *s2 ){
   int i = 0;
   while( s1[i] == s2[i] ){
      if( s1[i] == 0 || s2[i] == 0 )
         break;
      i++;
   }
   if( s1[i] == 0 && s2[i] == 0 )
      return true;
   else
      return false;
}

void insertarAtras( altaLista *l, void *dato ){
	nodo *nuevoNodo = nodoCrear( dato );
    nodo *ultimoNodo = l->ultimo;
    if( ultimoNodo == NULL )
        l->primero = nuevoNodo;
    else
        ultimoNodo->siguiente = nuevoNodo;
    nuevoNodo->anterior = l->ultimo;
    l->ultimo = nuevoNodo;
}

/*
void insertarOrdenado( altaLista *l, void *dato, tipoFuncionCompararDato f )
Inserta el dato en un nuevo nodo en l, manteniendo el orden dado por f. Suponiendo que la
lista ya tiene sus nodos ordenados de forma creciente seg ́
un f sobre cada dato, el nuevo nodo se
insertar ́
a respetando ese orden. Se considera que una lista vac ́ıa est ́a ordenada.
f(dato1,dato2) devuelve true si dato1 < dato2.

Nota 1: Si le sirve de ayuda, aproveche las funciones nodoCrear e insertarAtras para algun
caso particular. La primera ya implementada anteriormente, y la segunda ya implementada en
lenguaje C.

Nota 2: Al finalizar esta funci ́on, tanto la lista como todos sus nodos, deben respetar el
invariante de la estructura altaLista. Tenga en cuenta la aritm ́etica de punteros de todas las
estructuras
*/

/*
void insertarOrdenado(altaLista *l, void *dato, tipoFuncionCompararDato f) {
  nodo *nuevoNodo = nodoCrear(dato);

  if (l->primero == NULL) {
    l->primero = nuevoNodo;
    l->ultimo = nuevoNodo;
  } else {
    nodo *cur = l->primero;

    while (cur != NULL && !f(nuevoNodo->dato, cur->dato)) {
      cur = cur->siguiente;
    }

   // nuevoNodo -> cur
    if (cur == NULL) {
      // Llegamos al final de la lista
      l->ultimo->siguiente = nuevoNodo;
      nuevoNodo->anterior = l->ultimo;
      l->ultimo = nuevoNodo;
    } else if (cur->anterior == NULL) {
      // Estamos en el primer nodo
    cur->anterior = nuevoNodo;
    nuevoNodo->siguiente = cur;
    l->primero = nuevoNodo;
    } else {
      // Estamos en el medio
    nuevoNodo->anterior = cur->anterior;
    nuevoNodo->siguiente = cur;
    cur->anterior->siguiente = nuevoNodo;
    cur->anterior = nuevoNodo;
    }
  }
}
*/
