extends CharacterBody2D

@export var gravity_scale = 2
@export var speed = 300
@export var sprint_speed = 450
@export var acceleration = 600
@export var friction = 1500
@export var boost = 80.0 
@export var jump_force = -700
@export var air_acceleration = 2000
@export var air_friction = 700

@export var vidas = 3

@export var total_monedas: int = 40

var ball = false
var monedas: int = 0
var posicion_inicio = Vector2(40, 495)

# @onready LOCALES solamente
@onready var ani_sonic = $ani_sonic
@onready var contador: Control = $CanvasLayer/Contador
@onready var contador_vidas: Control = $CanvasLayer/contador_vidas

func _ready() -> void:
	vidas = 3
	monedas = 0
	floor_snap_length = 4.0
	add_to_group("jugadores")
	contador.actualizar(0)
	contador_vidas.actualizar(vidas)


# ========== FUNCION PRINCIPAL ========== #
func _physics_process(delta: float) -> void:
	var input_axis = Input.get_axis("mover_izquierda","mover_derecha")
	apply_gravity(delta)
	handle_acceleration(input_axis, delta)
	handle_roll(delta)
	apply_friction(input_axis, delta)
	handle_jump()
	handle_air_acceleration(input_axis, delta)
	set_floor_max_angle(deg_to_rad(60))
	move_and_slide()
	update_animation(input_axis)


func apply_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta * gravity_scale

func handle_acceleration(input_axis, delta):
	if ball: return
	if not is_on_floor(): return
	if input_axis != 0:
		if Input.is_action_pressed("correr_rapido"):
			velocity.x = sprint_speed * input_axis
		else:
			velocity.x = speed * input_axis

func apply_friction(input_axis, delta):
	if ball: return
	if input_axis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction * delta)

func handle_jump():
	if is_on_floor():
		if Input.is_action_pressed("saltar"):
			velocity.y = jump_force

func handle_air_acceleration(input_axis, delta):
	if is_on_floor(): return
	if input_axis != 0:
		velocity.x = speed * input_axis

# ========== SISTEMA DE BOLA ========== #
func handle_roll(delta):
	if not ball:
		try_entrar_bola()
		return
	
	fisicas_bola_suelo(delta)
	try_salir_bola()

func try_entrar_bola():
	if is_on_floor() and Input.is_action_just_pressed("rodar") and abs(velocity.x) > 50:
			ball = true
			velocity.x += sign(velocity.x) * boost

func try_salir_bola():
	if Input.is_action_just_pressed("rodar") or abs(velocity.x) < 30:
		ball = false

func fisicas_bola_suelo(delta):
	if is_on_floor():
		var floor_normal = get_floor_normal()
		pendientes_bola(floor_normal, delta)
		friccion_bola(floor_normal, delta)

func pendientes_bola(floor_normal, delta):
	if abs(floor_normal.x) > 0.1:
			var slope_force = (1.0 - floor_normal.y) * sign(floor_normal.x)
			if sign(velocity.x) == sign(-floor_normal.x):
				slope_force *= 1
			else:
				slope_force *= 2.5
			velocity.x += slope_force * 300 * delta

func friccion_bola(floor_normal, delta):
	if floor_normal.y > 0.9:
		velocity.x = move_toward(velocity.x, 0, friction * 1 * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * 0.3 * delta)


# ========== FUNCION DE ANIMACIONES ========== #
func update_animation(input_axis):
	if ball:
		ani_sonic.play("rodar")
		return
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


# ========== SISTEMA DE MUERTE/RESPAWN ========== #
func morir():
	activar_fisicas(false)
	vidas -= 1
	contador_vidas.actualizar(vidas)
	ani_sonic.play("morir")
	await esperar_tiempo()
	morir_completo()

func morir_completo():
	if vidas <= 0:
		get_tree().change_scene_to_file("res://menus/menu_muerte/menu_muerte.tscn")
	else:
		respawnear()
		activar_fisicas(true)

func activar_fisicas(opcion: bool):
	set_physics_process(opcion)
	get_tree().call_group("enemigos", "set_physics_process", opcion)

func respawnear():
	global_position = posicion_inicio
	velocity = Vector2.ZERO
	ball = false
	ani_sonic.play("reposo")


# ========== MONEDAS ========== #
func add_moneda():
	$audio_moneda.play()
	monedas += 1
	contador.actualizar(monedas)
	
	if monedas >= total_monedas:
		victoria()


# ========== VIDAS EXTRA ==========
func add_vida():
	if vidas < 5:
		vidas += 1
		$audio_moneda.play()
	contador_vidas.actualizar(vidas)


# ========== VICTORIA ==========
func victoria():
	$audio_victoria.play()
	var personaje = get_tree().get_first_node_in_group("tiles")
	personaje.liberar()
	activar_fisicas(false)
	ani_sonic.play("victoria")
	await esperar_tiempo()
	get_tree().change_scene_to_file("res://menus/menu/menu.tscn")


# ========== TIEMPO ==========
func esperar_tiempo():
	$tiempo.start()
	await $tiempo.timeout
