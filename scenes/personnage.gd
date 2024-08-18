extends TextureRect

signal ligne_de_dialogue_affichee

var nom_du_personnage: String
var personnages: Array[Texture] = [
	preload("res://images_personnages/personnage_vide.png"),
	preload("res://images_personnages/toi2.png"),
	preload("res://images_personnages/dieu2.png"),
	preload("res://images_personnages/gabriel2.png"),
	preload("res://images_personnages/mariposa2.png"),
	preload("res://images_personnages/manuel2.png"),
	preload("res://images_personnages/lorena2.png"),
	preload("res://images_personnages/pretre2.png"),
	preload("res://images_personnages/mariposa_et_toi2.png"),
	preload("res://images_personnages/dieu_et_lorena2.png"),
	preload("res://images_personnages/dieu_et_manuel2.png"),
]
var emotions: Array[Texture] = [
	preload("res://images_personnages/emotion_vide.png"),
	preload("res://images_personnages/peur.png"),
	preload("res://images_personnages/colere.png"),
	preload("res://images_personnages/tristesse.png"),
	preload("res://images_personnages/gene.png"),
	preload("res://images_personnages/neutralite.png"),
	preload("res://images_personnages/surprise.png"),
	preload("res://images_personnages/joie.png"),
	preload("res://images_personnages/extase.png")
]

func _ready() -> void:
	afficher_nouveau_personnage("VIDE")
	cacher_replique()

func lire_ligne(ligne: Ligne) -> void:
	cacher_replique()
	if ligne.code_personnage != nom_du_personnage:
		afficher_nouveau_personnage(ligne.code_personnage)
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(1, 1), 0.2).from(Vector2(0.5, 0.5))
		await tween.finished
	afficher_texte_replique(ligne.code_traduction)
	afficher_emoji(ligne.emotion)
	montrer_replique()

func afficher_nouveau_personnage(nom: String) -> void:
	nom_du_personnage = nom
	afficher_image()
	
func afficher_image() -> void:
	match nom_du_personnage:
		"VIDE":
			texture = personnages[0]
		"TOI":
			texture = personnages[1]
		"DIEU":
			texture = personnages[2]
		"GABRIEL":
			texture = personnages[3]
		"MARIPOSA":
			texture = personnages[4]
		"MANUEL":
			texture = personnages[5]
		"LORENA":
			texture = personnages[6]
		"PRETRE":
			texture = personnages[7]
		"MARIPOSA_ET_TOI":
			texture = personnages[8]
		"DIEU_ET_LORENA":
			texture = personnages[9]
		"DIEU_ET_MANUEL":
			texture = personnages[10]
		"DEV":
			texture = personnages[0]	
		_:
			push_error("L'image du personnage n'existe pas.")
			
func afficher_emoji(emo: String) -> void:
	match emo:
		"RIEN":
			$Emoji.texture = emotions[0]
		"PEUR":
			$Emoji.texture = emotions[1]
		"COLERE":
			$Emoji.texture = emotions[2]
		"TRISTESSE":
			$Emoji.texture = emotions[3]
		"GENE":
			$Emoji.texture = emotions[4]
		"NEUTRALITE":
			$Emoji.texture = emotions[5]
		"SURPRISE":
			$Emoji.texture = emotions[6]
		"JOIE":
			$Emoji.texture = emotions[7]
		"EXTASE":
			$Emoji.texture = emotions[8]
		_:
			push_error("L'émoji de l'émotion n'existe pas.")
	

func afficher_texte_replique(rep: String) -> void:
	var noeud: RichTextLabel = $FondDialogue/MarginContainer/LigneDeDialogue
	if nom_du_personnage == "VIDE":
		noeud.text = "[b]" + tr(rep) + "[/b]"
		on_lecture_ligne_complete()
		return
	noeud.text = "[b]" + tr(nom_du_personnage) + " : [/b]"+ tr(rep)
	var taille_texte := noeud.text.length()
	var debut_texte := nom_du_personnage.length()
	var temps := taille_texte/Globals.vitesse_de_lecture
	var lecture_ligne: Tween = create_tween()
	lecture_ligne.tween_property(noeud,"visible_characters", taille_texte, temps).from(debut_texte)
	lecture_ligne.connect("finished", on_lecture_ligne_complete)

func cacher_replique() -> void:
	$FondDialogue.hide()
	$Emoji.hide()
	
func montrer_replique() -> void:
	$FondDialogue.show()
	$Emoji.show()

func on_lecture_ligne_complete():
	$FondDialogue/MarginContainer/LigneDeDialogue.visible_characters = -1
	ligne_de_dialogue_affichee.emit()


func _on_ligne_de_dialogue_meta_clicked(meta: Variant) -> void:
	OS.shell_open(meta)
