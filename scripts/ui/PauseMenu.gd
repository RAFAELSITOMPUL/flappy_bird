extends Control

signal resume_pressed
signal restart_pressed
signal menu_pressed

@onready var resume_button: Button = %ResumeButton
@onready var restart_button: Button = %RestartButton
@onready var menu_button: Button = %MenuButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	resume_button.pressed.connect(_on_resume_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	
	resume_button.mouse_entered.connect(_on_button_hover)
	restart_button.mouse_entered.connect(_on_button_hover)
	menu_button.mouse_entered.connect(_on_button_hover)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if GameManager.current_state == GameManager.GameState.PLAYING:
			GameManager.change_state(GameManager.GameState.PAUSED)
			get_viewport().set_input_as_handled()
		elif GameManager.current_state == GameManager.GameState.PAUSED:
			GameManager.change_state(GameManager.GameState.PLAYING)
			get_viewport().set_input_as_handled()

func _on_button_hover() -> void:
	AudioManager.play_sfx("button_hover")

func _on_resume_pressed() -> void:
	AudioManager.play_sfx("button_click")
	GameManager.change_state(GameManager.GameState.PLAYING)

func _on_restart_pressed() -> void:
	AudioManager.play_sfx("button_click")
	emit_signal("restart_pressed")

func _on_menu_pressed() -> void:
	AudioManager.play_sfx("button_click")
	emit_signal("menu_pressed")
