## DisplaySettings.gd
## Godot 4.7 GDScript — Autoload Singleton
## Bertanggung jawab atas: Fullscreen, Borderless Fullscreen, Windowed,
## Resolution, FPS, Graphics Quality, Save, Load, Reset, Validate.

extends Node

# ─────────────────────────────────────────────────────────────────────
# SIGNAL
# ─────────────────────────────────────────────────────────────────────
signal display_settings_changed

# ─────────────────────────────────────────────────────────────────────
# KONSTANTA
# ─────────────────────────────────────────────────────────────────────
const STANDARD_RESOLUTIONS: Array[Vector2i] = [
	Vector2i(1280, 720),
	Vector2i(1280, 800),
	Vector2i(1360, 768),
	Vector2i(1366, 768),
	Vector2i(1440, 900),
	Vector2i(1600, 900),
	Vector2i(1600, 1200),
	Vector2i(1680, 1050),
	Vector2i(1920, 1080),
	Vector2i(1920, 1200),
	Vector2i(2560, 1080),
	Vector2i(2560, 1440),
	Vector2i(2560, 1600),
	Vector2i(3440, 1440),
	Vector2i(3840, 2160),
]

# ─────────────────────────────────────────────────────────────────────
# VARIABEL STATE
# ─────────────────────────────────────────────────────────────────────
var display_mode: int = 0
var resolution_w: int = 1280
var resolution_h: int = 720
var fps_target: int = 60
var graphics_quality: int = 2

func _get_settings_path() -> String:
	var dm = Engine.get_singleton("DataManager") if Engine.has_singleton("DataManager") else null
	if dm == null:
		dm = get_node_or_null("/root/DataManager")
	if dm and dm.has_method("get_settings_path"):
		return dm.get_settings_path()
	return "user://settings.cfg"

# ─────────────────────────────────────────────────────────────────────
# READY
# ─────────────────────────────────────────────────────────────────────
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_auto_detect_monitor_defaults()
	load_settings()

# ─────────────────────────────────────────────────────────────────────
# DETEKSI MONITOR
# ─────────────────────────────────────────────────────────────────────
func _auto_detect_monitor_defaults() -> void:
	if OS.get_name() in ["Android", "iOS", "Web"]:
		return
	var screen_size: Vector2i = DisplayServer.screen_get_size()
	if screen_size.x > 0 and screen_size.y > 0:
		resolution_w = min(1920, screen_size.x)
		resolution_h = min(1080, screen_size.y)

func get_available_resolutions() -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	if OS.get_name() in ["Android", "iOS", "Web"]:
		result.append(Vector2i(resolution_w, resolution_h))
		return result

	var screen_size: Vector2i = DisplayServer.screen_get_size()
	for res in STANDARD_RESOLUTIONS:
		if screen_size.x <= 0:
			result.append(res)
		elif res.x <= screen_size.x and res.y <= screen_size.y:
			result.append(res)

	if result.is_empty():
		result.append(Vector2i(1280, 720))
	return result

# ─────────────────────────────────────────────────────────────────────
# APPLY DISPLAY MODE
# ─────────────────────────────────────────────────────────────────────
func apply_display_mode(mode_id: int) -> void:
	display_mode = mode_id

	if OS.get_name() in ["Android", "iOS", "Web"]:
		return

	var win: Window = get_window()
	if not is_instance_valid(win):
		return

	var screen_idx: int = win.current_screen
	var usable_rect: Rect2i = DisplayServer.screen_get_usable_rect(screen_idx)

	match mode_id:
		0: # FULLSCREEN
			win.borderless = false
			win.mode = Window.MODE_FULLSCREEN
		1: # BORDERLESS FULLSCREEN
			win.borderless = true
			win.mode = Window.MODE_EXCLUSIVE_FULLSCREEN
		2: # WINDOWED
			win.borderless = false
			win.mode = Window.MODE_WINDOWED
			var target_size := Vector2i(resolution_w, resolution_h)
			win.size = target_size
			var center_pos := usable_rect.position + (usable_rect.size - target_size) / 2
			win.position = Vector2i(maxi(0, center_pos.x), maxi(0, center_pos.y))

# ─────────────────────────────────────────────────────────────────────
# APPLY RESOLUTION
# ─────────────────────────────────────────────────────────────────────
func apply_resolution(width: int, height: int) -> void:
	resolution_w = width
	resolution_h = height

	if OS.get_name() in ["Android", "iOS", "Web"]:
		return

	var win: Window = get_window()
	if not is_instance_valid(win):
		return

	if display_mode == 2:
		var target_size := Vector2i(width, height)
		win.size = target_size
		var screen_idx: int = win.current_screen
		var usable_rect: Rect2i = DisplayServer.screen_get_usable_rect(screen_idx)
		var center_pos := usable_rect.position + (usable_rect.size - target_size) / 2
		win.position = Vector2i(maxi(0, center_pos.x), maxi(0, center_pos.y))

