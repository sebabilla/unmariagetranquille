extends Control

var acte1: Acte = preload("res://ressources_dialogues/acte1.tres")
var acte2: Acte = preload("res://ressources_dialogues/acte2.tres")
var acte3: Acte = preload("res://ressources_dialogues/acte3.tres")
var acte4: Acte = preload("res://ressources_dialogues/acte4.tres")
var acte5: Acte = preload("res://ressources_dialogues/acte5.tres")
var acte6: Acte = preload("res://ressources_dialogues/acte6.tres")
var acte7: Acte = preload("res://ressources_dialogues/acte7.tres")
var acte8: Acte = preload("res://ressources_dialogues/acte8.tres")
var acte9: Acte = preload("res://ressources_dialogues/acte9.tres")
var acte10: Acte = preload("res://ressources_dialogues/acte10.tres")
var acte11: Acte = preload("res://ressources_dialogues/acte11.tres")
var acte12: Acte = preload("res://ressources_dialogues/acte12.tres")
var acte13: Acte = preload("res://ressources_dialogues/acte13.tres")
var acte14: Acte = preload("res://ressources_dialogues/acte14.tres")
var acte15: Acte = preload("res://ressources_dialogues/acte15.tres")
var acte16: Acte = preload("res://ressources_dialogues/acte16.tres")
var acte17: Acte = preload("res://ressources_dialogues/acte17.tres")
var acte18: Acte = preload("res://ressources_dialogues/acte18.tres")
var acte19: Acte = preload("res://ressources_dialogues/acte19.tres")
var acte20: Acte = preload("res://ressources_dialogues/acte20.tres")
var acte21: Acte = preload("res://ressources_dialogues/acte21.tres")
var acte22: Acte = preload("res://ressources_dialogues/acte22.tres")
var acte23: Acte = preload("res://ressources_dialogues/acte23.tres")
var acte24: Acte = preload("res://ressources_dialogues/acte24.tres")
var acte25: Acte = preload("res://ressources_dialogues/acte25.tres")
var acte26: Acte = preload("res://ressources_dialogues/acte26.tres")
var acte27: Acte = preload("res://ressources_dialogues/acte27.tres")

# Fixe le début du jeu, devrait être l'acte 1 ^^
var acte_en_cours: Acte = acte1
# Work around pour recharger dialogue dès la mise à jour de la langue
var ligne_actuelle: int

# C'est ti-par
func _ready() -> void:
	$Transition.hide()
	$Confidencias.play()
	nouvel_acte(acte_en_cours) # Devrais lancer l'acte 1 ^^

# Contient le Deroulement du jeu 
# reçoit un signal de BoutonsEtMenus quand le joueur finit un acte.
func _on_boutons_et_menu_acte_suivant(numero_acte: int) -> void:
	match numero_acte:
		-1: # Arrivée à l'église avec Dieu
			Globals.variables_init()
			acte_en_cours = acte1
		-2: # Rencontre avec Mariposa
			acte_en_cours = acte2
		-3: # Lendemain de la rencontre
			acte_en_cours = acte3
		-4: # Accueil par le curé
			acte_en_cours = acte4
		-5: # Gaby découvre qui est Mariposa
			acte_en_cours = acte5
		-6: # Accueil par Lorena
			acte_en_cours = acte6
		-7: # Intention de Dieu 1
			acte_en_cours = acte7
		-8: # Intentions de Dieu 2
			acte_en_cours = acte8
		-9: # Accueil par Manuel
			acte_en_cours = acte9
		-10: # Proposition en mariage
			acte_en_cours = acte10
		-11: # Echange des voeux
			acte_en_cours = acte11
		-12: # Sortie de l'église
			acte_en_cours = acte12
		-13: # Chemin du passé de Lorena 1
			acte_en_cours = acte13
		-14: # Chemin du passé de Lorena 2
			acte_en_cours = acte14
		-15: # Chemin du passé de Lorena 3
			acte_en_cours = acte15
		-16: # Présent de Lorena
			acte_en_cours = acte16
			Globals.fins[0] = true
			$BoutonsEtMenu.actualiser_affichage_reglages()
		-23: # Chemin du passé de Manuel 1
			acte_en_cours = acte23
		-24: # Chemin du passé de Manuel 2
			acte_en_cours = acte24
		-25: # Chemin du passé de Manuel 3
			acte_en_cours = acte25
		-26: # Présent de Manuel
			acte_en_cours = acte26
			Globals.fins[1] = true
			$BoutonsEtMenu.actualiser_affichage_reglages()
		-17: # Choix des conclusions
			if Globals.amour > 17: # trop bien pour être honnête
				acte_en_cours = acte18
				Globals.fins[2] = true
				$BoutonsEtMenu.actualiser_affichage_reglages()
			elif Globals.amour < 2: # toxique?
				acte_en_cours = acte20
				Globals.fins[3] = true
				$BoutonsEtMenu.actualiser_affichage_reglages()
			elif Globals.amour > 9: # meilleure fin
				acte_en_cours = acte17
				Globals.fins[4] = true
				$BoutonsEtMenu.actualiser_affichage_reglages()
			else: # toxique?
				acte_en_cours = acte19
				Globals.fins[5] = true
				$BoutonsEtMenu.actualiser_affichage_reglages()
		-21: # Générique
			acte_en_cours = acte21
		-22: # Choix de la scène post-générique
			if Globals.interet_dieu == "F": # Chemin de Lorena
				acte_en_cours = acte22
			elif Globals.interet_dieu == "M": # Chemin de Manuel
				acte_en_cours = acte27
			else:
				acte_en_cours = acte1
				push_error("L'orientation de Dieu n'a pas été enregistrée.")
	nouvel_acte(acte_en_cours)

# Gère le passage d'une ressource "Acte" à la suivante, avec une transition pour
# que ce soit moins brusque
func nouvel_acte(acte: Acte) -> void:
	$Transition.show()
	var assombrir: Tween = create_tween()
	assombrir.tween_property($Transition, "color:a", 1, 1).from(0)
	await assombrir.finished
	
	# Une fois la la seine lancée, tout reste tel quel, sauf lire_dialogue() qui
	# passe de ligne en ligne
	$Fond.texture = acte.fond
	$Decor.texture = acte.decor
	if Globals.effets_sonores:
		$BruitageActe.stream = acte.bruitage
		$BruitageActe.play()
	lire_dialogue(acte.ligne_de_depart)
	
	var eclaircir: Tween = create_tween()
	eclaircir.tween_property($Transition, "color:a", 0, 0.6)
	await eclaircir.finished
	$Transition.hide()

# Le coeur du jeu, appelée par les sigaux ci-dessous lorsque le jour clique sur
# suivant ou fait un choix
func lire_dialogue(numero_ligne: int) -> void:
	ligne_actuelle = numero_ligne # pour changer la langue à la volée
	var ligne: Ligne = acte_en_cours.dialogue.dialogue[numero_ligne]
	$BoutonsEtMenu.charger_boutons(ligne.choix)
	$Personnage.cacher_replique()
	$Personnage.montrer_replique()
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

