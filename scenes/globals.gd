extends Node

signal mise_a_jour_amour

# Variable amendée au cours du jeu pour choisir une des quatre fin du perso principal
const AMOUR_MAX: int = 20
const AMOUR_INIT = 11
var amour: int = AMOUR_INIT: # Commencer à 11 !!
	set(n):
		if n < 0:
			amour = 0
		elif n > AMOUR_MAX:
			amour = AMOUR_MAX
		else:			
			amour = n
		mise_a_jour_amour.emit()

# Determiné en cours de jeu, mais ne sert à rien dans la version actuelle
const GENRE_TOI_INIT: String = "NA" 
var genre_toi: String = GENRE_TOI_INIT:
	set(s):
		if s in ["F", "M"] and genre_toi == "NA":
			genre_toi = s

# Determine en cours de jeu, permet de choisir entre un des deux chemins pour Dieu.			
const INTERET_DIEU_INIT: String = "NA"
var interet_dieu: String = INTERET_DIEU_INIT:
	set(s):
		if s in ["F", "M"] and interet_dieu == "NA":
			interet_dieu = s

# Devrait être lancé à chaque fois que l'acte 1 commence.
func variables_init():
	amour = AMOUR_INIT
	genre_toi = GENRE_TOI_INIT
	interet_dieu = INTERET_DIEU_INIT

# Quelles fins sont débloquées? Permet à BarreEtBoutons d'afficher les bonnes.
var fins: Array[bool] = [false, false, false, false, false, false]

const LENT: float = 40
const RAPIDE: float = 120			
var vitesse_de_lecture: float = LENT

var musique_en_pause: bool = false
var effets_sonores: bool = true


