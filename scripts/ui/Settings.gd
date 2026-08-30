## Settings.gd — Godot 4.7 GDScript
## UI Settings: Audio + Graphics. Terhubung ke DisplaySettings autoload.

extends Control

signal back_pressed

# ── NODE REFERENCES ────────────────────────────────────────────────
@onready var tab_audio_btn:    Button        = %TabAudioButton
@onready var tab_graphics_btn: Button        = %TabGraphicsButton
@onready var audio_panel:      VBoxContainer = %AudioPanel
@onready var graphics_panel:   VBoxContainer = %GraphicsPanel

@onready var music_check:    CheckButton   = %MusicCheck
@onready var sfx_check:      CheckButton   = %SFXCheck
@onready var music_slider:   HSlider       = %MusicSlider
@onready var sfx_slider:     HSlider       = %SFXSlider
@onready var music_icon_btn: TextureButton = %MusicIconButton
@onready var sfx_icon_btn:   TextureButton = %SFXIconButton

@onready var quality_option:      OptionButton = %QualityOption
@onready var resolution_option:   OptionButton = %ResolutionOption
@onready var display_mode_option: OptionButton = %DisplayModeOption
@onready var fps_option:          OptionButton = %FPSOption

@onready var container_res:  HBoxContainer = %ContainerRes
@onready var container_mode: HBoxContainer = %ContainerMode

@onready var btn_apply:   Button = %BtnApply
@onready var btn_reset:   Button = %BtnReset
@onready var back_button: Button = %BackButton

# ── TEXTURES ───────────────────────────────────────────────────────
var music_on_tex  = preload("res://assets/textures/icons/music_on.png")
var music_off_tex = preload("res://assets/textures/icons/music_off.png")
var sfx_on_tex    = preload("res://assets/textures/icons/sfx_on.png")
var sfx_off_tex   = preload("res://assets/textures/icons/sfx_off.png")

var available_resolutions: Array[Vector2i] = []

# ── DISPLAYSETTINGS ACCESSOR ───────────────────────────────────────
var _ds: Node = null
func _get_ds() -> Node:
	if _ds == null or not is_instance_valid(_ds):
		_ds = get_node_or_null("/root/DisplaySettings")
	return _ds

# ── LOAD VALUES (alias dipanggil dari Main.gd) ─────────────────────
func load_values() -> void:
	_sync_ui_from_display_settings()

# ── READY ──────────────────────────────────────────────────────────
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	tab_audio_btn.pressed.connect(_on_tab_audio_pressed)
	tab_graphics_btn.pressed.connect(_on_tab_graphics_pressed)
	tab_audio_btn.mouse_entered.connect(_on_button_hover)
	tab_graphics_btn.mouse_entered.connect(_on_button_hover)

	music_check.toggled.connect(_on_music_toggled)
	sfx_check.toggled.connect(_on_sfx_toggled)
	music_slider.value_changed.connect(_on_music_slider_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_changed)

	if music_icon_btn:
		music_icon_btn.pressed.connect(_on_music_icon_pressed)
		music_icon_btn.mouse_entered.connect(func(): _on_icon_hover(music_icon_btn))
		music_icon_btn.mouse_exited.connect(func():  _on_icon_exit(music_icon_btn))

	if sfx_icon_btn:
		sfx_icon_btn.pressed.connect(_on_sfx_icon_pressed)
		sfx_icon_btn.mouse_entered.connect(func(): _on_icon_hover(sfx_icon_btn))
		sfx_icon_btn.mouse_exited.connect(func():  _on_icon_exit(sfx_icon_btn))

	_setup_graphics_dropdowns()

	btn_apply.pressed.connect(_on_apply_pressed)
	btn_reset.pressed.connect(_on_reset_pressed)
	back_button.pressed.connect(_on_back_pressed)
	btn_apply.mouse_entered.connect(_on_button_hover)
	btn_reset.mouse_entered.connect(_on_button_hover)
	back_button.mouse_entered.connect(_on_button_hover)

	_sync_ui_from_display_settings()
	show_audio_tab()

# ── SETUP DROPDOWNS ────────────────────────────────────────────────
func _setup_graphics_dropdowns() -> void:
	quality_option.clear()
	quality_option.add_item("LOW",    0)
	quality_option.add_item("MEDIUM", 1)
	quality_option.add_item("HIGH",   2)

	display_mode_option.clear()
	display_mode_option.add_item("Fullscreen",            0)
	display_mode_option.add_item("Borderless Fullscreen", 1)
	display_mode_option.add_item("Windowed",              2)

	fps_option.clear()
	fps_option.add_item("30 FPS",    30)
	fps_option.add_item("60 FPS",    60)
	fps_option.add_item("120 FPS",  120)
	fps_option.add_item("Unlimited",  0)

	available_resolutions.clear()
	resolution_option.clear()

	var ds: Node = _get_ds()
	if ds and ds.has_method("get_available_resolutions"):
		var resolutions: Array = ds.call("get_available_resolutions")
		for res in resolutions:
			available_resolutions.append(res)
			resolution_option.add_item("%d x %d" % [res.x, res.y])
	else:
		available_resolutions.append(Vector2i(1280, 720))
		resolution_option.add_item("1280 x 720")

	if OS.get_name() in ["Android", "iOS", "Web"]:
		container_res.visible  = false
		container_mode.visible = false

