extends Node2D



func _ready()  -> void:
	get_tree().create_timer(2).timeout.connect(func():
		$Sprite.play("default")
		$OpenDoor.play()
		get_tree().create_timer(5).timeout.connect(get_tree().quit)
		)
	
