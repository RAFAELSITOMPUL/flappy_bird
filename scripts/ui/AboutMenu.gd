## AboutMenu.gd — Godot 4.7 GDScript
## Halaman About — informasi lengkap game Flappy Bird

extends Control

signal back_pressed

const DEVELOPER_NAME := "Rafael Sitompul"
const DEVELOPER_WHATSAPP := "6289509789282"
const GAME_VERSION := "1.0.0"

@onready var back_button: Button = %BackButton
@onready var whatsapp_button: Button = %WhatsAppButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	back_button.pressed.connect(_on_back_pressed)
	back_button.mouse_entered.connect(func(): AudioManager.play_sfx("button_hover"))
	
	if whatsapp_button:
		whatsapp_button.pressed.connect(_on_whatsapp_pressed)
		whatsapp_button.mouse_entered.connect(func(): AudioManager.play_sfx("button_hover"))

func show_about() -> void:
	visible = true
	modulate.a = 0.0
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.25)

func hide_about() -> void:
	visible = false

func _on_back_pressed() -> void:
	AudioManager.play_sfx("button_click")
	back_pressed.emit()

func _on_whatsapp_pressed() -> void:
	AudioManager.play_sfx("button_click")
	var wa_url := "https://wa.me/" + DEVELOPER_WHATSAPP
	print("[AboutMenu] Opening WhatsApp Link: ", wa_url)
	var err := OS.shell_open(wa_url)
	if err != OK:
		push_warning("[AboutMenu] Failed to open URL via OS.shell_open: " + str(err))
