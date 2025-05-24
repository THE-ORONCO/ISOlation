extends CharacterBody2D

@export_range(1, 100) var speed: float = 30
@export_range(0, 270, 120) var rot: float:
	get: return rot
	set(val): 
		rot = val
		set_collision_mask_value(1, true)
		set_collision_mask_value(2, true)
		set_collision_mask_value(3, true)
		match (rot):
			0: set_collision_mask_value(1, false)
			120: set_collision_mask_value(2, false)
			270: set_collision_layer_value(3, false)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		%Sprite.rotation = rot
	
	
	var dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	self.velocity = dir * speed
	
	move_and_slide()
