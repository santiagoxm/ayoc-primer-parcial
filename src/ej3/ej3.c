#include "../ejs.h"

uint32_t cantidadTuitsSobresalientes(usuario_t *user,
                       uint8_t (*esTuitSobresaliente)(tuit_t *)) {

	uint32_t id = user->id;
	uint32_t count = 0;
	tuit_t* tuit;

	publicacion_t* pub = user->feed->first;

	while (pub != NULL) {

		tuit = pub->value;

		if (tuit->id_autor == id) { count += esTuitSobresaliente(tuit); }
		pub = pub->next;

	}

	return count;
}

tuit_t **trendingTopic(usuario_t *user,
                       uint8_t (*esTuitSobresaliente)(tuit_t *)) {

	uint32_t cantidad = cantidadTuitsSobresalientes(user, esTuitSobresaliente);

	if (cantidad == 0) { return NULL; }

	tuit_t** tuitsSobresalientes = malloc(cantidad*sizeof(tuit_t*));
	tuitsSobresalientes[cantidad] = NULL;

	publicacion_t* pub = user->feed->first;

	uint32_t i = 0;
	tuit_t* tuit;

	while (i < cantidad) {

		tuit = pub->value;

		if (tuit->id_autor == user->id && esTuitSobresaliente(tuit)) { 
			tuitsSobresalientes[i] = tuit;
			i++;
		}

		pub = pub->next;
	
	}

	return tuitsSobresalientes;

}
