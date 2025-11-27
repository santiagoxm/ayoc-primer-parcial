#include "../ejs.h"
#include <string.h>
#include <stdlib.h>


void publicarEnFeed(tuit_t* tuit, feed_t* feed) {

	publicacion_t* publicacion = malloc(16);
	publicacion->next = feed->first;
	publicacion->value = tuit;

	feed->first = publicacion;

	return;

}

// Función principal: publicar un tuit
tuit_t* publicar(char *mensaje, usuario_t *user) {

	tuit_t* tuit = malloc(160);
	strcpy((char*)&tuit->mensaje, mensaje);
	tuit->favoritos = 0;
	tuit->retuits = 0;
	tuit->id_autor = user->id;

	publicarEnFeed(tuit, user->feed);

	for (unsigned int i = 0; i < user->cantSeguidores; i++) {

		publicarEnFeed(tuit, user->seguidores[i]->feed);

	}

	return tuit;
}
