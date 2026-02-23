extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugadores"):
		body.morir()
	elif body.is_in_group("enemigos"):
		body.dar_vuelta()