# ── SYNC UI ← DisplaySettings ─────────────────────────────────────
func _sync_ui_from_display_settings() -> void:
	music_check.button_pressed = SaveManager.music_enabled
	sfx_check.button_pressed   = SaveManager.sfx_enabled
	music_slider.value         = SaveManager.music_volume
	sfx_slider.value           = SaveManager.sfx_volume
	update_icons()

	var ds: Node = _get_ds()
	if ds == null:
		quality_option.select(clamp(SaveManager.graphics_quality, 0, 2))
		display_mode_option.select(clamp(SaveManager.display_mode, 0, 2))
		match SaveManager.fps_limit:
			30: fps_option.select(0)
			60: fps_option.select(1)
			120: fps_option.select(2)
			0:  fps_option.select(3)
			_:  fps_option.select(1)
		return

	quality_option.select(clamp(int(ds.get("graphics_quality")), 0, 2))
	display_mode_option.select(clamp(int(ds.get("display_mode")), 0, 2))

	var fp: int = int(ds.get("fps_target"))
	match fp:
		30:  fps_option.select(0)
		60:  fps_option.select(1)
		120: fps_option.select(2)
		0:   fps_option.select(3)
		_:   fps_option.select(1)

	var cur_res := Vector2i(int(ds.get("resolution_w")), int(ds.get("resolution_h")))
	var sel_idx: int = 0
	for i in range(available_resolutions.size()):
		if available_resolutions[i] == cur_res:
			sel_idx = i
			break
	if available_resolutions.size() > 0:
		resolution_option.select(sel_idx)

# ── APPLY ──────────────────────────────────────────────────────────
func _on_apply_pressed() -> void:
	AudioManager.play_sfx("button_click")
	var mode_id: int = display_mode_option.get_selected_id()
	var fps:     int = fps_option.get_selected_id()
	var quality: int = quality_option.get_selected_id()
	var res_w:   int = 0
	var res_h:   int = 0
	var res_idx: int = resolution_option.selected
	if res_idx >= 0 and res_idx < available_resolutions.size():
		res_w = available_resolutions[res_idx].x
		res_h = available_resolutions[res_idx].y

	var ds: Node = _get_ds()
	if ds and ds.has_method("apply_all_display_settings"):
		ds.call("apply_all_display_settings", mode_id, res_w, res_h, fps, quality)
	else:
		SaveManager.display_mode     = mode_id
		SaveManager.fps_limit        = fps
		SaveManager.graphics_quality = quality
		if res_w > 0:
			SaveManager.resolution_w = res_w
			SaveManager.resolution_h = res_h
		SaveManager.apply_graphics_settings()
		SaveManager.save_game()

	_sync_ui_from_display_settings()

# ── RESET ──────────────────────────────────────────────────────────
func _on_reset_pressed() -> void:
	AudioManager.play_sfx("button_click")
	var ds: Node = _get_ds()
	if ds and ds.has_method("reset_to_defaults"):
		ds.call("reset_to_defaults")
	else:
		SaveManager.reset_graphics_defaults()
	_sync_ui_from_display_settings()

# ── BACK ───────────────────────────────────────────────────────────
func _on_back_pressed() -> void:
	AudioManager.play_sfx("button_click")
	back_pressed.emit()

# ── TABS ───────────────────────────────────────────────────────────
func show_audio_tab() -> void:
	audio_panel.visible    = true
	graphics_panel.visible = false
	tab_audio_btn.modulate    = Color(1, 1, 1, 1)
	tab_graphics_btn.modulate = Color(0.7, 0.7, 0.7, 1)

func show_graphics_tab() -> void:
	audio_panel.visible    = false
	graphics_panel.visible = true
	tab_audio_btn.modulate    = Color(0.7, 0.7, 0.7, 1)
	tab_graphics_btn.modulate = Color(1, 1, 1, 1)

func _on_tab_audio_pressed() -> void:
	AudioManager.play_sfx("button_click")
	show_audio_tab()

func _on_tab_graphics_pressed() -> void:
	AudioManager.play_sfx("button_click")
	show_graphics_tab()

# ── AUDIO HANDLERS ─────────────────────────────────────────────────
func update_icons() -> void:
	if music_icon_btn:
		music_icon_btn.texture_normal = music_on_tex if SaveManager.music_enabled else music_off_tex
	if sfx_icon_btn:
		sfx_icon_btn.texture_normal   = sfx_on_tex  if SaveManager.sfx_enabled   else sfx_off_tex

func _on_music_icon_pressed() -> void:
	AudioManager.play_sfx("button_click")
	var s: bool = not SaveManager.music_enabled
	music_check.button_pressed = s
	AudioManager.toggle_music(s)
	update_icons()

func _on_sfx_icon_pressed() -> void:
	AudioManager.play_sfx("button_click")
	var s: bool = not SaveManager.sfx_enabled
	sfx_check.button_pressed = s
	AudioManager.toggle_sfx(s)
	update_icons()

func _on_music_toggled(on: bool) -> void:
	AudioManager.play_sfx("button_click")
	AudioManager.toggle_music(on)
	update_icons()

func _on_sfx_toggled(on: bool) -> void:
	AudioManager.play_sfx("button_click")
	AudioManager.toggle_sfx(on)
	update_icons()

func _on_music_slider_changed(value: float) -> void:
	AudioManager.set_music_volume(value)
	SaveManager.save_game()

func _on_sfx_slider_changed(value: float) -> void:
	AudioManager.set_sfx_volume(value)
	SaveManager.save_game()

# ── HOVER ──────────────────────────────────────────────────────────
func _on_button_hover() -> void:
	AudioManager.play_sfx("button_hover")

func _on_icon_hover(btn: TextureButton) -> void:
	AudioManager.play_sfx("button_hover")
	btn.pivot_offset = btn.size / 2.0
	create_tween().tween_property(btn, "scale", Vector2(1.1, 1.1), 0.1)

func _on_icon_exit(btn: TextureButton) -> void:
	btn.pivot_offset = btn.size / 2.0
	create_tween().tween_property(btn, "scale", Vector2(1.0, 1.0), 0.1)
