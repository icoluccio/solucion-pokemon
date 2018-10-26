class Pokemon {

	var ataques = []
	var property ataque = 5
	var defensa = 5
	var vida = 10
	var property velocidad = 15
	var estado = saludable

	method aprenderAtaques(unAtaque) {
		if (ataques.size() > 3) {
			ataques.remove(ataques.anyOne())
		}
		ataques.add(unAtaque)
	}

	method elegirAtaque() {
		return ataques.anyOne()
	}

	method atacar(otroPokemon) {
		if (self.vivo() && estado.puedoAtacar()) {
			self.elegirAtaque().atacar(self, otroPokemon)
		}
		estado.afectar(self)
	}

	method recibirDanio(danio) {
		vida -= 0.min(danio - (defensa / 10))
	}

	method vivo() {
		return vida > 0
	}

}

class Entrenador {

	var pokemon = []

	method agregarPokemon(unPokemon) {
		if (pokemon.size() > 5) {
			error.throwWithMessage("No se puede agregar tantos pokemon")
		}
		pokemon.add(unPokemon)
	}

	method pokemonVivos() = pokemon.filter({ p => p.vivo() })

	method proximoPokemon() = self.pokemonVivos().anyOne()

	method noMasPokemon() = self.pokemonVivos().empty()

}

object saludable {

	method puedoAtacar() = true

	method afectar(pokemon) {
	}

}

object envenenado {

	method puedoAtacar() = true

	method afectar(pokemon) {
		pokemon.recibirDanio(pokemon.vida() / 10)
	}

}

class Paralizado {

	var property grado = 1

	method afectar(pokemon) {
		grado--
		if (grado == 0) {
			pokemon.cambiarEstado(saludable)
		}
	}

}

object veneno {

	method atacar(unPokemon, otroPokemon) {
		otroPokemon.cambiarEstado(envenenado)
	}

}

object atactrueno {

	method atacar(unPokemon, otroPokemon) {
		otroPokemon.recibirDanio(self.danio(unPokemon))
		if (0.randomUpTo(100) > 50) {
			otroPokemon.cambiarEstado(new Paralizado(grado = 5))
		}
	}

	method danio(atacante) = atacante.velocidad()

}

object placaje {

	method atacar(unPokemon, otroPokemon) {
		otroPokemon.recibirDanio(self.danio(unPokemon))
	}

	method danio(atacante) = atacante.ataque()

}

class Combate {

	var unEntrenador
	var otroEntrenador

	method pelear() {
		if (!self.termino()) {
			self.hacerTurno()
			self.pelear()
		}
	}

	method hacerTurno() {
		var unPokemon = unEntrenador.proximoPokemon()
		var otroPokemon = otroEntrenador.proximoPokemon()
		unPokemon.atacar(otroPokemon)
		otroPokemon.atacar(unPokemon)
	}

	method atacar(unPokemon, otroPokemon, entrenador) {
		if (unPokemon.vivo()) {
			unPokemon.atacar(otroPokemon)
		}
	}

	method termino() {
		return unEntrenador.noMasPokemon() || otroEntrenador.noMasPokemon()
	}

}

