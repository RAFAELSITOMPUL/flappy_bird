extends Node

const SAVE_PATH = "user://savegame.dat"

var high_score: int = 0
var music_enabled: bool = true
var sfx_enabled: bool = true
var music_volume: float = 1.0 # 0.0 to 1.0
var sfx_volume: float = 1.0   # 0.0 to 1.0
var vibration_enabled: bool = true

# Graphics Settings
var graphics_quality: int = 2 # 0 = LOW, 1 = MEDIUM, 2 = HIGH
var fps_limit: int = 60       # 30, 60, 120, 0
var display_mode: int = 0     # 0 = Fullscreen, 1 = Borderless Fullscreen, 2 = Windowed
var resolution_w: int = 1280
var resolution_h: int = 720

func _ready() -> void:
	if not (OS.get_name() in ["Android", "iOS", "Web"]):
		var screen_size = DisplayServer.screen_get_size()
		if screen_size.x > 0 and screen_size.y > 0:
			resolution_w = min(1920, screen_size.x)
			resolution_h = min(1080, screen_size.y)
	load_game()

func save_game() -> void:
	var data: Dictionary = {
		"high_score": high_score,
		"music_enabled": music_enabled,
		"sfx_enabled": sfx_enabled,
		"music_volume": music_volume,
		"sfx_volume": sfx_volume,
		"vibration_enabled": vibration_enabled,
		"graphics_quality": graphics_quality,
		"fps_limit": fps_limit,
		"display_mode": display_mode,
		"resolution_w": resolution_w,
		"resolution_h": resolution_h
	}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(data)
		file.store_string(json_string)
		file.close()

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		apply_graphics_settings()
		return
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if parse_result == OK:
			var data = json.get_data()
			if data is Dictionary:
				high_score = data.get("high_score", 0)
				music_enabled = data.get("music_enabled", true)
				sfx_enabled = data.get("sfx_enabled", true)
				music_volume = data.get("music_volume", 1.0)
				sfx_volume = data.get("sfx_volume", 1.0)
				vibration_enabled = data.get("vibration_enabled", true)
				graphics_quality = data.get("graphics_quality", 2)
				fps_limit = data.get("fps_limit", 60)
				display_mode = data.get("display_mode", 0)
				resolution_w = data.get("resolution_w", 1280)
				resolution_h = data.get("resolution_h", 720)
				
	apply_graphics_settings()

func apply_graphics_settings() -> void:
	# 1. FPS Limit
	Engine.max_fps = fps_limit
	
	# 2. Graphics Quality Effect
	if GameManager.has_method("apply_quality_effects"):
		GameManager.apply_quality_effects(graphics_quality)
	
	# 3. Apply Display & Resolution (Desktop Windows/Linux/macOS)
	if not (OS.get_name() in ["Android", "iOS", "Web"]):
		apply_window_display_mode()

func apply_window_display_mode() -> void:
	var win = get_window()
	if not win:
		return
		
	var screen_idx = win.current_screen
	var usable_rect = DisplayServer.screen_get_usable_rect(screen_idx)
	
	match display_mode:
		0: # Fullscreen
			win.borderless = false
			win.mode = Window.MODE_FULLSCREEN
			print("[DisplayManager] Fullscreen Mode Applied on Screen #", screen_idx)
			
		1: # Borderless Fullscreen
			win.mode = Window.MODE_EXCLUSIVE_FULLSCREEN
			win.borderless = true
			print("[DisplayManager] Borderless Fullscreen Mode Applied on Screen #", screen_idx)
			
		2: # Windowed
			win.borderless = false
			win.mode = Window.MODE_WINDOWED
			
			var target_size = Vector2i(resolution_w, resolution_h)
			win.size = target_size
			
			# Center window on current monitor screen
			var centered_pos = usable_rect.position + (usable_rect.size - target_size) / 2
			win.position = Vector2i(max(0, centered_pos.x), max(0, centered_pos.y))
			print("[DisplayManager] Windowed Mode Applied: ", target_size, " Pos: ", win.position)

	# Validation verification output
	var actual_mode = win.mode
	var actual_size = win.size
	print("[DisplayManager Verification] Actual Mode: ", actual_mode, " | Actual Size: ", actual_size)

func reset_graphics_defaults() -> void:
	graphics_quality = 2
	fps_limit = 60
	display_mode = 0
	var screen_size = DisplayServer.screen_get_size()
	if screen_size.x > 0:
		resolution_w = min(1920, screen_size.x)
		resolution_h = min(1080, screen_size.y)
	apply_graphics_settings()
	save_game()

func update_high_score(new_score: int) -> bool:
	if new_score > high_score:
		high_score = new_score
		save_game()
		return true
	return false
