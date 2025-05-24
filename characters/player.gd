extends CharacterBody2D

@export_range(1, 2000) var speed: float = 1500
@export_range(1, 20) var nav_lookahead: float = 5
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

@onready var agent: NavigationAgent2D = %Agent
var movement_delta: float

#func _physics_process(delta: float) -> void:
	#if Input.is_action_just_pressed("mv_accept"):
		#%Sprite.rotation = rot
	#
	#var dir: Vector2 = Input.get_vector("mv_left", "mv_right", "mv_up", "mv_down")
	#
	#agent.target_position = self.position + dir * speed
	#self.global_position = self.global_position.move_toward(agent.get_next_path_position(), delta)
#
#
	##
	#move_and_slide()
	#
	


func _ready() -> void:
	agent.velocity_computed.connect(Callable(_on_velocity_computed))

func set_movement_target(movement_target: Vector2):
	agent.set_target_position(movement_target)

var target_pos: Vector2 = Vector2.ZERO
var move_dir: Vector2 = Vector2.ZERO

func _draw() -> void:
	draw_circle(move_dir * nav_lookahead, 3, Color.RED)
	draw_line(Vector2.ZERO, move_dir * 20, Color.RED, 4)
	for point in agent.get_current_navigation_path():
		draw_circle(point - self.position, 2, Color.PINK)

func _physics_process(delta):	
	if Input.is_action_just_pressed("interact"):
		rot += PI / 3
		%Sprite.rotation = rot
	
	var input: Vector2 = Input.get_vector("mv_left", "mv_right", "mv_up", "mv_down")
	# skew input because we move asymmetrically
	move_dir = Vector2(input.x, input.y / 2)
	
	target_pos = self.global_position + move_dir * nav_lookahead
	queue_redraw()
	agent.target_position = target_pos
	
	
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer2D.map_get_iteration_id(agent.get_navigation_map()) == 0:
		return
	if agent.is_navigation_finished():
		return

	movement_delta = speed * delta
	var next_path_position: Vector2 = agent.get_next_path_position()
	var new_velocity: Vector2 = global_position.direction_to(next_path_position) * movement_delta
	
	self.velocity = new_velocity
	self.move_and_slide()
	
func _on_velocity_computed(safe_velocity: Vector2) -> void:
	global_position = global_position.move_toward(global_position + safe_velocity, movement_delta)
