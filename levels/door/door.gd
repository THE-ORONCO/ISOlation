extends Node2D

signal door_entered()
signal interact_range_entered()
signal interact_range_exited()

@export_group("modulation")
@export var light_up_time: float = .2
@export_range(1,2) var modulate_target: float = 2


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
