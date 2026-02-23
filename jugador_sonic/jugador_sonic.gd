extends CharacterBody2D

@export var gravity_scale = 2

@export var speed = 300
@export var sprint_speed = 600
@export var acceleration = 600
@export var friction = 1500

@export var jump_force = -700
@export var air_acceleration = 2000
@export var air_friction = 700

@onready var ani_sonic = $ani_sonic

func apply_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta * gravity_scale

func handle_acceleration(input_axis, delta):
	if not is_on_floor(): 
		return
	if input_axis != 0:
		if Input.is_action_pressed("correr_rapido"):
			velocity.x = sprint_speed * input_axis
		else:
			velocity.x = speed * input_axis

func apply_friction(input_axis, delta):
	if input_axis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction * delta)

func handle_jump():
	if is_on_floor():
		if Input.is_action_pressed("saltar"):
			velocity.y = jump_force

func handle_air_acceleration(input_axis, delta):
	if is_on_floor(): 
		return
	if input_axis != 0:
		velocity.x = speed * input_axis

func update_animation(input_axis):
	if input_axis != 0:
		ani_sonic.flip_h = (input_axis < 0)
	if not is_on_floor():
		ani_sonic.play("saltar")
	elif input_axis == 0 and abs(velocity.x) > 10:
		ani_sonic.play("deslizar")
	elif input_axis != 0:
		if Input.is_action_pressed("correr_rapido"):
			ani_sonic.play("correr_rapido")
		else:
			ani_sonic.play("correr")
	else:
		ani_sonic.play("reposo")

func _physics_process(delta: float) -> void:
	var input_axis = Input.get_axis("mover_izquierda","mover_derecha")
	apply_gravity(delta)
	handle_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	handle_jump()
	handle_air_acceleration(input_axis, delta)
	set_floor_max_angle(deg_to_rad(60))
	move_and_slide()
	update_animation(input_axis)

func morir():
	set_physics_process(false)
	$ani_sonic.play("morir")
	$tiempo.start()
	await $tiempo.timeout
	get_tree().change_scene_to_file("res://menu/menu.tscn")
	
func _ready() -> void:
	floor_snap_length = 4.0
	add_to_group("jugadores")
	contador.actualizar(0)
	
	
# Referencia al contador
@onready var contador: Control = $CanvasLayer/Contador

# Contador de monedas
var monedas: int = 0


# Agrega una moneda al contador del jugador
func add_moneda():
	$audio_moneda.play()
	monedas+=1
	contador.actualizar(monedas)
