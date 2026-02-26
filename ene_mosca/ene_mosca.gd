extends CharacterBody2D

@export var speed = 300

var jugador = null

func _ready():
	jugador = get_tree().get_first_node_in_group("jugadores")
	add_to_group("enemigos")
	$ani_mosca.play("volar")
	$tiempo.start(4.0)

func dar_vuelta(): return

func _physics_process(delta: float) -> void:
	seguir()

func seguir():
	if jugador != null:
		velocity = position.direction_to(jugador.position) * speed
		var direccion_x = jugador.position.x - position.x  
		$ani_mosca.flip_h = direccion_x > 0  
		move_and_slide()

func _on_tiempo_timeout():
	queue_free()
	
func _on_mosca_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugadores"):
		body.morir()
