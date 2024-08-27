extends RichTextLabel

var nombre_de_ligne: int = 1
var ligne_actuelle: float = nombre_de_ligne

# Pour pouvoir scroller à la manette, sinon fonctionne avec les fleches du clavier, des fois, mais pas la manette...
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_down"):
		if ligne_actuelle < nombre_de_ligne:
			ligne_actuelle += 20 * delta
			scroll_to_line(int(ligne_actuelle))
	elif Input.is_action_pressed("ui_up"):
		if ligne_actuelle > 1:
			ligne_actuelle -= 20 * delta
			scroll_to_line(int(ligne_actuelle))

# Positionner le recap vers le dernier dialogue lu par le joueur
func ouverture() -> void:
	nombre_de_ligne = get_line_count()
	if nombre_de_ligne < 8:
		scroll_to_line(1)
	else:
		ligne_actuelle = nombre_de_ligne - 8
		scroll_to_line(int(ligne_actuelle))
