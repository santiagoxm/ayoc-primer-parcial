#include "../ejs.h"

void borrarPublicacionesDeFeed(feed_t* feed, uint32_t id) {

	publicacion_t** prev = &feed->first;
	publicacion_t* pub = *prev;

	while (pub != NULL) {

		if (pub->value->id_autor == id) {
			*prev = pub->next;
			free(pub);
		}

		else {
			prev = &pub->next;
		}

		pub = *prev;

	}

}

void bloquearUsuario(usuario_t *usuario, usuario_t *usuarioABloquear){

	usuario->bloqueados[usuario->cantBloqueados] = usuarioABloquear;
	usuario->cantBloqueados++;

	borrarPublicacionesDeFeed(usuario->feed, usuarioABloquear->id);
	borrarPublicacionesDeFeed(usuarioABloquear->feed, usuario->id);

	return;
}

