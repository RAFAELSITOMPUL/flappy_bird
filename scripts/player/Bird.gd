extends CharacterBody2D

signal died

@export var gravity: float = 900.0
@export var flap_strength: float = -320.0
@export var max_fall_speed: float = 500.0
@export var rotation_speed: float = 8.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var is_alive: bool = true
var is_active: bool = false
var initial_position: Vector2

func _ready() -> void:
	add_to_group("player")
	initial_position = global_position
	reset()

func reset() -> void:
	global_position = initial_position
	velocity = Vector2.ZERO
	rotation = 0.0
	is_alive = true
	is_active = false
	if animated_sprite:
		animated_sprite.play("fly")

func start() -> void:
	is_active = true
	is_alive = true
	flap()

func _physics_process(delta: float) -> void:
	if not is_active:
		velocity = Vector2.ZERO
		return
		
	if not is_alive:
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, max_fall_speed)
		rotation = lerp_angle(rotation, deg_to_rad(70.0), rotation_speed * delta)
		move_and_slide()
		return

	# Handle Flap Input
	if Input.is_action_just_pressed("flap"):
		flap()

	# Apply Gravity
	velocity.y += gravity * delta
	velocity.y = min(velocity.y, max_fall_speed)

	# Handle Rotation
	if velocity.y < 0:
		rotation = lerp_angle(rotation, deg_to_rad(-25.0), rotation_speed * delta * 2)
	else:
		rotation = lerp_angle(rotation, deg_to_rad(70.0), rotation_speed * delta * 0.8)

	var collided = move_and_slide()
	if collided or get_slide_collision_count() > 0:
		die()

	# Boundary check top of screen
	if global_position.y < 0:
		global_position.y = 0
		velocity.y = 0

func flap() -> void:
	if not is_alive or GameManager.current_state != GameManager.GameState.PLAYING:
		return
		
	velocity.y = flap_strength
	rotation = deg_to_rad(-25.0)
	AudioManager.play_sfx("flap")

func die() -> void:
	if not is_alive:
		return
		
	is_alive = false
	if animated_sprite:
		animated_sprite.stop()
	emit_signal("died")
	GameManager.game_over()
