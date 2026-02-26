extends CharacterBody2D

@onready var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@export var speed = 101


@onready var ene_mosca_scene = load("res://enemigos/ene_mosca/ene_mosca.tscn")
var tiempo_lanzar = 0.0

var sentido = 1

func _ready() -> void:
	$ani_mregg.play("correr")
	add_to_group("enemigos")

func _on_ene_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugadores"):
		body.morir()
		set_physics_process(false)
	elif body.is_in_group("enemigos"):
		dar_vuelta()

func lanzar_mosca():
	if ene_mosca_scene:
		var mosca = ene_mosca_scene.instantiate()
		get_tree().current_scene.add_child(mosca)
		mosca.global_position = $spawn_mosca.global_position

func dar_vuelta():
	sentido = -sentido
	velocity.x = speed * sentido
	$ani_mregg.flip_h = (sentido == -1)

func _physics_process(delta: float) -> void:
	tiempo_lanzar -= delta
	if tiempo_lanzar <= 0:
		lanzar_mosca()
		tiempo_lanzar = 5
	
	velocity.y += gravity * delta
	if is_on_wall():
		dar_vuelta()
	if sentido ==1 && $detectorIzquierdo.is_colliding():
		velocity.x = speed
		$ani_mregg.flip_h = false
	else:
		sentido = -1
	if sentido == -1 && $detectorDerecho.is_colliding():
		velocity.x = -speed
		$ani_mregg.flip_h = true
	else:
		sentido = 1
	move_and_slide()
