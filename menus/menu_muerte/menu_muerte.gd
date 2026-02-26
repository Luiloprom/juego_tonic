extends Control  # ← CAMBIA CanvasLayer → Control

func mostrar_menu():
	get_tree().paused = true
	visible = true

func _on_btn_reiniciar_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://entorno/environment/environment.tscn")


func _on_btn_menu_principal_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menus/menu/menu.tscn")
