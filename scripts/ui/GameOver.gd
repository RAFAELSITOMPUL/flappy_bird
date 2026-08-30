extends Control

signal retry_pressed
signal menu_pressed

@onready var score_value_label: Label = %ScoreValueLabel
@onready var best_value_label: Label = %BestValueLabel
@onready var new_record_label: Label = %NewRecordLabel
@onready var retry_button: Button = %RetryButton
@onready var menu_button: Button = %MenuButton
@onready var panel_container: PanelContainer = %PanelContainer

func _ready() -> void:
	retry_button.pressed.connect(_on_retry_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	
	retry_button.mouse_entered.connect(_on_button_hover)
	menu_button.mouse_entered.connect(_on_button_hover)

func show_game_over() -> void:
	visible = true
	score_value_label.text = str(GameManager.current_score)
	best_value_label.text = str(SaveManager.high_score)
	
	if new_record_label:
		new_record_label.visible = GameManager.is_new_high_score
	
	if panel_container:
		panel_container.pivot_offset = panel_container.size / 2.0
		panel_container.modulate.a = 0.0
		var tween = create_tween()
		tween.tween_property(panel_container, "modulate:a", 1.0, 0.3)

func _on_button_hover() -> void:
	AudioManager.play_sfx("button_hover")

func _on_retry_pressed() -> void:
	AudioManager.play_sfx("button_click")
	emit_signal("retry_pressed")

func _on_menu_pressed() -> void:
	AudioManager.play_sfx("button_click")
	emit_signal("menu_pressed")
