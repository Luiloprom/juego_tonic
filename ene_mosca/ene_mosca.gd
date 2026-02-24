extends CharacterBody2D


@export var speed = 300
@onready var gravity: int = ProjectSettings.get("physics/2d/default_gravity")

var jugador = null

func _ready():
	$ani_mosca.play("default")
	$tiempo.start(4.0)  # Desaparece tras 4s
	

func _physics_process(delta):
	var jugador = get_tree().get_first_node_in_group("jugadores")
	velocity.y += gravity * delta * 0.5  # Gravedad ligera
	
	if jugador:
		var dir = (jugador.global_position - global_position).normalized()
		velocity = dir * speed  # ← SIN GRAVEDAD, directo a Sonic
		$ani_mosca.flip_h = dir.x < 0  # Flip sprite
	
	move_and_slide()

func _on_tiempo_timeout():
	queue_free()
