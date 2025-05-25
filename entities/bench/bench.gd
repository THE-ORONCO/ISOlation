extends Interactible

@onready var canvas: CanvasModulate = %Canvas

var resting: bool = false

func interact():
	if !resting :
		resting = true
		var tween := get_tree().create_tween()
		tween.tween_property(canvas, "color", Color.BLACK, 1).from(Color.WHITE)
		tween.tween_property(canvas, "color", Color.WHITE, 1).from(Color.BLACK)
		tween.tween_property(self, "resting", true, 0)
		HopeManager.hope = 5
		
