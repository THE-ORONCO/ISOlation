extends Node

@export var levels: Array[PackedScene]

func load_level(level_name: String):
	get_tree().change_scene_to_file.call_deferred("res://levels/%s.tscn" % level_name)
