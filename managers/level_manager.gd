extends Node

@export var levels: Array[PackedScene] = []

func level_exists(name: String) -> bool:
	return _find_level(name) != null

func load_level(name: String):
	get_tree().change_scene_to_packed.call_deferred(_find_level(name))

func _find_level(name: String) -> PackedScene:
	var found: PackedScene = null
	for level in levels:
		if level.name == name:
			found = level
	return found
