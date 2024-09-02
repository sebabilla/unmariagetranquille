extends Control

var coeur: Texture = preload("res://images_ui/coeur.png")
var coeur_brise: Texture = preload("res://images_ui/coeur_brise.png")


func _ready() -> void:
	Globals.connect("mise_a_jour_amour", _on_mise_a_jour_amour)
	$Amour/Coeur.hide()
	$Amour.value = Globals.amour

		
# Choisis l'animation quand le joueur fait un choix important
func _on_mise_a_jour_amour() -> void:
	if Globals.amour > $Amour.value:
		jouer_amour()
	if Globals.amour < $Amour.value:
		jouer_chagrin()
	$Amour.value = Globals.amour

# Affiche un petit coeur rose sous la barre d'amour
func jouer_amour() -> void:
	if Globals.effets_sonores:
		$Miaou.play()
	$Amour/Coeur.texture = coeur
	$Amour/Coeur.global_position -= Vector2(10, 5)
	$Amour/Coeur.show()	
	var tween = create_tween()
	tween.tween_property($Amour/Coeur, "scale", Vector2(2, 2), 0.2)
	await tween.finished
	$Amour/Coeur.hide()
	$Amour/Coeur.scale = Vector2(1, 1)
	$Amour/Coeur.global_position += Vector2(10, 5)

# Affiche un coeur brisé sous la barre d'amour	
func jouer_chagrin() -> void:
	if Globals.effets_sonores:
		$Bouh.play()
	$Amour/Coeur.texture = coeur_brise
	$Amour/Coeur.show()
	var position_actuelle: Vector2 = $Amour/Coeur.global_position
	var cible: Vector2 = position_actuelle + Vector2(0, 10)
	var tween = create_tween()
	tween.tween_property($Amour/Coeur, "global_position", cible, 0.2).from(position_actuelle)
	await tween.finished
	$Amour/Coeur.hide()
	$Amour/Coeur.global_position = position_actuelle
