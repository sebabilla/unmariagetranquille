extends ColorRect

signal fini

func transition_vers_noir(duree) -> void:
	show()
	var assombrir: Tween = create_tween()
	assombrir.tween_property(self, "color:a", 1, duree).from(0)
	await assombrir.finished
	fini.emit()
	
func transition_vers_transparent(duree) -> void:
	var eclaircir: Tween = create_tween()
	eclaircir.tween_property(self, "color:a", 0, duree)
	await eclaircir.finished
	hide()
	fini.emit()
