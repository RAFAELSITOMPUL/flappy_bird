extends Node

var music_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer] = []

var sfx_streams: Dictionary = {}
var music_streams: Dictionary = {}

var current_music_name: String = ""
const SFX_POOL_SIZE: int = 8

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Setup Music Player
	music_player = AudioStreamPlayer.new()
	music_player.bus = &"Master"
	music_player.finished.connect(_on_music_finished)
	add_child(music_player)
	
	# Setup SFX Player Pool
	for i in range(SFX_POOL_SIZE):
		var player = AudioStreamPlayer.new()
		player.bus = &"Master"
		add_child(player)
		sfx_players.append(player)
		
	# Load music assets
	_load_audio_file("menu_theme", "res://assets/audio/music/menu_theme.wav", true)
	_load_audio_file("gameplay_theme", "res://assets/audio/music/gameplay_theme.wav", true)
	_load_audio_file("main_theme", "res://assets/audio/music/menu_theme.wav", true) # Alias
	
	# Load SFX assets
	_load_audio_file("flap", "res://assets/audio/sfx/flap.wav", false)
	_load_audio_file("score", "res://assets/audio/sfx/score.wav", false)
	_load_audio_file("hit", "res://assets/audio/sfx/hit.wav", false)
	_load_audio_file("game_over", "res://assets/audio/sfx/game_over.wav", false)
	_load_audio_file("button_click", "res://assets/audio/sfx/button_click.wav", false)
	_load_audio_file("button_hover", "res://assets/audio/sfx/button_hover.wav", false)
	_load_audio_file("button", "res://assets/audio/sfx/button_click.wav", false) # Alias
	_load_audio_file("pause", "res://assets/audio/sfx/pause.wav", false)
	
	apply_settings()

func _load_audio_file(key: String, path: String, is_music: bool) -> void:
	if ResourceLoader.exists(path):
		var stream = load(path) as AudioStream
		if stream:
			if is_music:
				music_streams[key] = stream
			else:
				sfx_streams[key] = stream

func apply_settings() -> void:
	set_music_volume(SaveManager.music_volume)
	set_sfx_volume(SaveManager.sfx_volume)

func _on_music_finished() -> void:
	# Loop music seamlessly
	if SaveManager.music_enabled and not current_music_name.is_empty():
		if music_streams.has(current_music_name):
			music_player.stream = music_streams[current_music_name]
			music_player.volume_db = linear_to_db(SaveManager.music_volume)
			music_player.play()

func play_music(theme_name: String, fade_duration: float = 0.2) -> void:
	if not SaveManager.music_enabled:
		music_player.stop()
		current_music_name = theme_name
		return
		
	if current_music_name == theme_name and music_player.playing:
		return
		
	if not music_streams.has(theme_name):
		return
		
	current_music_name = theme_name
	var stream = music_streams[theme_name]
	
	if fade_duration > 0.0 and music_player.playing:
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", -80.0, fade_duration)
		tween.tween_callback(func():
			music_player.stream = stream
			music_player.volume_db = linear_to_db(SaveManager.music_volume)
			music_player.play()
		)
	else:
		music_player.stream = stream
		music_player.volume_db = linear_to_db(SaveManager.music_volume)
		music_player.play()

func stop_music(fade_duration: float = 0.2) -> void:
	if not music_player.playing:
		return
		
	if fade_duration > 0.0:
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", -80.0, fade_duration)
		tween.tween_callback(music_player.stop)
	else:
		music_player.stop()

func play_sfx(sfx_name: String) -> void:
	if not SaveManager.sfx_enabled:
		return
		
	if not sfx_streams.has(sfx_name):
		return
		
	var stream = sfx_streams[sfx_name]
	for player in sfx_players:
		if not player.playing:
			player.stream = stream
			player.volume_db = linear_to_db(SaveManager.sfx_volume)
			player.play()
			return

func set_music_volume(vol: float) -> void:
	SaveManager.music_volume = clamp(vol, 0.0, 1.0)
	if music_player:
		music_player.volume_db = linear_to_db(SaveManager.music_volume)
	if SaveManager.music_volume <= 0.001:
		music_player.stop()
	elif SaveManager.music_enabled and not music_player.playing and not current_music_name.is_empty():
		play_music(current_music_name, 0.0)

func set_sfx_volume(vol: float) -> void:
	SaveManager.sfx_volume = clamp(vol, 0.0, 1.0)

func set_music_enabled(enabled: bool) -> void:
	SaveManager.music_enabled = enabled
	if enabled:
		var theme = current_music_name if not current_music_name.is_empty() else "menu_theme"
		play_music(theme, 0.0)
	else:
		stop_music(0.0)
	SaveManager.save_game()

func set_sfx_enabled(enabled: bool) -> void:
	SaveManager.sfx_enabled = enabled
	SaveManager.save_game()

func toggle_music(enabled: bool) -> void:
	set_music_enabled(enabled)

func toggle_sfx(enabled: bool) -> void:
	set_sfx_enabled(enabled)
