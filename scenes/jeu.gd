extends Control

# Fixe le début du jeu, devrait être l'acte 1 ^^
var jeu_commence: bool = false
var acte_en_cours: Acte = preload("res://ressources_dialogues/acte1.tres")
# Workaround pour recharger dialogue dès la mise à jour de la langue
var ligne_actuelle: int

# C'est ti-par
func _ready() -> void:
	$Confidencias.play()
	nouvel_acte() # Devrais lancer l'acte 1 ^^

# Contient le déroulement du jeu 
# reçoit un signal de BoutonsEtMenus quand le joueur finit un acte.
func _on_boutons_et_menu_acte_suivant(numero_acte: int) -> void:
	match numero_acte:
		-1: # Arrivée à l'église avec Dieu
			Globals.variables_init()
			$BoutonsEtMenu.vider_recap()
			acte_en_cours = load("res://ressources_dialogues/acte1.tres")
		-2: # Rencontre avec Mariposa
			acte_en_cours = load("res://ressources_dialogues/acte2.tres")
		-3: # Lendemain de la rencontre
			acte_en_cours = load("res://ressources_dialogues/acte3.tres")
		-4: # Accueil par le curé
			acte_en_cours = load("res://ressources_dialogues/acte4.tres")
		-5: # Gaby découvre qui est Mariposa
			acte_en_cours = load("res://ressources_dialogues/acte5.tres")
		-6: # Accueil par Lorena
			acte_en_cours = load("res://ressources_dialogues/acte6.tres")
		-7: # Intention de Dieu 1
			acte_en_cours = load("res://ressources_dialogues/acte7.tres")
		-8: # Intentions de Dieu 2
			acte_en_cours = load("res://ressources_dialogues/acte8.tres")
		-9: # Accueil par Manuel
			acte_en_cours = load("res://ressources_dialogues/acte9.tres")
		-10: # Proposition en mariage
			acte_en_cours = load("res://ressources_dialogues/acte10.tres")
		-11: # Echange des voeux
			acte_en_cours = load("res://ressources_dialogues/acte11.tres")
		-12: # Sortie de l'église
			acte_en_cours = load("res://ressources_dialogues/acte12.tres")
		-13: # Chemin du passé de Lorena 1
			acte_en_cours = load("res://ressources_dialogues/acte13.tres")
		-14: # Chemin du passé de Lorena 2
			acte_en_cours = load("res://ressources_dialogues/acte14.tres")
		-15: # Chemin du passé de Lorena 3
			acte_en_cours = load("res://ressources_dialogues/acte15.tres")
		-16: # Présent de Lorena
			acte_en_cours = load("res://ressources_dialogues/acte16.tres")
			Globals.fins[0] = true
			$BoutonsEtMenu.actualiser_affichage_reglages()
		-23: # Chemin du passé de Manuel 1
			acte_en_cours = load("res://ressources_dialogues/acte23.tres")
		-24: # Chemin du passé de Manuel 2
			acte_en_cours = load("res://ressources_dialogues/acte24.tres")
		-25: # Chemin du passé de Manuel 3
			acte_en_cours = load("res://ressources_dialogues/acte25.tres")
		-26: # Présent de Manuel
			acte_en_cours = load("res://ressources_dialogues/acte26.tres")
			Globals.fins[1] = true
			$BoutonsEtMenu.actualiser_affichage_reglages()
		-17: # Choix des conclusions
			if Globals.amour > 17: # trop bien pour être honnête
				acte_en_cours = load("res://ressources_dialogues/acte18.tres")
				Globals.fins[2] = true
				$BoutonsEtMenu.actualiser_affichage_reglages()
			elif Globals.amour < 2: # toxique?
				acte_en_cours = load("res://ressources_dialogues/acte20.tres")
				Globals.fins[3] = true
				$BoutonsEtMenu.actualiser_affichage_reglages()
			elif Globals.amour > 9: # meilleure fin
				acte_en_cours = load("res://ressources_dialogues/acte17.tres")
				Globals.fins[4] = true
				$BoutonsEtMenu.actualiser_affichage_reglages()
			else: # toxique?
				acte_en_cours = load("res://ressources_dialogues/acte19.tres")
				Globals.fins[5] = true
				$BoutonsEtMenu.actualiser_affichage_reglages()
		-21: # Générique
			acte_en_cours = load("res://ressources_dialogues/acte21.tres")
		-22: # Choix de la scène post-générique
			if Globals.interet_dieu == "F": # si chemin de Lorena
				acte_en_cours = load("res://ressources_dialogues/acte22.tres")
			elif Globals.interet_dieu == "M": # si chemin de Manuel
				acte_en_cours = load("res://ressources_dialogues/acte27.tres")
			else:
				acte_en_cours = load("res://ressources_dialogues/acte1.tres")
				push_error("L'orientation de Dieu n'a pas été enregistrée.")
		_:
			push_error("L'acte choisi n'existe pas.")
	nouvel_acte()

# Gère le passage d'une ressource "Acte" à la suivante, avec une transition pour
# que ce soit moins brusque
func nouvel_acte() -> void:
	if jeu_commence:
		$Transition.transition_vers_noir(acte_en_cours.duree_transition)
		await $Transition.fini # Pour ne pas charger le nouvel acte avant écran noir
	else:
		jeu_commence = true # Pour eviter un fondu VERS le noir moche au début
	
	# Une fois la la seine lancée, tout reste tel quel, sauf lire_dialogue() qui
	# passe de ligne en ligne
	$Fond.texture = acte_en_cours.fond
	$Decor.texture = acte_en_cours.decor
	if Globals.effets_sonores:
		$BruitageActe.stream = acte_en_cours.bruitage
		$BruitageActe.play()
	lire_dialogue(acte_en_cours.ligne_de_depart)
	
	$Transition.transition_vers_transparent(0.6)

# Le coeur du jeu, appelée par les sigaux ci-dessous lorsque le jour clique sur
# suivant ou fait un choix
func lire_dialogue(numero_ligne: int) -> void:
	ligne_actuelle = numero_ligne # pour changer la langue à la volée
	var ligne: Ligne = acte_en_cours.dialogue.dialogue[numero_ligne]
	$BoutonsEtMenu.charger_boutons(ligne.choix)
	$Personnage.lire_ligne(ligne)
		
# Recoit un signal de BoutonsEtMenus pour changer de ligne dans le MEME acte
func _on_boutons_et_menu_replique_suivante(numero_ligne: int) -> void:
	lire_dialogue(numero_ligne)

# Pour décaler l'affichage du dialogue géré par Personnage, et l'affichage du
# bouton suivant géré par Boutons_choix
func _on_personnage_ligne_de_dialogue_affichee() -> void:
	$BoutonsEtMenu.activer_suite()

# Workaround pour actualiser la langue dès la ligne actuelle au lieu d'attendre
# une nouvelle ligne de texte
func _on_boutons_et_menu_langue_changee() -> void:
	lire_dialogue(ligne_actuelle)

# Si la musique saoule le joueur
func _on_boutons_et_menu_musique_changee() -> void:
	Globals.musique_en_pause = not Globals.musique_en_pause
	$Confidencias.stream_paused = Globals.musique_en_pause
	$BoutonsEtMenu.actualiser_affichage_reglages()

