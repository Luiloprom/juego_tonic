extends CharacterBody2D

func _ready():
	set_collision_mask_value(1, false)
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING 
	$ani_mosca.play("volar")
	$tiempo.start(4.0)

func _physics_process(_delta):
	velocity.y = 0.0  # ← FUERZA Y a 0 cada frame
	
	var jugador = get_tree().get_first_node_in_group("jugadores")
	if jugador == null:
		return
	var dx = jugador.global_position.x - global_position.x
	var dy = jugador.global_position.y - global_position.y
	var len = sqrt(dx * dx + dy * dy)
	if len < 1.0:
		return
	velocity.x = (dx / len) * 150.0
	velocity.y = (dy / len) * 150.0
	move_and_slide()


func _on_tiempo_timeout():
	queue_free()
