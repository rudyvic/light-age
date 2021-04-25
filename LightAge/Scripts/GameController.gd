extends Node

signal game_saved
signal game_loaded

var music = preload("res://Sound/music.wav")

var save_dict = {
		"last_level" : -1,
		"language" : "null",
		"is_muted" : false,
	}

# Called when the node enters the scene tree for the first time.
func _ready():
	set_is_muted(get_is_muted())
	$AudioStreamPlayer.stream = music
	$AudioStreamPlayer.play()

func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	
	# Store the save dictionary as a new line in the save file
	save_game.store_line(to_json(save_dict))
	save_game.close()
	emit_signal("game_saved")

func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return false# Error! We don't have a save to load.
	
	save_game.open("user://savegame.save", File.READ)
	save_dict = parse_json(save_game.get_line())
	
	save_game.close()
	emit_signal("game_loaded")
	return true

func get_last_level():
	load_game()
	return save_dict["last_level"]

func set_last_level(level: int):
	save_dict["last_level"] = level
	save_game()

func get_language():
	load_game()
	if(!save_dict.has("language") || (save_dict["language"] == "null")):
		save_dict["language"] = TranslationServer.get_locale()
	return save_dict["language"]

func set_language(language):
	TranslationServer.set_locale(language)
	save_dict["language"] = language
	save_game()

func set_is_muted(value: bool):
	save_dict["is_muted"] = value
	save_game()
	AudioServer.set_bus_mute(0,value)

func get_is_muted():
	load_game()
	if(save_dict.has("is_muted")):
		return save_dict["is_muted"]
	else:
		return false
