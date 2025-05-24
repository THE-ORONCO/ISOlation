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

@export_group("interaction")
@export_range(10, 50) var interact_prompt_max_height: float = 15
var _interact_prompt_height: float = 0
@export_range(1, 5) var interact_prompt_max_r: float = 3
var _r_interact_circle: float = 0
@export_range(.01, .5) var interact_prompt_popup_time: float = .1
var _show_interact_prompt: bool = false

@onready var agent: NavigationAgent2D = %Agent
var movement_delta: float
var _can_interact: bool = false

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
	if _show_interact_prompt:
		draw_circle(Vector2.UP * _interact_prompt_height, _r_interact_circle, Color.WHITE)

func _physics_process(delta):		
	var input: Vector2 = Input.get_vector("mv_left", "mv_right", "mv_up", "mv_down")
	_navigate_in_direction(input, delta)
	
	if Input.is_action_just_pressed("interact") && _can_interact:
		var areas: Array[Area2D] = %Interaction.get_overlapping_areas()
		for area in areas:
			var parent = area.get_parent()
			if parent != null && parent is Interactible:
				parent.interact()
		
		var bodies: Array[Node2D] = %Interaction.get_overlapping_bodies()
		for body in bodies:
			var parent = body.get_parent()
			if parent != null && parent is Interactible:
				parent.interact()

func _navigate_in_direction(input: Vector2, delta: float) -> void:
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


var _interact_tween: Tween = null
func _close_to_interactible(thing: Node2D) -> void:
	_can_interact = true
	_show_interact_prompt = true
	_tween_in_interact_prompt()

func _tween_in_interact_prompt():
	_interact_tween = get_tree().create_tween()
	# pop up interact prompt
	_interact_tween.parallel().tween_property(\
		self, \
		"_interact_prompt_height",\
		interact_prompt_max_height,\
		interact_prompt_popup_time)\
	.from(interact_prompt_max_height/2)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	
	# scale radius
	_interact_tween.parallel().tween_property(\
		self, \
		"_r_interact_circle",\
		interact_prompt_max_r,\
		interact_prompt_popup_time)\
	.from(0)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)

func _away_from_interactible(thing: Node2D) -> void:
	_can_interact = false
	_tween_out_interact_prompt()

func _tween_out_interact_prompt():
	_interact_tween = _interact_tween.chain()
	_interact_tween = get_tree().create_tween()
	# pop up interact prompt
	_interact_tween.parallel().tween_property(\
		self, \
		"_interact_prompt_height",\
		interact_prompt_max_height/2,\
		interact_prompt_popup_time)\
	.from(interact_prompt_max_height)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	
	# scale radius
	_interact_tween.parallel().tween_property(\
		self, \
		"_r_interact_circle",\
		0,\
		interact_prompt_popup_time)\
	.from(interact_prompt_max_r)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	
	_interact_tween.chain().tween_property(self, "_show_interact_prompt", false, 0)\
	.from(true)
