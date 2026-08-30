## DataManager.gd — Godot 4.7 GDScript
## Autoload Singleton untuk manajemen path data lokal secara aman
## Windows: C:/FlappyBird/Data/ (atau fallback ke user:// jika C:/ tidak writable)
## Android/iOS/Web: user:// (sesuai sandbox OS resmi)

extends Node

var base_data_dir: String = "user://"
var settings_path: String = "user://settings.cfg"
var savegame_path: String = "user://savegame.dat"

func _enter_tree() -> void:
	_init_data_paths()

func _init_data_paths() -> void:
	if OS.get_name() == "Windows":
		var win_custom_dir := "C:/FlappyBird/Data"
		var err := DirAccess.make_dir_recursive_absolute(win_custom_dir)
		if err == OK or DirAccess.dir_exists_absolute(win_custom_dir):
			base_data_dir = win_custom_dir
			print("[DataManager] Windows local storage active: ", base_data_dir)
		else:
			base_data_dir = "user://"
			print("[DataManager] Fallback to user:// for Windows storage")
	else:
		base_data_dir = "user://"
		print("[DataManager] Mobile/Standard storage active: ", base_data_dir)

	settings_path = base_data_dir.path_join("settings.cfg")
	savegame_path = base_data_dir.path_join("savegame.dat")
	print("[DataManager] Settings path: ", settings_path)
	print("[DataManager] Savegame path: ", savegame_path)

func get_settings_path() -> String:
	return settings_path

func get_savegame_path() -> String:
	return savegame_path