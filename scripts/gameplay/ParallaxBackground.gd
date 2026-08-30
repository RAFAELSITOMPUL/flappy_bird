extends ParallaxBackground

@export var scroll_speed: float = 80.0

func _process(delta: float) -> void:
	if GameManager.current_state == GameManager.GameState.PLAYING:
		scroll_offset.x -= scroll_speed * delta
