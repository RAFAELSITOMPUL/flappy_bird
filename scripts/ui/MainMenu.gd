## MainMenu.gd
## Godot 4.7 GDScript
## Main Menu — PLAY / SETTINGS / ABOUT / QUIT

extends Control

signal play_pressed
signal settings_pressed
signal about_pressed

@onready var title_label:    Label        = %TitleLabel
@onready var high_score_label: Label      = %HighScoreLabel
@onready var play_button:    Button       = %PlayButton
@onready var settings_button: Button      = %SettingsButton
@onready var about_button:   Button       = %AboutButton
@onready var quit_button:    Button       = %QuitButton
@onready var main_container: VBoxContainer = %MainContainer

func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	about_button.pressed.connect(_on_about_pressed)

	play_button.mouse_entered.connect(_on_button_hover)
	settings_button.mouse_entered.connect(_on_button_hover)
	about_button.mouse_entered.connect(_on_button_hover)

	if quit_button:
		quit_button.mouse_entered.connect(_on_button_hover)
		if OS.get_name() in ["Android", "iOS", "Web"]:
			quit_button.visible = false
		else:
			quit_button.pressed.connect(_on_quit_pressed)

func show_menu() -> void:
	visible = true
	update_high_score()
	if main_container:
		main_container.modulate.a = 0.0
		var tween := create_tween()
		tween.tween_property(main_container, "modulate:a", 1.0, 0.3)

func hide_menu() -> void:
	visible = false

func update_high_score() -> void:
	if high_score_label:
		high_score_label.text = "HIGH SCORE: " + str(SaveManager.high_score)

func _on_button_hover() -> void:
	AudioManager.play_sfx("button_hover")

func _on_play_pressed() -> void:
	AudioManager.play_sfx("button_click")
	play_pressed.emit()

func _on_settings_pressed() -> void:
	AudioManager.play_sfx("button_click")
	settings_pressed.emit()

func _on_about_pressed() -> void:
	AudioManager.play_sfx("button_click")
	about_pressed.emit()

func _on_quit_pressed() -> void:
	AudioManager.play_sfx("button_click")
	get_tree().quit()
