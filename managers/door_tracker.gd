extends Node

var doors: Dictionary[String, Color] = {}

func track(path: String, color: Color) -> void:
	doors[path] = color
	
func color_for(path: String) -> Color:
	return doors.get(path, Color.TRANSPARENT)
