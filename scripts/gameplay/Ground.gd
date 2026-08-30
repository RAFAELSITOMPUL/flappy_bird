extends StaticBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var area: Area2D = $Area2D

var scroll_speed: float = 150.0
var texture_width: float = 500.0

func _ready() -> void:
	if area:
		area.body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	if GameManager.current_state == GameManager.GameState.PLAYING:
		scroll_speed = GameManager.current_pipe_speed
		sprite.position.x -= scroll_speed * delta
		if sprite.position.x <= - (texture_width / 2.0):
			sprite.position.x += (texture_width / 2.0)

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.has_method("die"):
		body.die()
