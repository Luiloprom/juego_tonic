extends Control

func _ready():
	$hbox/lbl_contador_vidas.text = "3"

func actualizar(vidas: int):
	$hbox/lbl_contador_vidas.text = str(vidas)
