extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ani_tiles.play("default")
	$celda_tiles.visible = true
	add_to_group("tiles")

func liberar():
	$celda_tiles.visible = false # Animación libertad
