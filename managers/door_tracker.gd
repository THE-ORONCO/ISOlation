extends Node

var doors: Dictionary[NodePath, Color] = {}

func track(path: NodePath, color: Color) -> void:
	doors[path] = color
	
func color_for(path: NodePath) -> Color:
	return doors.get(path, Color.TRANSPARENT)
