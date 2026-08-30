extends Node

signal score_changed(new_score: int)
signal high_score_updated(new_high_score: int)
signal state_changed(new_state: GameState)
signal quality_changed(new_quality: int)

enum GameState {
	MENU,
	PLAYING,
	PAUSED,
	GAME_OVER,
	SETTINGS,
	ABOUT
}

# Aliases for compatibility
const MENU = GameState.MENU
const PLAYING = GameState.PLAYING
const PAUSED = GameState.PAUSED
const GAME_OVER = GameState.GAME_OVER
const SETTINGS = GameState.SETTINGS
const ABOUT = GameState.ABOUT

var current_state: GameState = GameState.MENU
var state: GameState:
	get:
		return current_state

var current_score: int = 0
var is_new_high_score: bool = false

# Base difficulty parameters
const BASE_PIPE_SPEED: float = 150.0
const BASE_SPAWN_INTERVAL: float = 1.8
const BASE_PIPE_GAP: float = 140.0

var current_pipe_speed: float = BASE_PIPE_SPEED
var current_spawn_interval: float = BASE_SPAWN_INTERVAL
var current_pipe_gap: float = BASE_PIPE_GAP

func _ready() -> void:
	change_state(GameState.MENU)

func change_state(new_state: GameState) -> void:
	current_state = new_state
	
	match new_state:
		GameState.MENU:
			get_tree().paused = false
			AudioManager.play_music("menu_theme")
		GameState.PLAYING:
			get_tree().paused = false
			AudioManager.play_music("gameplay_theme")
		GameState.PAUSED:
			get_tree().paused = true
		GameState.GAME_OVER:
			get_tree().paused = false
		GameState.SETTINGS:
			get_tree().paused = false
		GameState.ABOUT:
			get_tree().paused = false
			
	emit_signal("state_changed", new_state)

func apply_quality_effects(quality_level: int) -> void:
	# 0 = LOW, 1 = MEDIUM, 2 = HIGH
	print("[GameManager] Graphics Quality Applied: ", quality_level)

	# MSAA 2D tidak didukung pada gl_compatibility (GLES3)
	var render_method: String = ProjectSettings.get_setting(
		"rendering/renderer/rendering_method", "forward_plus")
	if render_method == "gl_compatibility":
		print("[GameManager] MSAA dilewati — gl_compatibility tidak support MSAA 2D")
		emit_signal("quality_changed", quality_level)
		return

	match quality_level:
		0: # LOW
			RenderingServer.viewport_set_msaa_2d(get_viewport().get_viewport_rid(), RenderingServer.VIEWPORT_MSAA_DISABLED)
		1: # MEDIUM
			RenderingServer.viewport_set_msaa_2d(get_viewport().get_viewport_rid(), RenderingServer.VIEWPORT_MSAA_2X)
		2: # HIGH
			RenderingServer.viewport_set_msaa_2d(get_viewport().get_viewport_rid(), RenderingServer.VIEWPORT_MSAA_4X)

	emit_signal("quality_changed", quality_level)

func start_game() -> void:
	current_score = 0
	is_new_high_score = false
	reset_difficulty()
	emit_signal("score_changed", current_score)
	change_state(GameState.PLAYING)

func add_score(amount: int = 1) -> void:
	if current_state != GameState.PLAYING:
		return
		
	current_score += amount
	emit_signal("score_changed", current_score)
	AudioManager.play_sfx("score")
	
	if current_score > SaveManager.high_score:
		is_new_high_score = true
		SaveManager.update_high_score(current_score)
		emit_signal("high_score_updated", SaveManager.high_score)
		
	_update_difficulty()

func game_over() -> void:
	if current_state == GameState.GAME_OVER:
		return
		
	AudioManager.play_sfx("hit")
	AudioManager.play_sfx("game_over")
	
	if current_score > SaveManager.high_score:
		is_new_high_score = true
		SaveManager.update_high_score(current_score)
		emit_signal("high_score_updated", SaveManager.high_score)
		
	change_state(GameState.GAME_OVER)

func reset_difficulty() -> void:
	current_pipe_speed = BASE_PIPE_SPEED
	current_spawn_interval = BASE_SPAWN_INTERVAL
	current_pipe_gap = BASE_PIPE_GAP

func _update_difficulty() -> void:
	var difficulty_factor = clamp(float(current_score) / 30.0, 0.0, 1.0)
	current_pipe_speed = BASE_PIPE_SPEED + (60.0 * difficulty_factor)
	current_spawn_interval = max(1.1, BASE_SPAWN_INTERVAL - (0.4 * difficulty_factor))
	current_pipe_gap = max(105.0, BASE_PIPE_GAP - (30.0 * difficulty_factor))
