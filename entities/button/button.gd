@tool
extends Interactible

var affected_positions: Array[Marker2D]

func _get_configuration_warnings() -> PackedStringArray:
	var warn: PackedStringArray = []
	var markers: Array = self.get_children().filter(func(c): return c is Marker2D)
	
	if markers.size() == 0:
		warn.push_back("There should be at least one marker for the affected tile")
	
	return warn
