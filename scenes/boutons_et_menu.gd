extends Control

signal replique_suivante(numero_ligne: int)
signal acte_suivant(numero_acte: int)
signal langue_changee
signal musique_changee

const NOMBRE_DE_CHOIX_MAX = 3

var choix_possibles: Array[Choix] = []
@onready var noeud_boutons: VBoxContainer = $ContainerChoix/ListeBoutons


func _ready() -> void:
	inactiver_suite()
	inactiver_tous_les_boutons()
	actualiser_affichage_reglages()
	_on_bouton_reglage_sortie_pressed()

# Utilisé par le scipt de jeu, prépare les boutons, mais n'affiche rien
func charger_boutons(import_choix: Array[Choix]) -> void:
	choix_possibles = import_choix
	for numero in range(import_choix.size()):
		var bouton: RichTextLabel = noeud_boutons.get_child(numero)
		bouton.text = tr(import_choix[numero].code_traduction)
		bouton.modulate = Color("#bcbace")
		
		
func _on_button_0_pressed() -> void:
	enregistrer_le_choix(0)
	
func _on_button_1_pressed() -> void:
	enregistrer_le_choix(1)
	
func _on_button_2_pressed() -> void:
	enregistrer_le_choix(2)

# Reaction selon le choix du joueur	
func enregistrer_le_choix(numero: int) -> void:
	Globals.amour += choix_possibles[numero].point_d_amour
	Globals.genre_toi = choix_possibles[numero].genre_toi
	Globals.interet_dieu = choix_possibles[numero].interet_dieu
	
	var suite = choix_possibles[numero].ligne
	if suite < 0:
		if Globals.effets_sonores:
			$TournerLaPage.play()
		acte_suivant.emit(suite)
	else:
		replique_suivante.emit(suite)
	inactiver_tous_les_boutons()

# Cache et inactive les boutons sans changer leur contenu
func inactiver_bouton_choix(numero: int) -> void:
	release_focus()
	noeud_boutons.get_child(numero).hide()
	noeud_boutons.get_child(numero).get_child(0).disabled = true
	
func inactiver_tous_les_boutons():
	for numero in range(NOMBRE_DE_CHOIX_MAX):
		inactiver_bouton_choix(numero)
	$ContainerChoix/MarginContainer/Heros.hide()
	
# Montre et active les boutons de choix sans changer leur contenu
func activer_bouton(numero: int) -> void:
	noeud_boutons.get_child(numero).show()
	noeud_boutons.get_child(numero).get_child(0).disabled = false

	noeud_boutons.get_child(numero).get_child(0).grab_focus()
	if numero == 0 :
		noeud_boutons.get_child(numero).get_child(0).focus_neighbor_top = "%Button0"
	else: 
		noeud_boutons.get_child(numero).get_child(0).focus_neighbor_top = "%Button" + str(numero - 1)
	if numero == choix_possibles.size() - 1 :
		noeud_boutons.get_child(numero).get_child(0).focus_neighbor_bottom = "%Button" + str(numero)
	else:
		noeud_boutons.get_child(numero).get_child(0).focus_neighbor_bottom = "%Button" + str(numero + 1)
		
func activer_tous_les_boutons() -> void:
	$ContainerChoix.show()
	$ContainerChoix/MarginContainer/Heros.show()
	for numero in range(choix_possibles.size()):
		activer_bouton(numero)
		
# Etapes d'affichage, d'abord le bouton suite, qui laisse se place aux choix,
# ou directement à la replique suivante si le personnage principal ne dit rien.
func _on_button_suite_pressed() -> void:
	inactiver_suite()
	if choix_possibles[0].code_traduction == "SUIVANT":
		enregistrer_le_choix(0)
		return
	activer_tous_les_boutons()

func activer_suite() -> void:
	$ContainerSuivant/ButtonSuite.show()
	$ContainerSuivant/ButtonSuite.disabled = false
	if not $OuvertureReglages/BoutonReglagesEntree.disabled: # workaround à la con pour éviter la perte du focus pendant le chagement de langue 
		$ContainerSuivant/ButtonSuite.grab_focus()

func inactiver_suite() -> void:
	$ContainerSuivant/ButtonSuite.hide()
	$ContainerSuivant/ButtonSuite.disabled = true
	$ContainerSuivant/ButtonSuite.release_focus()