# ─────────────────────────────────────────────────────────────────────
# APPLY FPS
# ─────────────────────────────────────────────────────────────────────
func apply_fps(fps: int) -> void:
	fps_target = fps
	Engine.max_fps = fps

# ─────────────────────────────────────────────────────────────────────
# APPLY GRAPHICS QUALITY
# ─────────────────────────────────────────────────────────────────────
func apply_graphics_quality(quality_id: int) -> void:
	graphics_quality = quality_id

	var render_method: String = ProjectSettings.get_setting(
		"rendering/renderer/rendering_method", "forward_plus")

	if render_method == "gl_compatibility":
		return

	var rid: RID = get_viewport().get_viewport_rid()
	match quality_id:
		0:
			RenderingServer.viewport_set_msaa_2d(rid, RenderingServer.VIEWPORT_MSAA_DISABLED)
		1:
			RenderingServer.viewport_set_msaa_2d(rid, RenderingServer.VIEWPORT_MSAA_2X)
		2:
			RenderingServer.viewport_set_msaa_2d(rid, RenderingServer.VIEWPORT_MSAA_4X)

# ─────────────────────────────────────────────────────────────────────
# APPLY ALL
# ─────────────────────────────────────────────────────────────────────
func apply_all_display_settings(mode_id: int, res_w: int, res_h: int, fps: int, quality_id: int) -> void:
	display_mode = mode_id
	if res_w > 0:
		resolution_w = res_w
	if res_h > 0:
		resolution_h = res_h
	fps_target = fps
	graphics_quality = quality_id

	apply_fps(fps_target)
	apply_graphics_quality(graphics_quality)
	apply_display_mode(display_mode)

	save_settings()
	display_settings_changed.emit()
	validate_display_settings()

# ─────────────────────────────────────────────────────────────────────
# VALIDASI
# ─────────────────────────────────────────────────────────────────────
func validate_display_settings() -> Dictionary:
	var win: Window = get_window()
	if not is_instance_valid(win):
		return {}

	var data: Dictionary = {
		"mode":       win.mode,
		"size":       win.size,
		"screen":     win.current_screen,
		"borderless": win.borderless,
		"max_fps":    Engine.max_fps,
	}
	return data

# ─────────────────────────────────────────────────────────────────────
# SAVE
# ─────────────────────────────────────────────────────────────────────
func save_settings() -> void:
	var path := _get_settings_path()
	var config := ConfigFile.new()
	config.set_value("graphics", "display_mode",     display_mode)
	config.set_value("graphics", "resolution_w",     resolution_w)
	config.set_value("graphics", "resolution_h",     resolution_h)
	config.set_value("graphics", "fps_target",       fps_target)
	config.set_value("graphics", "graphics_quality", graphics_quality)
	var err: int = config.save(path)
	if err != OK:
		push_warning("[DisplaySettings] Gagal menyimpan: ", err)
	else:
		print("[DisplaySettings] Settings disimpan ke ", path)

	SaveManager.display_mode     = display_mode
	SaveManager.resolution_w     = resolution_w
	SaveManager.resolution_h     = resolution_h
	SaveManager.fps_limit        = fps_target
	SaveManager.graphics_quality = graphics_quality
	SaveManager.save_game()

# ─────────────────────────────────────────────────────────────────────
# LOAD
# ─────────────────────────────────────────────────────────────────────
func load_settings() -> void:
	var path := _get_settings_path()
	var config := ConfigFile.new()
	var err: int = config.load(path)
	if err == OK:
		display_mode     = config.get_value("graphics", "display_mode",     display_mode)
		resolution_w     = config.get_value("graphics", "resolution_w",     resolution_w)
		resolution_h     = config.get_value("graphics", "resolution_h",     resolution_h)
		fps_target       = config.get_value("graphics", "fps_target",       fps_target)
		graphics_quality = config.get_value("graphics", "graphics_quality", graphics_quality)
		print("[DisplaySettings] Settings dimuat dari ", path)
	else:
		display_mode     = SaveManager.display_mode
		resolution_w     = SaveManager.resolution_w
		resolution_h     = SaveManager.resolution_h
		fps_target       = SaveManager.fps_limit
		graphics_quality = SaveManager.graphics_quality

	apply_all_display_settings(display_mode, resolution_w, resolution_h, fps_target, graphics_quality)

# ─────────────────────────────────────────────────────────────────────
# RESET
# ─────────────────────────────────────────────────────────────────────
func reset_to_defaults() -> void:
	display_mode     = 0
	graphics_quality = 2
	fps_target       = 60
	_auto_detect_monitor_defaults()
	apply_all_display_settings(display_mode, resolution_w, resolution_h, fps_target, graphics_quality)