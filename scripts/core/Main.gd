## Main.gd
## Godot 4.7 GDScript
## Orchestrator utama — mengelola semua state dan UI

extends Node2D

@onready var bird:          CharacterBody2D = %Bird
@onready var pipe_spawner:  Node2D          = %PipeSpawner
@onready var main_menu:     Control         = %MainMenu
@onready var hud:           Control         = %HUD
@onready var pause_menu:    Control         = %PauseMenu
@onready var game_over_menu:Control         = %GameOver
@onready var settings_menu: Control         = %Settings
@onready var about_menu:    Control         = %AboutMenu

func _ready() -> void:
	GameManager.state_changed.connect(_on_state_changed)

	# Connect UI Signals
	main_menu.play_pressed.connect(_on_play_pressed)
	main_menu.settings_pressed.connect(_on_settings_pressed)
	main_menu.about_pressed.connect(_on_about_pressed)
	pause_menu.restart_pressed.connect(_on_restart_pressed)
	pause_menu.menu_pressed.connect(_on_menu_pressed)
	game_over_menu.retry_pressed.connect(_on_restart_pressed)
	game_over_menu.menu_pressed.connect(_on_menu_pressed)
	settings_menu.back_pressed.connect(_on_menu_pressed)
	about_menu.back_pressed.connect(_on_menu_pressed)

	# Start on Main Menu state
	GameManager.change_state(GameManager.GameState.MENU)

func _on_state_changed(new_state: GameManager.GameState) -> void:
	# Sembunyikan semua UI terlebih dahulu
	main_menu.visible      = false
	hud.visible            = false
	pause_menu.visible     = false
	game_over_menu.visible = false
	settings_menu.visible  = false
	about_menu.visible     = false

	match new_state:
		GameManager.GameState.MENU:
			AudioManager.play_music("menu_theme")
			main_menu.show_menu()
			if bird:
				bird.reset()
			if pipe_spawner:
				pipe_spawner.stop_spawning()
				pipe_spawner.clear_pipes()

		GameManager.GameState.PLAYING:
			AudioManager.play_music("gameplay_theme")
			hud.visible = true
			if bird:
				if not bird.is_active:
					bird.start()
			if pipe_spawner:
				if pipe_spawner.timer.is_stopped():
					pipe_spawner.start_spawning()

		GameManager.GameState.PAUSED:
			AudioManager.play_sfx("pause")
			hud.visible = true
			pause_menu.visible = true

		GameManager.GameState.GAME_OVER:
			hud.visible = true
			game_over_menu.show_game_over()
			if pipe_spawner:
				pipe_spawner.stop_spawning()

		GameManager.GameState.SETTINGS:
			settings_menu.load_values()
			settings_menu.visible = true

		GameManager.GameState.ABOUT:
			about_menu.show_about()

func _on_play_pressed() -> void:
	GameManager.start_game()

func _on_settings_pressed() -> void:
	GameManager.change_state(GameManager.GameState.SETTINGS)

func _on_about_pressed() -> void:
	GameManager.change_state(GameManager.GameState.ABOUT)

func _on_restart_pressed() -> void:
	if pipe_spawner:
		pipe_spawner.clear_pipes()
	if bird:
		bird.reset()
	GameManager.start_game()

func _on_menu_pressed() -> void:
	GameManager.change_state(GameManager.GameState.MENU)
