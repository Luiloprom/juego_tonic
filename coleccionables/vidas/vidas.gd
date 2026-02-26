extends Area2D

func _ready():
	$spr_vida.frame = 0

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugadores"):
		body.add_vida()
		queue_free()
