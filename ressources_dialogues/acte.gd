class_name Acte extends Resource

@export var decor: Texture = null
@export var fond: Texture = preload("res://images_ui/fond_sombre.png")
@export var ligne_de_depart: int = 0
@export var dialogue: Dialogue
@export var bruitage: AudioStream
@export var duree_transition: float = 1
