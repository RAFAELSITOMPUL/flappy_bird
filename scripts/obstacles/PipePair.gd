extends Node2D

signal scored

@export var speed: float = 190.0
var counted: bool = false

@onready var top_pipe: StaticBody2D = $TopPipe
@onready var bottom_pipe: StaticBody2D = $BottomPipe
@onready var score_area: Area2D = $ScoreArea

const PIPE_HEIGHT: float = 400.0
const PIPE_WIDTH: float = 48.0

func _ready() -> void:
	if score_area and not score_area.body_entered.is_connected(_on_score_body_entered):
		score_area.body_entered.connect(_on_score_body_entered)

func configure(gap_center: float, pipe_speed: float, gap_height: float = 140.0) -> void:
	speed = pipe_speed
	counted = false
	
	var half_gap = gap_height / 2.0
	
	if top_pipe:
		top_pipe.position = Vector2(0, gap_center - half_gap)
	if bottom_pipe:
		bottom_pipe.position = Vector2(0, gap_center + half_gap)
	if score_area:
		score_area.position = Vector2(0, gap_center)
		var score_shape = score_area.get_node_or_null("CollisionShape2D") as CollisionShape2D
		if score_shape and score_shape.shape is RectangleShape2D:
			score_shape.shape.size = Vector2(20, gap_height)

func _physics_process(delta: float) -> void:
	if GameManager.current_state != GameManager.GameState.PLAYING:
		return
		
	position.x -= speed * delta
	
	if position.x < -100.0:
		queue_free()

func _on_score_body_entered(body: Node) -> void:
	if counted:
		return
		
	if body.is_in_group("player") or (body is CharacterBody2D and body.has_method("flap")):
		counted = true
		scored.emit()
