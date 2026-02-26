extends Control

func _ready() -> void:
	$hbox/ani_contador.play("default")

func actualizar(monedas:int):
	$hbox/lbl_contador.text = str(monedas)