# Ouvre ou masque le menu avec le titre, les fins et les reglages 
func _on_bouton_reglages_entree_pressed() -> void:
	var tween: Tween = create_tween()
	tween.tween_property($Reglages, "position:x", 0, 0.1)
	$OuvertureReglages/BoutonReglagesEntree.release_focus()
	$OuvertureReglages/BoutonReglagesEntree.hide()
	$OuvertureReglages/BoutonReglagesEntree.disabled = true
	await tween.finished
	$OuvertureReglages/BoutonReglageSortie.show()
	$OuvertureReglages/BoutonReglageSortie.disabled = false
	$OuvertureReglages/BoutonReglageSortie.grab_focus()
	
func _on_bouton_reglage_sortie_pressed() -> void:
	var tween: Tween = create_tween()
	tween.tween_property($Reglages, "position:x", -640, 0.1)
	$OuvertureReglages/BoutonReglageSortie.release_focus()
	$OuvertureReglages/BoutonReglageSortie.hide()
	$OuvertureReglages/BoutonReglageSortie.disabled = true
	await tween.finished
	$OuvertureReglages/BoutonReglagesEntree.show()
	$OuvertureReglages/BoutonReglagesEntree.disabled = false
	$OuvertureReglages/BoutonReglagesEntree.grab_focus()
	


# Affiche ou masque les fins selon le parcours du joueur
func afficher_fins() -> void:	
	var fins: GridContainer =$Reglages/VBoxParent/HBoxReglagesFins/VBoxFins/GridFins
	for numero in range(6):
		if Globals.fins[numero]:
			fins.get_child(numero).self_modulate.a = 0
			fins.get_child(numero).get_child(0).modulate.a = 1
		else:
			fins.get_child(numero).get_child(0).modulate.a = 0
			
			
# Toutes les fonctions ci-dessous permettent de switcher entre les reglages et 
# d'afficher imédiatement le résultat
func afficher_langue() -> void:
	var texte_langue: RichTextLabel = $Reglages/VBoxParent/HBoxReglagesFins/VBoxReglages/HBoxContainer/TextLangue
	if TranslationServer.get_locale().substr(0, 2) == "fr":
		texte_langue.text = tr("FRANCAIS")
	else:
		texte_langue.text = tr("ANGLAIS")


func _on_check_langue_toggled(_toggled_on: bool) -> void:
	if TranslationServer.get_locale().substr(0, 2) == "fr":
		TranslationServer.set_locale("en")
	else:
		TranslationServer.set_locale("fr")
	langue_changee.emit()
	actualiser_affichage_reglages()
	
func afficher_vitesse() -> void:
	var texte_vitesse: RichTextLabel = $Reglages/VBoxParent/HBoxReglagesFins/VBoxReglages/HBoxContainer2/TextVitesse
	if Globals.vitesse_de_lecture == Globals.LENT:
		texte_vitesse.text = tr("LECTURE_NORMALE")
	else:
		texte_vitesse.text = tr("LECTURE_RAPIDE")

func _on_check_vitesse_toggled(_toggled_on: bool) -> void:
	if Globals.vitesse_de_lecture == Globals.LENT:
		Globals.vitesse_de_lecture = Globals.RAPIDE
	else:
		Globals.vitesse_de_lecture = Globals.LENT
	actualiser_affichage_reglages()

func afficher_musique() -> void:
	var texte_musique: RichTextLabel = $Reglages/VBoxParent/HBoxReglagesFins/VBoxReglages/HBoxContainer3/TextMusique
	if Globals.musique_en_pause:
		texte_musique.text = tr("MUSIQUE_OFF")
	else:
		texte_musique.text = tr("MUSIQUE_ON")

func _on_check_musique_toggled(_toggled_on: bool) -> void:
	musique_changee.emit() # Pour eviter de perdre la course avec jeu.gd, c'est jeu.gd qui lance afficher_musique	
	
func afficher_effets_sonores() -> void:
	var texte_sons: RichTextLabel = $Reglages/VBoxParent/HBoxReglagesFins/VBoxReglages/HBoxContainer4/TextSons
	if Globals.effets_sonores:
		texte_sons.text = tr("SONS_ON")
	else:
		texte_sons.text = tr("SONS_OFF")

func _on_check_sons_toggled(_toggled_on: bool) -> void:
	Globals.effets_sonores = not Globals.effets_sonores
	actualiser_affichage_reglages()
	

func actualiser_affichage_reglages() -> void:	
	afficher_langue()
	afficher_vitesse()
	afficher_musique()
	afficher_effets_sonores()
	afficher_fins()
	

