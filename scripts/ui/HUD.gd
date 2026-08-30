extends Control

@onready var score_label: Label = %ScoreLabel
@onready var pause_button: Button = %PauseButton

func _ready() -> void:
	GameManager.score_changed.connect(_on_score_changed)
	if pause_button:
		pause_button.pressed.connect(_on_pause_button_pressed)
	update_score(0)

func update_score(new_score: int) -> void:
	if score_label:
		score_label.text = str(new_score)
		# Pop animation on score increase
		var tween = create_tween()
		tween.tween_property(score_label, "scale", Vector2(1.2, 1.2), 0.08)
		tween.tween_property(score_label, "scale", Vector2(1.0, 1.0), 0.08)

func _on_score_changed(new_score: int) -> void:
	update_score(new_score)

func _on_pause_button_pressed() -> void:
	AudioManager.play_sfx("button")
	GameManager.change_state(GameManager.GameState.PAUSED)
