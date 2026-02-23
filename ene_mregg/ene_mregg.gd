extends CharacterBody2D

@onready var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@export var speed = 100

var sentido = 1
func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	if is_on_wall():
		sentido = -sentido
	if sentido ==1 && $detectorIzquierdo.is_colliding():
		velocity.x = speed
		$ani_ene_dyn.flip_h = false
	else:
		sentido = -1
	if sentido == -1 && $detectorDerecho.is_colliding():
		velocity.x = -speed
		$ani_ene_dyn.flip_h = true
	else:
		sentido = 1
	move_and_slide()

func _ready() -> void:
	$ani_ene_dyn.play("default")

func _on_ene_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugadores"):
		get_tree().reload_current_scene()
