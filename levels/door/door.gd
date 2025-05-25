@tool 
class_name Door 
extends Interactible

signal interact_range_entered()
signal interact_range_exited()

@export var target_level: String
@export_group("modulation")
@export var light_up_time: float = .2
@export_range(1,2) var modulate_target: float = 2

var _color: Color

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	_color = DoorTracker.color_for(self.get_path())
	queue_redraw()

func _draw() -> void:
	draw_circle(%Sprite.position, 3, _color)

func interact():
	HopeManager.decrease()
	DoorTracker.track(self.get_path(), Colors.PLAYER_COLOR)
	LevelManager.load_level(target_level)

func _get_configuration_warnings() -> PackedStringArray:
	var warn: PackedStringArray = []
	
	if target_level == null:
		warn.append("The door should lead somewhere! Please define a target level!")
	return warn 

func _entered_interact_range(body: Node2D) -> void:
	if body is CharacterBody2D:
		interact_range_entered.emit()
		get_tree().create_tween()\
		.tween_property(self, "modulate:v", modulate_target, light_up_time).from(1)

func _exited_interact_range(body: Node2D) -> void:
	self.modulate.v = 5
	if body is CharacterBody2D:
		interact_range_exited.emit()
		get_tree().create_tween()\
		.tween_property(self, "modulate:v", 1, light_up_time).from(modulate_target)
