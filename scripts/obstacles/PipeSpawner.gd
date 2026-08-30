extends Node2D

@export var pipe_scene: PackedScene

@onready var timer: Timer = $Timer

const MIN_Y: float = 200.0
const MAX_Y: float = 550.0
const SPAWN_X: float = 540.0

func _ready() -> void:
	if timer:
		timer.timeout.connect(_on_timer_timeout)

func start_spawning() -> void:
	clear_pipes()
	if timer:
		timer.wait_time = GameManager.current_spawn_interval
		timer.start()
	_spawn_pipe()

func stop_spawning() -> void:
	if timer:
		timer.stop()

func clear_pipes() -> void:
	for child in get_children():
		if child is Timer:
			continue
		child.queue_free()

func _on_timer_timeout() -> void:
	if GameManager.current_state == GameManager.GameState.PLAYING:
		_spawn_pipe()
		if timer:
			timer.wait_time = GameManager.current_spawn_interval

func _spawn_pipe() -> void:
	if not pipe_scene:
		return
		
	var pipe_instance = pipe_scene.instantiate() as Node2D
	var random_y = randf_range(MIN_Y, MAX_Y)
	pipe_instance.position = Vector2(SPAWN_X, 0)
	add_child(pipe_instance)
	
	if pipe_instance.has_signal("scored"):
		pipe_instance.scored.connect(_on_pipe_scored)
		
	if pipe_instance.has_method("configure"):
		pipe_instance.configure(random_y, GameManager.current_pipe_speed, GameManager.current_pipe_gap)

func _on_pipe_scored() -> void:
	if GameManager.current_state == GameManager.GameState.PLAYING:
		GameManager.add_score(1)
